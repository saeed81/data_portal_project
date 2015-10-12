! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

MODULE mod_thermo

  USE mod_const

  IMPLICIT none

  PRIVATE

  PUBLIC :: visc_air, Lvap, e_sat, e_air, Cp_moist_air, rh_air, rho_air, rho_air_adv, q_sat, q_air_rh, &
       &    q_air_dp, q_sat_simple, One_on_L_MO

  REAL(wp), PARAMETER  :: &
       &    repsilon = 1.e-6

CONTAINS


  FUNCTION visc_air(Ta)

    !! Air viscosity (m^2/s) given from temperature in degrees...

    REAL(wp), DIMENSION(jpi,jpj) :: visc_air
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: Ta  ! air temperature in (K)

    REAL(wp), DIMENSION(:,:), ALLOCATABLE :: TC, TC2

    ALLOCATE ( TC(jpi,jpj), TC2(jpi,jpj) )

    TC  = Ta - rt0   ! air temp, in deg. C
    TC2 = TC*TC
    
    visc_air = 1.326E-5*(1. + 6.542E-3*TC + 8.301E-6*TC2 - 4.84E-9*TC2*TC)
    
    DEALLOCATE ( TC, TC2 )

  END FUNCTION visc_air



  FUNCTION Lvap(zsst)
    
    !: latent heat of vaporization of water from temperature in (K)

    REAL(wp), DIMENSION(jpi,jpj)             :: Lvap
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: zsst   !: water temperature in (K)

    Lvap = (2.501 - 0.00237*(zsst - rt0))*1.E6   ; ! J/kg

  END FUNCTION Lvap


  
  FUNCTION e_sat(rT)

    !!**************************************************
    !! rT:     air temperature [K]
    !! e_sat:  water vapor at saturation [Pa]
    !! WMO, (Goff, 1957)
    !!**************************************************
    
    REAL(wp), DIMENSION(jpi,jpj)             :: e_sat !: vapour pressure at saturation  [Pa]
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: rT    !: temperature (K)
    
    REAL(wp), DIMENSION(:,:), ALLOCATABLE :: ztmp

    ALLOCATE ( ztmp(jpi,jpj) )

    ztmp(:,:) = rt0/rT(:,:)
    
    e_sat = 100.*( 10.**(10.79574*(1. - ztmp) - 5.028*LOG10(rT/rt0)         &
         &       + 1.50475*10.**(-4)*(1. - 10.**(-8.2969*(rT/rt0 - 1.)) )   &
         &       + 0.42873*10.**(-3)*(10.**(4.76955*(1. - ztmp)) - 1.) + 0.78614) )

    DEALLOCATE ( ztmp )
    
  END FUNCTION e_sat




  FUNCTION e_air(q_air, zslp)

    !!--------------------------------------------------------------------
    !!                  **** Function e_air ****
    !!
    !! Gives vapour pressure of air from pressure and specific humidity
    !!
    !!--------------------------------------------------------------------

    REAL(wp), DIMENSION(jpi,jpj)             ::    e_air      !: vapour pressure at saturation  [Pa]
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) ::          &
         &                 q_air,   &  ! specific humidity of air      [kg/kg]
         &                 zslp        ! atmospheric pressure          [Pa]

    REAL(wp), DIMENSION(:,:), ALLOCATABLE :: ee, e_old
    REAL :: diff

    ALLOCATE ( ee(jpi,jpj), e_old(jpi,jpj) )

    diff  = 1.
    e_old = q_air*zslp/reps0

    DO WHILE ( diff > repsilon )
       ee = q_air/reps0*(zslp - (1. - reps0)*e_old)
       diff  = SUM( abs( ee - e_old) )
       e_old = ee
    END DO

    e_air = ee

    DEALLOCATE ( ee, e_old )

  END FUNCTION e_air



  FUNCTION Cp_moist_air(q_air)

    !!------------------------------------------------------------------------------
    !!                  **** Function Cp_moist_air ****
    !!
    !! Gives the specific heat capacity of moist air knowing the specific humidity
    !!
    !!------------------------------------------------------------------------------
    
    REAL(wp), DIMENSION(jpi,jpj)             :: Cp_moist_air  !: vapour pressure at saturation  [J/K/kg]
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: q_air         !: specific humidity of air      [kg/kg]

    Cp_moist_air = Cp_dry + Cp_vap*q_air

  END FUNCTION Cp_moist_air



  FUNCTION rh_air(q_air, t_air, zslp)

    !! Relative humidity of air 
    
    REAL(wp), DIMENSION(jpi,jpj)             :: rh_air  !: relative humidity [] (fraction!!!, not percent!)
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: &
         &                 q_air,   &     !: specific humidity of air      [kg/kg]
         &                 t_air,   &     !: air temperature               [K]
         &                 zslp           !: atmospheric pressure          [Pa]
    
    rh_air = e_sat(t_air)
    rh_air = e_air(q_air,zslp) / rh_air

  END FUNCTION rh_air



  FUNCTION q_air_rh(rha, ta, zslp)

    !! Specific humidity of air from Relative humidity 
    
    REAL(wp), DIMENSION(jpi,jpj) :: q_air_rh

    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: &
         &     rha,     &   !: relative humidity      [fraction, not %!!!]
         &     ta,      &   !: air temperature        [K]
         &     zslp         !: atmospheric pressure          [Pa]

    REAL(wp), DIMENSION(:,:), ALLOCATABLE :: ztmp

    ALLOCATE ( ztmp(jpi,jpj) )
    
    ztmp       = rha*e_sat(ta)
    q_air_rh = ztmp*reps0/(zslp - (1. - reps0)*ztmp)
    
    DEALLOCATE ( ztmp )

  END FUNCTION q_air_rh




  FUNCTION q_air_dp(da, zslp)
    !!
    !! Air specific humidity from dew point temperature
    !!
    REAL(wp), DIMENSION(jpi,jpj) :: q_air_dp  !: kg/kg
    !!
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: &
         &     da,     &    !: dew-point temperature   [K]
         &     zslp         !: atmospheric pressure    [Pa]
    !!
    !q_air_dp = e_sat(da)*reps0/(zslp - (1. - reps0)*e_sat(da))
    q_air_dp = e_sat(da)*reps0/(zslp - (1. - reps0)*e_sat(da))
    !!
  END FUNCTION q_air_dp



  FUNCTION rho_air(zt, zq, zP)
    
    REAL(wp), DIMENSION(jpi,jpj) ::   rho_air      !: density of air [kg/m^3]
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) ::  &
         &      zt,       &     !: air temperature in (K)
         &      zq,       &     !: air spec. hum. (kg/kg)
         &      zP              !: pressure in       (Pa)
    
    rho_air = zP/(R_dry*zt*(1. + rctv0*zq))
    
  END FUNCTION rho_air



  FUNCTION rho_air_adv(zt, zq, zP)
    !!
    !! Advanced version, using TRUE virtual temperature
    !!
    REAL(wp), DIMENSION(jpi,jpj) :: rho_air_adv      !: density of air [kg/m^3]
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) ::  &
         &      zt,       &     !: air temperature in (K)
         &      zq,       &     !: air spec. hum. (kg/kg)
         &      zP              !: pressure in       (Pa)
    !!
    REAL(wp), DIMENSION(jpi,jpj) :: ztv !: virtual temperature
    !!
    ztv = zt/(1. - e_air(zq, zP)/zP*(1. - reps0))
    !!
    rho_air_adv = zP/(R_dry*ztv)
    !!
  END FUNCTION rho_air_adv








  FUNCTION q_sat(temp, zslp)

    !! Specific humidity at saturation

    REAL(wp), DIMENSION(jpi,jpj) :: q_sat
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) ::  &
         &                  temp,  &   !: sea surface temperature         [K]
         &                  zslp       !: sea level atmospheric pressure  [Pa]

    !! Local :
    REAL(wp), DIMENSION(jpi,jpj) ::  &
         &    e_s

    !! Vapour pressure at saturation :
    e_s = e_sat(temp)
    q_sat = reps0*e_s/(zslp - (1. - reps0)*e_s)

  END FUNCTION q_sat




  FUNCTION e_sat_ice(rt)

    REAL(wp), DIMENSION(jpi,jpj) :: e_sat_ice !: vapour pressure at saturation in presence of ice [Pa]
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: rt

    REAL(wp), DIMENSION(:,:), ALLOCATABLE :: ztmp
    
    ALLOCATE ( ztmp(jpi,jpj) )

    ztmp(:,:) = 273.16/rt(:,:)

    e_sat_ice = 100.*(10**( -9.09718*(ztmp - 1.) - 3.56654*LOG10(ztmp) &
         &                + 0.876793*(1. - rt/273.16) + LOG10(6.1071) ) )

    DEALLOCATE ( ztmp )

  END FUNCTION e_sat_ice



  FUNCTION q_sat_simple(temp, zrho)

    REAL(wp), DIMENSION(jpi,jpj)             :: q_sat_simple
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: &
         &       temp,   &  !: sea surface temperature  [K]
         &       zrho       !: air density         [kg/m^3]

    q_sat_simple = 640380./zrho * exp(-5107.4/temp)

  END FUNCTION q_sat_simple


  
  FUNCTION One_on_L_MO(theta_a, q_a, us, ts, qs)

    !! ********************************************************************************
    !! Evaluates the 1./(Monin Obukhov length) from average temperature, specific humidity
    !! and frictional u, t and q
    !! 2015: L. Brodeau
    !! ********************************************************************************

    REAL(wp), DIMENSION(jpi,jpj), INTENT(in) :: theta_a,  &  !: average potetntial air temperature [K]
         &                                q_a,      &  !: average specific humidity of air   [kg/kg]
         &                                us, ts, qs   !: frictional velocity, temperature and humidity

    REAL(wp), DIMENSION(jpi,jpj)             :: One_on_L_MO         !: 1./(Monin Obukhov length) [m^-1]

    REAL(wp), DIMENSION(:,:), ALLOCATABLE  :: rqa

    ALLOCATE ( rqa(jpi,jpj) )

    rqa = (1. + rctv0*q_a)

    One_on_L_MO =  grav*vkarmn*(ts*rqa + rctv0*theta_a*qs) / ( us*us * theta_a*rqa )

    DEALLOCATE ( rqa )

  END FUNCTION One_on_L_MO







END MODULE mod_thermo
