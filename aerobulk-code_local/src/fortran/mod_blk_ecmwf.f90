! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

MODULE mod_blk_ecmwf

   !!====================================================================================
   !!       Computes turbulent components of surface fluxes
   !!         according to IFS of the ECMWF
   !!
   !!   Momentum, Latent and sensible heat exchange coefficients
   !!
   !!
   !!            Author: Laurent Brodeau, brodeau@gmail.com
   !!               (originally coded for the NEMO Ocean GCM)
   !!
   !!====================================================================================

   USE mod_const   !: physical and othe constants
   USE mod_thermo  !: thermodynamics

   IMPLICIT NONE
   PRIVATE

   PUBLIC :: TURB_ECMWF_2Z

   !! ECMWF own values for given constants, taken form IFS documentation...
   REAL(wp),    PARAMETER :: &
                                !!
        & charn0 = 0.018, &      !:  Charnock constant (pretty high value here!!!
                                !!                   ! Usually 0.011 for moderate winds)
                                !!
        &   zi0     = 1000., &   !: scale height of the atmospheric boundary layer...1
        &  Beta0    = 1. , &     !: gustiness parameter ( = 1.25 in COAREv3)
                                !!
        &   alpha_M = 0.11,  &   ! For roughness length (smooth surface term)
        &   alpha_H = 0.40,  &   ! (Chapter 3, p.34, IFS doc Cy31r1)
        &   alpha_Q = 0.62


