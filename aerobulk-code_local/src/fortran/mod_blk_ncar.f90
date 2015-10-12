! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

MODULE mod_blk_ncar

   !!====================================================================================
   !!       Computes turbulent components of surface fluxes
   !!         according to Large & Yeager (2004,2008)
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

   PUBLIC :: TURB_NCAR_2Z


CONTAINS

   SUBROUTINE turb_ncar_2z(zt, zu, sst, t_zt, ssq, q_zt, U_zu, &
        &                   Cd, Ch, Ce, t_zu, q_zu, U_blk)


      !!----------------------------------------------------------------------
      !!                      ***  ROUTINE  turb_ncar  ***
      !!
	  !!            2015: L. Brodeau (brodeau@gmail.com)
	  !!
      !! ** Purpose :   Computes turbulent transfert coefficients of surface
      !!                fluxes according to Large & Yeager (2004) and Large & Yeager (2008)
      !!                If relevant (zt /= zu), adjust temperature and humidity from height zt to zu
      !!
      !! ** Method : Monin Obukhov Similarity Theory
      !!             + Large & Yeager (2004,2008) closure: CD_n10 = f(U_n10)
      !!
      !! ** References :   Large & Yeager, 2004 / Large & Yeager, 2008
      !!
      !! ** Last update: Laurent Brodeau, June 2014:
      !!    - handles both cases zt=zu and zt/=zu
      !!    - optimized: less 2D arrays allocated and less operations
      !!    - better first guess of stability by checking air-sea difference of virtual temperature
      !!       rather than temperature difference only...
      !!    - added function "cd_neutral_10m" that uses the improved parametrization of
      !!      Large & Yeager 2008. Drag-coefficient reduction for Cyclone conditions!
      !!    - using code-wide physical constants defined into "phycst.mod" rather than redifining them
      !!      => 'vkarmn' and 'grav'
      !!----------------------------------------------------------------------

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
      !
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   Cx_n10        ! 10m neutral latent/sensible coefficient
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   sqrt_Cd_n10   ! root square of Cd_n10
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   zeta_u        ! stability parameter at height zu
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   zpsi_h_u
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   ztmp0, ztmp1, ztmp2
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   stab          ! 1st stability test integer
      !!----------------------------------------------------------------------



      ALLOCATE( Cx_n10(jpi,jpj), sqrt_Cd_n10(jpi,jpj), &
           &    zeta_u(jpi,jpj), stab(jpi,jpj), zpsi_h_u(jpi,jpj),  &
           &    ztmp0(jpi,jpj),  ztmp1(jpi,jpj), ztmp2(jpi,jpj) )

      l_zt_equal_zu = .FALSE.
      IF( ABS(zu - zt) < 0.01 ) l_zt_equal_zu = .TRUE.    ! testing "zu == zt" is risky with double precision

      U_blk = MAX( 0.5 , U_zu )   !  relative wind speed at zu (normally 10m), we don't want to fall under 0.5 m/s

      !! First guess of stability:
      ztmp0 = t_zt*(1. + rctv0*q_zt) - sst*(1. + rctv0*ssq) ! air-sea difference of virtual pot. temp. at zt
      stab  = 0.5 + sign(0.5,ztmp0)                           ! stab = 1 if dTv > 0  => STABLE, 0 if unstable

      !! Neutral coefficients at 10m:
      ztmp0 = cd_neutral_10m( U_blk )

      sqrt_Cd_n10 = SQRT( ztmp0 )

      !! Initializing transf. coeff. with their first guess neutral equivalents :
      Cd = ztmp0
      Ce = 1.e-3*( 34.6 * sqrt_Cd_n10 )
      Ch = 1.e-3*sqrt_Cd_n10*(18.*stab + 32.7*(1. - stab))
      stab = sqrt_Cd_n10   ! Temporaty array !!! stab == SQRT(Cd)

      !! Initializing values at z_u with z_t values:
      t_zu = t_zt   ;   q_zu = q_zt

      !!  * Now starting iteration loop
      DO j_itt=1, nb_itt
         !
         ztmp1 = t_zu - sst   ! Updating air/sea differences
         ztmp2 = q_zu - ssq

         ! Updating turbulent scales :   (L&Y 2004 eq. (7))
         ztmp1  = Ch/stab*ztmp1    ! theta*   (stab == SQRT(Cd))
         ztmp2  = Ce/stab*ztmp2    ! q*       (stab == SQRT(Cd))

         ztmp0 = 1. + rctv0*q_zu      ! multiply this with t and you have the virtual temperature

         ! Estimate the inverse of Monin-Obukov length (1/L) at height zu:
         ztmp0 =  (grav*vkarmn/(t_zu*ztmp0)*(ztmp1*ztmp0 + rctv0*t_zu*ztmp2)) / (Cd*U_blk*U_blk)
         !                                                      ( Cd*U_blk*U_blk is U*^2 at zu )

         !! Stability parameters :
         zeta_u   = zu*ztmp0   ;  zeta_u = sign( min(abs(zeta_u),10.0), zeta_u )
         zpsi_h_u = psi_h( zeta_u )

         !! Shifting temperature and humidity at zu (L&Y 2004 eq. (9b-9c))
         IF ( .NOT. l_zt_equal_zu ) THEN
            !! Array 'stab' is free for the moment so using it to store 'zeta_t'
            stab = zt*ztmp0 ;  stab = SIGN( MIN(ABS(stab),10.0), stab )  ! Temporaty array stab == zeta_t !!!
            stab = LOG(zu/zt) - zpsi_h_u + psi_h(stab)                   ! stab just used as temp array again!
            t_zu = t_zt + ztmp1/vkarmn*stab    ! ztmp1 is still theta*
            q_zu = q_zt + ztmp2/vkarmn*stab    ! ztmp2 is still q*
            q_zu = max(0., q_zu)
         END IF

         ! Update neutral wind speed at 10m and neutral Cd at 10m (L&Y 2004 eq. 9a)...
         !   In very rare low-wind conditions, the old way of estimating the
         !   neutral wind speed at 10m leads to a negative value that causes the code
         !   to crash. To prevent this a threshold of 0.25m/s is imposed.
         ztmp2 = psi_m(zeta_u)
         ztmp0 = MAX( 0.25 , U_blk/(1. + sqrt_Cd_n10/vkarmn*(LOG(zu/10.) - ztmp2)) ) ! U_n10 (ztmp2 == psi_m(zeta_u))
         ztmp0 = cd_neutral_10m(ztmp0)                                               ! Cd_n10
         sqrt_Cd_n10 = sqrt(ztmp0)

         stab    = 0.5 + sign(0.5,zeta_u)                           ! update stability
         Cx_n10  = 1.e-3*sqrt_Cd_n10*(18.*stab + 32.7*(1. - stab))  ! L&Y 2004 eq. (6c-6d)    (Cx_n10 == Ch_n10)

         !! Update of transfer coefficients:
         ztmp1 = 1. + sqrt_Cd_n10/vkarmn*(LOG(zu/10.) - ztmp2)   ! L&Y 2004 eq. (10a) (ztmp2 == psi_m(zeta_u))
         Cd      = ztmp0 / ( ztmp1*ztmp1 )
         stab = SQRT( Cd ) ! Temporary array !!! (stab == SQRT(Cd))

         ztmp0 = (LOG(zu/10.) - zpsi_h_u) / vkarmn / sqrt_Cd_n10
         ztmp2 = stab / sqrt_Cd_n10   ! (stab == SQRT(Cd))
         ztmp1 = 1. + Cx_n10*ztmp0    ! (Cx_n10 == Ch_n10)
         Ch  = Cx_n10*ztmp2 / ztmp1   ! L&Y 2004 eq. (10b)

         Cx_n10  = 1.e-3 * (34.6 * sqrt_Cd_n10)  ! L&Y 2004 eq. (6b)    ! Cx_n10 == Ce_n10
         ztmp1 = 1. + Cx_n10*ztmp0
         Ce  = Cx_n10*ztmp2 / ztmp1  ! L&Y 2004 eq. (10c)

      END DO



      IF ( (ldebug_blk_algos).AND.(jpi==1).AND.(jpj==1) ) THEN
         PRINT *, ''
         ztmp1 = t_zu - sst   ! Updating air/sea differences
         ztmp2 = q_zu - ssq
         ztmp1  = Ch/stab*ztmp1    ! theta* (stab == SQRT(Cd))
         ztmp2  = Ce/stab*ztmp2    ! q*     (stab == SQRT(Cd))
         ztmp0 = 1. + rctv0*q_zu      ! multiply this with t and you have the virtual temperature
         ztmp0 =  (grav*vkarmn/(t_zu*ztmp0)*(ztmp1*ztmp0 + rctv0*t_zu*ztmp2)) / (Cd*U_blk*U_blk)
         PRINT *, 'Monin-Obukhov length =', 1./ztmp0
         PRINT *, 'U_blk               = ', U_blk
         PRINT *, ''
      END IF



      DEALLOCATE( Cx_n10, sqrt_Cd_n10, &
           &    zeta_u, stab, zpsi_h_u, ztmp0, &
           &    ztmp1, ztmp2 )

   END SUBROUTINE turb_ncar_2z


   FUNCTION cd_neutral_10m( zw10 )
      !!----------------------------------------------------------------------
      !! Estimate of the neutral drag coefficient at 10m as a function
      !! of neutral wind  speed at 10m
      !!
      !! Origin: Large & Yeager 2008 eq.(11a) and eq.(11b)
      !!
      !! Author: L. Brodeau, june 2014
      !!----------------------------------------------------------------------
      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) ::   zw10           ! scalar wind speed at 10m (m/s)
      REAL(wp), DIMENSION(jpi,jpj)             ::   cd_neutral_10m
      !
      REAL(wp), DIMENSION(:,:), ALLOCATABLE ::   rgt33
      !!----------------------------------------------------------------------
      !
      ALLOCATE( rgt33(jpi,jpj) )
      !
      !! When wind speed > 33 m/s => Cyclone conditions => special treatment
      rgt33 = 0.5_wp + SIGN( 0.5_wp, (zw10 - 33._wp) )   ! If zw10 < 33. => 0, else => 1
      cd_neutral_10m = 1.e-3 * ( &
           &       (1._wp - rgt33)*( 2.7_wp/zw10 + 0.142_wp + zw10/13.09_wp - 3.14807E-10*zw10**6) &  ! zw10< 33.
           &      +         rgt33 *      2.34_wp )                                                    ! zw10 >= 33.
      !
      cd_neutral_10m = MAX(cd_neutral_10m, 1.E-6) ! laurent 2015
      !
      DEALLOCATE(rgt33)
      !
   END FUNCTION cd_neutral_10m


   FUNCTION psi_m(pta)   !! Psis, L&Y 2004 eq. (8c), (8d), (8e)
      !-------------------------------------------------------------------------------
      ! universal profile stability function for momentum
      !-------------------------------------------------------------------------------
      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: pta
      !
      REAL(wp), DIMENSION(jpi,jpj)             :: psi_m
      REAL(wp), DIMENSION(:,:), ALLOCATABLE  :: X2, X, stabit
      !-------------------------------------------------------------------------------
      !
      ALLOCATE( X2(jpi,jpj), X(jpi,jpj), stabit(jpi,jpj) )
      !
      X2 = SQRT( ABS( 1. - 16.*pta ) )  ;  X2 = MAX( X2 , 1. )   ;   X = SQRT( X2 )
      stabit = 0.5 + SIGN( 0.5 , pta )
      psi_m = -5.*pta*stabit  &                                                          ! Stable
           &    + (1. - stabit)*(2.*LOG((1. + X)*0.5) + LOG((1. + X2)*0.5) - 2.*ATAN(X) + rpi*0.5)  ! Unstable
      !
      DEALLOCATE( X2, X, stabit )
      !
   END FUNCTION psi_m


   FUNCTION psi_h( pta )    !! Psis, L&Y 2004 eq. (8c), (8d), (8e)
      !-------------------------------------------------------------------------------
      ! universal profile stability function for temperature and humidity
      !-------------------------------------------------------------------------------
      REAL(wp), DIMENSION(jpi,jpj), INTENT(in) ::   pta
      !
      REAL(wp), DIMENSION(jpi,jpj)             ::   psi_h
      REAL(wp), DIMENSION(:,:), ALLOCATABLE  ::   X2, X, stabit
      !-------------------------------------------------------------------------------
      !
      ALLOCATE( X2(jpi,jpj), X(jpi,jpj), stabit(jpi,jpj) )
      !
      X2 = SQRT( ABS( 1. - 16.*pta ) )   ;   X2 = MAX( X2 , 1. )   ;   X = SQRT( X2 )
      stabit = 0.5 + SIGN( 0.5 , pta )
      psi_h = -5.*pta*stabit   &                                       ! Stable
           &    + (1. - stabit)*(2.*LOG( (1. + X2)*0.5 ))                ! Unstable
      !
      DEALLOCATE( X2, X, stabit )
      !
   END FUNCTION psi_h


END MODULE mod_blk_ncar
