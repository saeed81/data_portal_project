! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

MODULE mod_const

  IMPLICIT NONE

  PUBLIC

  !! Following NEMO:
  INTEGER, PARAMETER :: sp = SELECTED_REAL_KIND( 6, 37)   !: single precision (real 4)
  INTEGER, PARAMETER :: dp = SELECTED_REAL_KIND(12,307)   !: double precision (real 8)
  INTEGER, PARAMETER :: wp = dp                           !: working precision
  
  INTEGER, SAVE :: jpi, jpj   !: 2D dimensions of array to be used in AeroBulk

  LOGICAL, SAVE :: l_first_call=.true. , l_last_call=.false.

  LOGICAL, PARAMETER :: ldebug_blk_algos=.false.
  
  INTEGER, SAVE      :: nb_itt=4  !: number of itteration in the bulk algorithm


  REAL(wp), PARAMETER, PUBLIC :: &
       &   rpi  = 3.141592653589793, &
       &   rt0  = 273.16,    &
       &  grav  = 9.8,       &   !: gravity
       &  Patm  = 101000.,   &
       !!
       !!& Cp       = 1000.5 , !NO      &  !: Specic heat of moist air, constant pressure    [J/K/kg]
       & Cp_dry = 1005.0 ,       &  !: Specic heat of dry air, constant pressure      [J/K/kg]
       & Cp_vap = 1860.0 ,       &  !: Specic heat of water vapor, constant pressure  [J/K/kg]
       !!
       &  R_dry = 287.05,        &  !: Specific gas constant for dry air              [J/K/kg]
       &  R_vap = 461.495,       &  !: Specific gas constant for water vapor          [J/K/kg]
       !!
       &  reps0 = R_dry/R_vap,  &     !: ratio of specific constant for dry air
       !!                             !: (R_dry) and specific constant for water vapor
       !!                             !: (Rvap) = > Rd/Rv => 0.622
       !!
       &  rctv0 = (1. - reps0)/reps0,     &   !: for virtual temperature (== (1-eps)/eps) => 0.608
       !!
       &  nu0_air  = 1.5E-5,   &   !: kinematic viscosity of air
       !!
       &  L0vap = 2.46E6,    &   !: Latent heat of vaporization for sea-water in J/kg
       &  vkarmn = 0.4,       &   !: Von Karman's constant
       &  Pi    = 3.141592654, &
       &  twoPi = 2.*Pi,     &
       &  eps_w = 0.987,     &   !: emissivity of water
       &  sigma = 5.67E-8,   &   !: Stefan Boltzman constant
       !!
       &  sea_albedo  = 0.066,     &   !: Default sea surface albedo over ocean when nothing better is available
       !!
       &  Tswf  = 273.,  &           !: BAD!!! because sea-ice not used yet!!!
       !&  Tswf  = 271.4          !: freezing point of sea-water (K)
       &  to_rad = Pi/180., &
       &  R_earth = 6.37E6,        & ! Earth radius (m)
       &  rtilt_earth = 23.5, &
       &  Sol0 = 1366.        ! Solar constant W/m^2
  

  INTEGER, DIMENSION(12), PARAMETER, PUBLIC :: &
       &   tdmn = (/ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 /), &
       &   tdml = (/ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 /)
  

  !! Max and min values for variable (for netcdf files)

  !REAL(wp), PARAMETER :: &
  !&                qlat_min = -1200., qlat_max = 200., &
  !     &                qsen_min = -900. , qsen_max = 300., &
  !     &                taum_min =    0., taum_max =   4.,  &
  !     !!
  !     &                msl_min  = 85000., msl_max = 105000., &
  !     &                tair_min =  223., tair_max = 323.,  &
  !     &                qair_min =    0., qair_max = 0.03,  &
  !     &                w10_min  =    0., w10_max  = 45.,   &
  !     &                sst_min  =  270., sst_max  = 310.,  &
  !     &                ice_min  =    0., ice_max  =   1.,  &
  !     &                cx_min   =    0., cx_max   = 0.01,  &
  !     &                rho_min  =   0.8, rho_max  =  1.5       ! density of air
  !



END MODULE mod_const
