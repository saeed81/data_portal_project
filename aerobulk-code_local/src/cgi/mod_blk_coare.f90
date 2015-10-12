! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

MODULE mod_blk_coare

   !!====================================================================================
   !!       Computes turbulent components of surface fluxes
   !!         according to Fairall et al. 2003 (COARE v3)
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

   PUBLIC :: TURB_COARE_2Z

   !! COARE own values for given constants:
   REAL(wp), PARAMETER :: &
        &    charn0 = 0.011, &   !: Charnock constant
                                !!                       !:   => usually 0.011 for moderate winds (Smith, 1988)
        &   zi0     = 600.,  &   !: scale height of the atmospheric boundary layer...1
        &  Beta0    = 1.25       !: gustiness parameter


CONTAINS

   SUBROUTINE turb_coare_2z(zt, zu, sst, t_zt, ssq, q_zt, U_zu, &
        &                   Cd, Ch, Ce, t_zu, q_zu, U_blk, l_charn_cst)


      !!----------------------------------------------------------------------
      !!                      ***  ROUTINE  turb_coare  ***
      !!
	  !!            2015: L. Brodeau (brodeau@gmail.com)
	  !!
      !! ** Purpose :   Computes turbulent transfert coefficients of surface
      !!                fluxes according to Fairall et al. (2003)
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
      !!    * l_charn_cst : whether Charnock constant is taken as a constant (0.011) or wind-dependent?
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
      LOGICAL,  INTENT(in   ), OPTIONAL           :: l_charn_cst ! set to true to use a constant Charnock parameter (0.011)

      INTEGER :: j_itt
      LOGICAL ::   l_zt_equal_zu = .FALSE.      ! if q and t are given at same height as U

      REAL(wp), DIMENSION(:,:), ALLOCATABLE  ::  &
           &  u_star, t_star, q_star, &
           &  dt_zu, dq_zu,    &
           &  znu_a,           & !: Nu_air, Viscosity of air
           &  z0, z0t
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   zeta_u        ! stability parameter at height zu
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   zeta_t        ! stability parameter at height zt
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   ztmp0, ztmp1, ztmp2

      LOGICAL :: lcc   = .FALSE.


      ALLOCATE ( u_star(jpi,jpj), t_star(jpi,jpj), q_star(jpi,jpj), &
           &     zeta_u(jpi,jpj),  &
           &     dt_zu(jpi,jpj), dq_zu(jpi,jpj),    &
           &     znu_a(jpi,jpj),   &
           &     z0(jpi,jpj), z0t(jpi,jpj),         &
           &     ztmp0(jpi,jpj), ztmp1(jpi,jpj), ztmp2(jpi,jpj) )


      IF ( PRESENT(l_charn_cst) ) lcc = l_charn_cst


      l_zt_equal_zu = .FALSE.
      IF( ABS(zu - zt) < 0.01 ) l_zt_equal_zu = .TRUE.    ! testing "zu == zt" is risky with double precision

      IF( .NOT. l_zt_equal_zu )   ALLOCATE ( zeta_t(jpi,jpj) )

      !! First guess of temperature and humidity at height zu:
      t_zu = t_zt ; q_zu = q_zt

      !! Pot. temp. difference (and we don't want it to be 0!)
      dt_zu = t_zu - sst ;  dt_zu = sign( max(abs(dt_zu),1.E-6), dt_zu )
      dq_zu = q_zu - ssq

      znu_a = visc_air(t_zt) ! Air viscosity (m^2/s) at zt given from temperature in (K)

      ztmp2 = 0.5*0.5  ! initial guess for wind gustiness contribution
      U_blk = SQRT(U_zu*U_zu + ztmp2)

      ! z0     = 0.0001
      ztmp2   = 10000.     ! optimization: ztmp2 == 1/z0
      ztmp0   = log(zu*ztmp2)
      ztmp1   = log(10.*ztmp2)
      u_star = 0.035*U_blk*ztmp1/ztmp0       ! (u* = 0.035*Un10)
      z0     = charn0*u_star*u_star/grav + 0.11*znu_a/u_star
      z0t    = 10./exp(vkarmn/(0.00115/(vkarmn/ztmp1)))
      Cd     = (vkarmn/ztmp0)**2    ! first guess of Cd

      ztmp0 = vkarmn*vkarmn/log(zt/z0t)/Cd

      !Ribcu = -zu/(zi0*0.004*Beta0**3) !! Saturation Rib, zi0 = tropicalbound. layer depth
      ztmp2  = grav*zu*(dt_zu + rctv0*t_zu*dq_zu)/(t_zu*U_blk**2)  !! Ribu Bulk Richardson number
      ztmp1 = 0.5 + sign(0.5 , ztmp2)
      !!             Ribu < 0                                 Ribu > 0   Beta = 1.25
      zeta_u = (1.-ztmp1)*(ztmp0*ztmp2/(1.+ztmp2/(-zu/(zi0*0.004*Beta0**3)))) &
           &  + ztmp1*(ztmp0*ztmp2*(1.+27./9.*ztmp2/ztmp0))

      !! First guess M-O stability dependent scaling params.(u*,t*,q*) to estimate z0 and z/L
      ztmp0   =        vkarmn/(log(zu/z0t) - psi_h_coare(zeta_u))

      u_star = U_blk*vkarmn/(log(zu/z0)  - psi_m_coare(zeta_u))
      t_star = dt_zu*ztmp0
      q_star = dq_zu*ztmp0

      ! What's need to be done if zt /= zu:
      IF ( .NOT. l_zt_equal_zu ) THEN

         zeta_t = zt*zeta_u/zu

         !! First update of values at zu (or zt for wind)
         ztmp0 = psi_h_coare(zeta_u) - psi_h_coare(zeta_t)
         ztmp1 = log(zt/zu) + ztmp0
         t_zu = t_zt - t_star/vkarmn*ztmp1
         q_zu = q_zt - q_star/vkarmn*ztmp1
         q_zu = (0.5 + sign(0.5,q_zu))*q_zu !Makes it impossible to have negative humidity :

         dt_zu = t_zu - sst !; dt_zu = sign( max(abs(dt_zu),1.E-6), dt_zu )
         dq_zu = q_zu - ssq

      END IF




      !! ITERATION BLOCK
      !! ***************

      DO j_itt = 1, nb_itt

         !!Inverse of Monin-Obukov length (1/L) :
         ztmp0 = One_on_L_MonObkv(t_zu, q_zu, u_star, t_star, q_star)  ! 1/L == 1/[Monin-Obukhov length]

         ztmp1 = u_star*u_star   ! u*^2

         !! Update wind at 10m taking into acount convection-related wind gustiness:
         ! Ug = Beta*w*  (Beta = 1.25, Fairall et al. 2003, Eq.8):
         ztmp2 = Beta0*Beta0*ztmp1*(MAX(-zi0*ztmp0/vkarmn,0.))**(2./3.)   ! => ztmp2 == Ug^2
         !!   ! Only true when unstable (L<0) => when ztmp0 < 0 => explains "-" before 600.
         U_blk = MAX(sqrt(U_zu*U_zu + ztmp2), 0.2)        ! include gustiness in bulk wind speed
         ! => 0.2 prevents U_blk to be 0 in stable case when U_zu=0.

         IF ( (ldebug_blk_algos).AND.(jpi==1).AND.(jpj==1).AND.(j_itt == nb_itt) ) THEN
            !PRINT *, ''
            !PRINT *, 'Gustiness contribution to wind =', SQRT(ztmp2)
            !PRINT *, ''
         END IF

         IF ( lcc ) THEN
            ztmp2 = charn0
         ELSE
            !! Updating charnock constant if we chose the non-constant form:
            !!    Charnock's constant, increases with the wind :
            !!    Controverse # 1 : should charnock cst increase wind the wind or stay at 0.011
            !!    (Fairall et al., 2003 p. 577-578
            ztmp2 = alfa_charn(U_blk)  ! charn
         END IF

         !! Roughness lengthes z0, z0t (z0q = z0t) :
         z0   = ztmp2*ztmp1/grav + 0.11*znu_a/u_star ! Roughness length (eq.6)
         ztmp1 = z0*u_star/znu_a                             ! Re_r: roughness Reynolds number
         z0t  = min( 1.1E-4 , 5.5E-5*ztmp1**(-0.6) )         ! Scalar roughness for both theta and q (eq.28)

         !! Stability parameters:
         zeta_u = zu*ztmp0 ; zeta_u = sign( min(abs(zeta_u),50.0), zeta_u )
         IF ( .NOT. l_zt_equal_zu ) THEN
            zeta_t = zt*ztmp0 ;  zeta_t = sign( min(abs(zeta_t),50.0), zeta_t )
         END IF


         !! Turbulent scales at zu=10m :
         ztmp0   = psi_h_coare(zeta_u)
         ztmp1   = vkarmn/(log(zu/z0t) - ztmp0)

         t_star = dt_zu*ztmp1
         q_star = dq_zu*ztmp1
         u_star = U_blk*vkarmn/(log(zu/z0) - psi_m_coare(zeta_u))

         IF ( .NOT. l_zt_equal_zu ) THEN
            ! What's need to be done if zt /= zu
            !! Re-updating temperature and humidity at zu :
            ztmp2 = ztmp0 - psi_h_coare(zeta_t)
            ztmp1 = log(zt/zu) + ztmp2
            t_zu = t_zt - t_star/vkarmn*ztmp1
            q_zu = q_zt - q_star/vkarmn*ztmp1
            dt_zu = t_zu - sst
            dq_zu = q_zu - ssq
         END IF

         !! Updating wind at zt :
         !U_zt  = U_zu + u_star/vkarmn &
         !     & *(log(zt/zu) - psi_m_coare(zeta_t) + psi_m_coare(zeta_u))
         !! Makes it impossible to have negative humidity :
         !ztmp0 = 0.5 + sign(0.5,q_zu) ;  q_zu = ztmp0*q_zu


      END DO

      !! Webb correction to latent heat flux already in ef via z0t/Re_r function
      !! Wbar=-1.61*u_star*q_star/(1+1.61*q)-u_star*t_star/(t+rt0)

      !! compute transfer coefficients at zu :
      ztmp0 = u_star/U_blk
      Cd   = ztmp0*ztmp0
      Ch   = ztmp0*t_star/dt_zu       !ch  = ztmp0*t_star/(-dt_zu + reps)
      Ce   = ztmp0*q_star/dq_zu       !ce  = ztmp0*q_star/(-dq_zu + 0.001*reps)


      IF ( (ldebug_blk_algos).AND.(jpi==1).AND.(jpj==1) ) THEN
         !PRINT *, ''
         !PRINT *, 'Monin-Obukhov length =', 1./One_on_L_MonObkv(t_zu, q_zu, u_star, t_star, q_star)
         !PRINT *, 'U_blk               = ', U_blk
         !PRINT *, ''
      END IF

      DEALLOCATE ( u_star, t_star, q_star, zeta_u, dt_zu, dq_zu, z0, z0t, znu_a, ztmp0, ztmp1, ztmp2 )
      IF( .NOT. l_zt_equal_zu )   DEALLOCATE ( zeta_t )

   END SUBROUTINE turb_coare_2z




   FUNCTION alfa_charn(dw)
      !!
      !! 2013: L. Brodeau
      !!
      !! Compute Charncok's constant depending on the wind speed
      !!
      !!  Wind below 10 m/s :  alfa = 0.011
      !!  Wind between 10 and 18 m/s : linear increase from 0.011 to 0.018
      !!  Wind greater than 18 m/s :  alfa = 0.018
      !!
      !!
      !!
      REAL(wp), DIMENSION(jpi,jpj) :: alfa_charn
      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: dw   ! relative wind speed air/ocean
      !!
      REAL(wp), DIMENSION(:,:), ALLOCATABLE :: gt10, gt18
      !!
      ALLOCATE( gt10(jpi,jpj), gt18(jpi,jpj) )
      !!
      !! Charnock's constant, increases with the wind :
      gt10 = 0.5 + sign(0.5,(dw - 10.)) ! If dw<10. --> 0, else --> 1
      gt18 = 0.5 + sign(0.5,(dw - 18.)) ! If dw<18. --> 0, else --> 1
      !!
      alfa_charn =  (1. - gt10)*0.011    &    ! wind is lower than 10 m/s
           & + gt10*((1. - gt18)*(0.011 + (0.018 - 0.011) &
           & *(dw - 10.)/(18. - 10.)) + gt18*( 0.018 ) ) ! Hare et al. (1999)
      !!
      DEALLOCATE( gt10, gt18 )
      !!
   END FUNCTION alfa_charn



   FUNCTION One_on_L_MonObkv(theta_a, q_a, us, ts, qs)

      !! ********************************************************************************
      !! Evaluates the 1./(Monin Obukhov length) from average temperature, specific humidity
      !! and frictional u, t and q
      !! 2015: L. Brodeau
      !! ********************************************************************************

      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: theta_a,  &  !: average potetntial air temperature [K]
           &                                q_a,      &  !: average specific humidity of air   [kg/kg]
           &                                us, ts, qs   !: frictional velocity, temperature and humidity

      REAL(wp), DIMENSION(jpi,jpj)             :: One_on_L_MonObkv         !: 1./(Monin Obukhov length) [m^-1]

      REAL(wp), DIMENSION(:,:), ALLOCATABLE  :: rqa

      ALLOCATE ( rqa(jpi,jpj) )

      rqa = (1. + rctv0*q_a)

      ! Tv  = theta_a*rqa               ! => average virtual temperature
      ! rb  = ts*rqa + rctv0*theta_a*qs   ! => -Tv*/u*

      ! L_MO = us*us * theta_a*rqa / ( grav*vkarmn * (ts*rqa + rctv0*theta_a*qs) )
      One_on_L_MonObkv =  grav*vkarmn*(ts*rqa + rctv0*theta_a*qs) / ( us*us * theta_a*rqa )

      !sgn = sign(1.,rb)            !! Added this to avoid program
      !!                             !! failure when TV_STAR is very small
      !ep = 0.5 + sign(0.5, (abs(rb) - 1.e-3))
      !rb = (1. - ep)*sgn*rb  +  ep*rb
      !!     abs(rb) < 1.e-3      abs(rb) > 1.e-3)
      !!

      DEALLOCATE ( rqa )

   END FUNCTION One_on_L_MonObkv




   FUNCTION psi_m_coare(zta)
      !!
      !! 2013: L. Brodeau adapted from "official" COARE code...
      !!
      !! Psi_m_coare and Psi_t evaluate stability function for wind speed
      !! and scalars matching Kansas and free convection forms with weighting
      !! f convective form follows Fairall et al (1996) with profile constants
      !! from Grachev et al (2000) BLM
      !! stable form from Beljaars and Holtslag (1991)
      !!
      !! zta : z/L where z is altitude measurement and L is M-O length
      !!
      !! sqrt(3) = 1.7320508
      !!
      REAL(wp), DIMENSION(jpi,jpj) :: psi_m_coare
      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: zta
      !!
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::  &  ! local
           &     phi_m, phi_c, psi_k, psi_c, f, c, stabit

      ALLOCATE ( phi_m(jpi,jpj), phi_c(jpi,jpj), psi_k(jpi,jpj), psi_c(jpi,jpj), &
           &     f(jpi,jpj), c(jpi,jpj), stabit(jpi,jpj) )

      phi_m  = ABS(1. - 15.*zta)**.25                        !!Kansas unstable
      !!
      psi_k  = 2.*LOG((1. + phi_m)/2.) + LOG((1. + phi_m*phi_m)/2.)   &
           & - 2.*ATAN(phi_m) + 1.5707963                                  ! Pi/2 = 1.5707963
      !!
      phi_c     = ABS(1. - 10.15*zta)**.3333                   !!Convective
      !!
      psi_c  =  1.5*LOG((1. + phi_c + phi_c*phi_c)/3.) &
           &  - 1.7320508*ATAN((1. + 2.*phi_c)/1.7320508) + 1.813799447
      !!
      f     = zta*zta/(1. + zta*zta)
      !!
      c     = MIN(50., 0.35*zta)
      !!
      stabit = 0.5 + SIGN(0.5, zta) ! zta > 0 => stabit = 1
      !!                                    ! zta < 0 => stabit = 0
      psi_m_coare = (1. - stabit)*( (1. - f)*psi_k + f*psi_c ) & ! (zta < 0)
           &             - stabit*( 1. + 1.*zta + 0.6667*(zta - 14.28)/exp(c) + 8.525 ) ! (zta > 0)
      !!
      DEALLOCATE ( phi_m, phi_c, psi_k, psi_c, f, c, stabit )
      !!
   END FUNCTION psi_m_coare




   FUNCTION psi_h_coare(zta)
      !!
      !! 2013: L. Brodeau adapted from "official" COARE code...
      !!
      !! zta : z/L where z is altitude measurement and L is M-O length
      !!
      REAL(wp), DIMENSION(jpi,jpj) :: psi_h_coare
      REAL(wp), DIMENSION(jpi,jpj),  INTENT(in) :: zta
      !!
      REAL(wp), DIMENSION(:,:), ALLOCATABLE :: phi_h, phi_c, psi_k, psi_c, f, c, stabit
      !!
      ALLOCATE ( phi_h(jpi,jpj), phi_c(jpi,jpj), psi_k(jpi,jpj), psi_c(jpi,jpj), &
           &     f(jpi,jpj), c(jpi,jpj), stabit(jpi,jpj) )
      !!
      phi_h = (ABS(1. - 15.*zta))**.5     !! Kansas unstable   (phi_h = phi_m**2 when unstable, phi_m when stable)
      !!
      psi_k  = 2.*LOG((1. + phi_h)/2.)
      !!
      phi_c     = (ABS(1. - 34.15*zta))**.3333       !!Convective
      !!
      psi_c  =  1.5*LOG((1. + phi_c + phi_c*phi_c)/3.) &
           &  - 1.7320508*ATAN((1. + 2.*phi_c)/1.7320508) + 1.813799447
      !!
      f     = zta*zta/(1. + zta*zta)
      !!
      c     = MIN(50.,0.35*zta)
      !!
      !!
      stabit = 0.5 + SIGN(0.5, zta)
      !!
      psi_h_coare = (1. - stabit)*( (1. - f)*psi_k + f*psi_c )   &
           &             - stabit*( (ABS(1. + 2.*zta/3.))**1.5 + .6667*(zta - 14.28)/exp(c) + 8.525 )
      !!
      DEALLOCATE ( phi_h, phi_c, psi_k, psi_c, f, c, stabit )
      !!
   END FUNCTION psi_h_coare


END MODULE mod_blk_coare