CONTAINS

   SUBROUTINE TURB_ECMWF_2Z(zt, zu, sst, t_zt, ssq, q_zt, U_zu, &
        &                   Cd, Ch, Ce, t_zu, q_zu, U_blk)

      !!----------------------------------------------------------------------
      !!                      ***  ROUTINE  turb_ecmwf  ***
      !!
	  !!            2015: L. Brodeau (brodeau@gmail.com)
	  !!
      !! ** Purpose :   Computes turbulent transfert coefficients of surface
      !!                fluxes according to IFS doc. (cycle 31)
      !!                If relevant (zt /= zu), adjust temperature and humidity from height zt to zu
      !!
      !! ** Method : Monin Obukhov Similarity Theory
      !!======================================================================================
      !!
      !! INPUT :
      !! -------
      !!    *  zt   : height for temperature and spec. hum. of air            [m]
      !!    *  zu   : height for wind speed (generally 10m)                   [m]
      !!    *  U_zu : scalar wind speed at 10m                                [m/s]
      !!    *  sst  : SST                                                     [K]
      !!    *  t_zt : potential air temperature at zt                         [K]
      !!    *  ssq  : specific humidity at saturation at SST                  [kg/kg]
      !!    *  q_zt : specific humidity of air at zt                          [kg/kg]
      !!
      !!
      !! OUTPUT :
      !! --------
      !!    *  Cd     : drag coefficient
      !!    *  Ch     : sensible heat coefficient
      !!    *  Ce     : evaporation coefficient
      !!    *  t_zu   : pot. air temperature adjusted at wind height zu       [K]
      !!    *  q_zu   : specific humidity of air        //                    [kg/kg]
      !!    *  U_blk  : bulk wind at 10m                                      [m/s]
      !!
      !! OPTIONAL :
      !! ----------
      !!
      !!
      !!============================================================================


      REAL(wp), INTENT(in   )                     ::   zt       ! height for t_zt and q_zt                   [m]
      REAL(wp), INTENT(in   )                     ::   zu       ! height for U_zu                              [m]
      REAL(wp), INTENT(in   ), DIMENSION(jpi,jpj) ::   sst      ! sea surface temperature              [Kelvin]
      REAL(wp), INTENT(in   ), DIMENSION(jpi,jpj) ::   t_zt     ! potential air temperature            [Kelvin]
      REAL(wp), INTENT(in   ), DIMENSION(jpi,jpj) ::   ssq    ! sea surface specific humidity         [kg/kg]
      REAL(wp), INTENT(in   ), DIMENSION(jpi,jpj) ::   q_zt     ! specific air humidity                 [kg/kg]
      REAL(wp), INTENT(in   ), DIMENSION(jpi,jpj) ::   U_zu       ! relative wind module at zu            [m/s]
      REAL(wp), INTENT(  out), DIMENSION(jpi,jpj) ::   Cd       ! transfer coefficient for momentum         (tau)
      REAL(wp), INTENT(  out), DIMENSION(jpi,jpj) ::   Ch       ! transfer coefficient for sensible heat (Q_sens)
      REAL(wp), INTENT(  out), DIMENSION(jpi,jpj) ::   Ce       ! transfert coefficient for evaporation   (Q_lat)
      REAL(wp), INTENT(  out), DIMENSION(jpi,jpj) ::   t_zu     ! air temp. shifted at zu                     [K]
      REAL(wp), INTENT(  out), DIMENSION(jpi,jpj) ::   q_zu     ! spec. hum.  shifted at zu               [kg/kg]
      REAL(wp), INTENT(  out), DIMENSION(jpi,jpj) ::   U_blk    ! bulk wind at 10m                          [m/s]

      INTEGER :: j_itt
      LOGICAL ::   l_zt_equal_zu = .FALSE.      ! if q and t are given at same height as U

      REAL(wp), DIMENSION(:,:), ALLOCATABLE  ::  &
           &  u_star, t_star, q_star, &
           &  dt_zu, dq_zu,    &
           &  znu_a,           & !: Nu_air, Viscosity of air
           &  Linv,            & !: 1/L (inverse of Monin Obukhov length...
           &  z0m, z0t, z0q
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   func_m, func_h
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   ztmp0, ztmp1, ztmp2

      ALLOCATE ( u_star(jpi,jpj), t_star(jpi,jpj), q_star(jpi,jpj), &
           &     func_m(jpi,jpj), func_h(jpi,jpj),  &
           &     dt_zu(jpi,jpj), dq_zu(jpi,jpj),    &
           &     znu_a(jpi,jpj), Linv(jpi,jpj),   &
           &     z0m(jpi,jpj), z0t(jpi,jpj), z0q(jpi,jpj), &
           &     ztmp0(jpi,jpj), ztmp1(jpi,jpj), ztmp2(jpi,jpj) )



      !! Identical first gess as in COARE, with IFS parameter values though
      !! ==================================================================

      l_zt_equal_zu = .FALSE.
      IF( ABS(zu - zt) < 0.01 ) l_zt_equal_zu = .TRUE.    ! testing "zu == zt" is risky with double precision


      !! First guess of temperature and humidity at height zu:
      t_zu = t_zt ; q_zu = q_zt

      !! Pot. temp. difference (and we don't want it to be 0!)
      dt_zu = t_zu - sst ;  dt_zu = sign( max(abs(dt_zu),1.E-6), dt_zu )
      dq_zu = q_zu - ssq

      znu_a = visc_air(t_zt) ! Air viscosity (m^2/s) at zt given from temperature in (K)

      ztmp2 = 0.5*0.5  ! initial guess for wind gustiness contribution
      U_blk = SQRT(U_zu*U_zu + ztmp2)

      z0m    = 0.0001
      u_star = 0.035*U_blk*log(10./z0m)/log(zu/z0m)       ! (u* = 0.035*Un10)
      ztmp0  = znu_a/u_star
      z0m    = alpha_M*ztmp0 + charn0*u_star*u_star/grav
      z0t    = alpha_H*ztmp0                              ! eq.3.26, Chap.3, p.34, IFS doc - Cy31r1
      Cd     = (vkarmn/log(zu/z0m))**2    ! first guess of Cd


      ztmp0 = vkarmn*vkarmn/log(zt/z0t)/Cd

      ztmp2 = Ri_bulk(zu, t_zu, dt_zu, q_zu, dq_zu, U_blk) ; ! Ribu = Bulk Richardson number

      !! First estimate of zeta_u, depending on the stability, ie sign of Ribu (ztmp2):
      ztmp1 = 0.5 + sign(0.5 , ztmp2)
      func_m = ztmp0*ztmp2 ! temporary array !!!
      func_h = (1.-ztmp1)*(func_m/(1.+ztmp2/(-zu/(zi0*0.004*Beta0**3)))) &  ! temporary array !!! func_h == zeta_u
           &  +     ztmp1*(func_m*(1. + 27./9.*ztmp2/ztmp0))

      !! First guess M-O stability dependent scaling params.(u*,t*,q*) to estimate z0m and z/L
      ztmp0   =        vkarmn/(log(zu/z0t) - psi_h_ecmwf(func_h))

      u_star = U_blk*vkarmn/(log(zu/z0m)  - psi_m_ecmwf(func_h))
      t_star = dt_zu*ztmp0
      q_star = dq_zu*ztmp0

      ! What's need to be done if zt /= zu:
      IF ( .NOT. l_zt_equal_zu ) THEN

         !! First update of values at zu (or zt for wind)
         ztmp0 = psi_h_ecmwf(func_h) - psi_h_ecmwf(zt*func_h/zu)    ! zt*func_h/zu == zeta_t
         ztmp1 = log(zt/zu) + ztmp0
         t_zu = t_zt - t_star/vkarmn*ztmp1
         q_zu = q_zt - q_star/vkarmn*ztmp1
         q_zu = (0.5 + sign(0.5,q_zu))*q_zu !Makes it impossible to have negative humidity :

         dt_zu = t_zu - sst !; dt_zu = sign( max(abs(dt_zu),1.E-6), dt_zu )
         dq_zu = q_zu - ssq

      END IF


      !! => that was same first guess as in COARE...


      !! First guess of inverse of Monin-Obukov length (1/L) :
      ztmp0 = (1. + rctv0*q_zu)  ! the factor to apply to temp. to get virt. temp...
      Linv  =  grav*vkarmn*(t_star*ztmp0 + rctv0*t_zu*q_star) / ( u_star*u_star * t_zu*ztmp0 )

      !! Functions such as  u* = U_blk*vkarmn/func_m
      ztmp1 = zu + z0m
      ztmp0 = ztmp1*Linv
      func_m = log(ztmp1/z0m) - psi_m_ecmwf(ztmp0) + psi_m_ecmwf(z0m*Linv)
      func_h = log(ztmp1/z0t) - psi_h_ecmwf(ztmp0) + psi_h_ecmwf(z0t*Linv)


      !! ITERATION BLOCK
      !! ***************

      DO j_itt = 1, nb_itt

         !! Bulk Richardson Number at z=zu (Eq. 3.25)
         ztmp0 = Ri_bulk(zu, t_zu, dt_zu, q_zu, dq_zu, U_blk)

         !! New estimate of the inverse of the Monin-Obukhon length (Linv == zeta/zu) :
         Linv = ztmp0*func_m*func_m/func_h / zu     ! From Eq. 3.23, Chap.3, p.33, IFS doc - Cy31r1

         IF ( (jpi==1).AND.(jpj==1) ) THEN
            PRINT *, ''
            PRINT *, 'Monin-Obukhov length (ecmwf) =', 1./Linv
         END IF


         !! Update func_m with new Linv:
         ztmp1 = zu + z0m
         func_m = log(ztmp1/z0m) - psi_m_ecmwf(ztmp1*Linv) + psi_m_ecmwf(z0m*Linv)

         !! Need to update roughness lengthes:
         u_star = U_blk*vkarmn/func_m
         ztmp2  = u_star*u_star
         ztmp1  = znu_a/u_star
         z0m    = alpha_M*ztmp1 + charn0*ztmp2/grav
         z0t    = alpha_H*ztmp1                              ! eq.3.26, Chap.3, p.34, IFS doc - Cy31r1
         z0q    = alpha_Q*ztmp1

         !! Update wind at 10m taking into acount convection-related wind gustiness:
         ! Only true when unstable (L<0) => when ztmp0 < 0 => - !!!
         ztmp2 = ztmp2 * (MAX(-zi0*Linv/vkarmn,0.))**(2./3.) ! => w*^2  (combining Eq. 3.8 and 3.18, hap.3, IFS doc - Cy31r1)
         !! => equivalent using Beta=1 (gustiness parameter, 1.25 for COARE, also zi0=600 in COARE..)
         U_blk = MAX(sqrt(U_zu*U_zu + ztmp2), 0.2)              ! eq.3.17, Chap.3, p.32, IFS doc - Cy31r1
         ! => 0.2 prevents U_blk to be 0 in stable case when U_zu=0.


         !! Need to update "theta" and "q" at zu in case they are given at different heights
         !! as well the air-sea differences:
         IF ( .NOT. l_zt_equal_zu ) THEN

            !! Arrays func_m and func_h are free for a while so using them as temporary arrays...
            func_h = psi_h_ecmwf((zu+z0m)*Linv) ! temporary array !!!
            func_m = psi_h_ecmwf((zt+z0m)*Linv) ! temporary array !!!

            ztmp2  = psi_h_ecmwf(z0t*Linv)
            ztmp0  = func_h - ztmp2
            ztmp1  = vkarmn/(log((zu+z0m)/z0t) - ztmp0)
            t_star = dt_zu*ztmp1
            ztmp2  = ztmp0 - func_m + ztmp2
            ztmp1  = log(zt/zu) + ztmp2
            t_zu   = t_zt - t_star/vkarmn*ztmp1

            ztmp2  = psi_h_ecmwf(z0q*Linv)
            ztmp0  = func_h - ztmp2
            ztmp1  = vkarmn/(log((zu+z0m)/z0q) - ztmp0)
            q_star = dq_zu*ztmp1
            ztmp2  = ztmp0 - func_m + ztmp2
            ztmp1  = log(zt/zu) + ztmp2
            q_zu   = q_zt - q_star/vkarmn*ztmp1

            dt_zu = t_zu - sst
            dq_zu = q_zu - ssq

         END IF

         !! Updating because of updated z0m and z0t and new Linv...
         ztmp1 = zu + z0m
         ztmp0 = ztmp1*Linv
         func_m = log(ztmp1/z0m) - psi_m_ecmwf(ztmp0) + psi_m_ecmwf(z0m*Linv)
         func_h = log(ztmp1/z0t) - psi_h_ecmwf(ztmp0) + psi_h_ecmwf(z0t*Linv)

      END DO

      Cd = vkarmn*vkarmn/(func_m*func_m)

      Ch = vkarmn*vkarmn/(func_m*func_h)

      ztmp1 = log((zu + z0m)/z0q) - psi_h_ecmwf((zu + z0m)*Linv) + psi_h_ecmwf(z0q*Linv)   ! func_q
      Ce = vkarmn*vkarmn/(func_m*ztmp1)



      DEALLOCATE ( u_star, t_star, q_star, func_m, func_h, &
           &       dt_zu, dq_zu, z0m, z0t, z0q, znu_a, Linv, ztmp0, ztmp1, ztmp2 )

   END SUBROUTINE TURB_ECMWF_2Z





   FUNCTION psi_m_ecmwf(zta)

      !! EMPIRICAL STABILITY FUNCTION PSI for momentum
      !! Both unstable and stable ABL

      REAL(wp), DIMENSION(jpi,jpj) :: psi_m_ecmwf
      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: zta

      REAL(wp), DIMENSION(:,:), ALLOCATABLE :: zzeta, rx, psi_unstable, psi_stable, stabit

      ALLOCATE ( zzeta(jpi,jpj), rx(jpi,jpj), psi_unstable(jpi,jpj), psi_stable(jpi,jpj), stabit(jpi,jpj) )

      zzeta = MIN(zta,5.) !! Very stable conditions (L positif and big!):

      !! Unstable:
      !! =========
      !! eq.3.19, Chap.3, p.33, IFS doc - Cy31r1

      !rx  = ABS(1. - 16.*zzeta)**.25      !! this is actually 1/phi_m !!!
      !!                                !!
      !! Unstable (Paulson 1970) :
      !! eq.3.20, Chap.3, p.33, IFS doc - Cy31r1
      !psi_unstable = 2.*LOG((1. + rx)/2.) + LOG((1. + rx*rx)/2.)   &
      !     &        - 2.*ATAN(rx) + 1.5707963                                ! Pi/2 = 1.5707963

      !! Exactly equivalent to:
      rx = SQRT(ABS(1. - 16.*zzeta))
      psi_unstable = LOG( (1.0 + SQRT(rx))**2       &
           &             *(1.0 +      rx)*0.125 )   &
           &        -2.0 * ATAN( SQRT(rx) )         &
           &        + 1.5707963


      !! Unstable:
      !! =========
      !! eq.3.22, Chap.3, p.33, IFS doc - Cy31r1

      psi_stable = -2./3.*(zzeta - 5./0.35)*exp(-0.35*zzeta) - 1.*zzeta - 2./3.*5./0.35


      !! Combining:

      stabit = 0.5 + SIGN(0.5, zzeta) ! zzeta > 0 => stabit = 1

      psi_m_ecmwf = (1. - stabit)*psi_unstable & ! (zzeta < 0) Unstable
           &         + stabit*psi_stable  ! (zzeta > 0) Stable

      DEALLOCATE ( zzeta, rx, psi_unstable, psi_stable, stabit )

   END FUNCTION psi_m_ecmwf




   FUNCTION psi_h_ecmwf(zta)

      REAL(wp), DIMENSION(jpi,jpj) :: psi_h_ecmwf
      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: zta
      !!
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::  zzeta, rx, psi_unstable, psi_stable, stabit

      ALLOCATE ( zzeta(jpi,jpj), rx(jpi,jpj), psi_unstable(jpi,jpj), psi_stable(jpi,jpj), stabit(jpi,jpj) )

      zzeta = MIN(zta,5.) !! Very stable conditions (L positif and big!):

      rx  = ABS(1. - 16.*zzeta)**.25      !! this is actually (1/phi_m)**2  !!!
      !!                                !! eq.3.19, Chap.3, p.33, IFS doc - Cy31r1

      !! Unstable (Paulson 1970) :
      psi_unstable = 2.*LOG((1. + rx*rx)/2.)   !! eq.3.20, Chap.3, p.33, IFS doc - Cy31r1

      !PRINT *, 'LOLO psi_h_ecmwf: psi_unstable => ', psi_unstable

      !! Stable:
      psi_stable = -2./3.*(zzeta - 5./0.35)*exp(-0.35*zzeta) - ABS(1. + 2./3.*1.*zzeta)**1.5 - 2./3.*5./0.35 + 1. !! eq.3.22, Chap.3, p.33, IFS doc - Cy31r1
      !! LOLO: added ABS() to avoid NaN values when unstable, which contaminates the unstable solution...

      !PRINT *, 'LOLO psi_h_ecmwf: psi_stable => ', psi_stable

      stabit = 0.5 + SIGN(0.5, zzeta) ! zzeta > 0 => stabit = 1

      !PRINT *, 'LOLO psi_h_ecmwf: stabit => ', stabit

      psi_h_ecmwf = (1. - stabit)*psi_unstable & ! (zzeta < 0) Unstable
           &         + stabit*psi_stable  ! (zzeta > 0) Stable

      DEALLOCATE ( zzeta, rx, psi_unstable, psi_stable, stabit )

   END FUNCTION psi_h_ecmwf



   FUNCTION Ri_bulk(pz, ptz, pdt, pqz, pdq, pub)

      !! 2015: L. Brodeau  Eq. 3.25 IFS doc...

      !! Bulk Richardson number

      REAL(wp), DIMENSION(jpi,jpj) :: Ri_bulk

      REAL(wp), INTENT(in) :: pz  !: height above the sea [m]

      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: ptz, & !: air temperature at pz m [K]
           &                                      pdt, & !: ptz - sst               [K]
           &                                      pqz, & !: air temperature at pz m [kg/kg]
           &                                      pdq, & !: pqz - ssq               [kg/kg]
           &                                      pub    !: bulk wind speed         [m/s]

      REAL(wp), DIMENSION(:,:), ALLOCATABLE :: zcp  !: heat capacity of moist air based the specific humidity

      ALLOCATE ( zcp(jpi,jpj) )

      zcp = Cp_dry + Cp_vap*pqz

      Ri_bulk = grav*pz/(pub*pub) * ( pdt/(ptz - 0.5_wp*(pdt + grav*pz/zcp)) + rctv0*pdq )

      !! lolo: rctv0 or reps0 ???

      DEALLOCATE ( zcp )

   END FUNCTION Ri_bulk





   !  FUNCTION VT_flux(ta, qa, us, ts, qs)
   !
   !    !! 2015: L. Brodeau  eq. 3.8 (Qov) IFS doc...
   !
   !    REAL(wp), DIMENSION(jpi,jpj) :: VT_flux
   !    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: ta, qa, us, ts, qs
   !
   !    !! From IFS Doc. Cy31r1, p. 31, Eq. 3.8:
   !
   !    ! Virtual temperature flux in the surface layer:
   !    VT_flux = grav/ta * ( us*ts - (Cp_vap - Cp_dry)*ta*us*qs )/Cp_moist_air(qa) + (R_vap/R_dry -1)*ta*us*qs
   !
   !  END FUNCTION VT_flux



END MODULE mod_blk_ecmwf
