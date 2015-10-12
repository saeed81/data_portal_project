! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

PROGRAM TEST_COEF

  USE mod_const
  USE mod_thermo

  USE mod_blk_coare
  USE mod_blk_ncar
  USE mod_blk_ecmwf

  USE mod_aerobulk_compute

  IMPLICIT NONE

  INTEGER, PARAMETER :: nb_algos = 3

  CHARACTER(len=10), DIMENSION(nb_algos), PARAMETER :: vca = (/ 'coare', 'ncar ', 'ecmwf' /)

  REAL(4), DIMENSION(nb_algos) :: vCd, vCe, vCh, vTu, vQu

  REAL(wp), PARAMETER ::   &
       &   zu  = 10.

  INTEGER, PARAMETER ::   &
       &   n_dt   = 21,   &
       &   n_u    = 30,   &
       &   n_q    = 10

  CHARACTER(len=2) :: car

  CHARACTER(len=100) :: &
       &   calgob


  INTEGER :: jarg, ialgo

  INTEGER, PARAMETER :: lx=1, ly=1
  REAL(wp),    DIMENSION(lx,ly) :: Ublk

  REAL(wp), DIMENSION(lx,ly) :: sst, qsat_air, SLP, &
       &  W10, t_air, q_air, RH, t_zu, q_zu, qsat_sst,  &
       &  rho, Tpot2, tmp


  REAL(wp), DIMENSION(lx,ly) :: Cd, Ce, Ch, Cp_ma

  REAL :: zt

  LOGICAL :: l_ask_for_slp = .FALSE. , &  !: ask for SLP, otherwize assume SLP = 1010 hPa
       &     l_use_rh      = .FALSE.      !: ask for RH rather than q for humidity

  jpi = lx ; jpj = ly


  nb_itt = 20  ! 20 itterations in bulk algorithm...


  jarg = 0

  DO WHILE ( jarg < iargc() )

     jarg = jarg + 1
     CALL getarg(jarg,car)

     SELECT CASE (trim(car))

     CASE('-h')
        call usage_test()

     CASE('-p')
        !PRINT *, 'Will ask for SLP'
        l_ask_for_slp = .TRUE.

     CASE('-r')
        !PRINT *, "Using RH instead of q!!!"
        l_use_rh = .TRUE.

     CASE DEFAULT
        PRINT *, 'Unknown option: ', trim(car) ; PRINT *, ''
        CALL usage_test()

     END SELECT

  END DO



  PRINT *, ''
  PRINT *, '  *** Epsilon = Rd/Rv (~0.622) =>', reps0
  PRINT *, '  *** (1-eps)/eps     (~0.608) =>', rctv0
  PRINT *, ''


  !!
  !PRINT *, ''
  !PRINT *, 'Which algo?'
  !PRINT *, '  COARE => 1'
  !PRINT *, '   NCAR => 2'
  !PRINT *, '  ECMWF => 3'
  !READ(*,*) ialgo

  !SELECT CASE(ialgo)
  !CASE(1)
  !   calgob = 'coare'
  !CASE(2)
  !   calgob = 'ncar'
  !CASE(3)
  !   calgob = 'ecmwf'
  !CASE DEFAULT
  !   write(6,*) 'Bulk algorithm #', ialgo, ' is unknown!!!' ; STOP
  !END SELECT


  PRINT *, ''


  PRINT *, 'Give "zt", the altitude for air temp. and humidity in m (generally 2 or 10):'
  READ(*,*) zt
  PRINT *, ''

  IF ( l_ask_for_slp ) THEN
     PRINT *, 'Give sea-level pressure (hPa):'
     READ(*,*) SLP
     SLP = SLP*100.
  ELSE
     SLP = Patm
     PRINT *, 'Using a sea-level pressure of ', Patm
  END IF
  PRINT *, ''

  PRINT *, 'Give SST (deg. C):'
  READ(*,*) sst
  sst = sst + rt0
  PRINT *, ''

  PRINT *, 'Give temperature at zt (deg. C):'
  READ(*,*) t_air
  t_air = t_air + rt0
  PRINT *, ''


  !! Asking for humidity:
  qsat_air = q_sat(t_air, SLP)  ! spec. hum. at saturation [kg/kg]

  IF ( l_use_rh ) THEN
     PRINT *, 'Give relative humidity at zt (%):'
     READ(*,*) RH
     RH = 1.E-2*RH
  ELSE
     WRITE(*, '("Give specific humidity at zt (g/kg) (saturation is at ",f6.3," g/kg):")') &
          &            1000.*qsat_air
     READ(*,*) q_air
     q_air = 1.E-3*q_air
  END IF

  IF ( q_air(1,1) > qsat_air(1,1) ) THEN
     PRINT *, ' ERROR: you can not go belong saturation!!!' ; STOP
  END IF

  PRINT *, ''
  PRINT *, ' *** density of air (height t and q) => ',  rho_air(t_air, q_air, SLP)
  PRINT *, ' ***  // same //    (super accurate) => ',  rho_air_adv(t_air, q_air, SLP)
  PRINT *, ''

  qsat_sst = 0.98*q_sat(sst, SLP)

  PRINT *, '' ;  PRINT *, 'q_sat(sst) =', qsat_sst ; PRINT *, ''



  IF ( l_use_rh ) THEN
     q_air = q_air_rh(RH, t_air, SLP)
     PRINT *, 'q_air from RH =', 1000*q_air
     !PRINT *, 'Inverse => RH from q_air:', 100*rh_air(q_air, t_air, SLP)
  ELSE
     RH   = rh_air(q_air, t_air, SLP)
     WRITE(*,'("  => Relative humidity at ",i2,"m = ",f4.1,"%")') INT(zt), 100*RH
     !PRINT *, 'Inverse => q_air from RH :', 1000*q_air_rh(RH, t_air, SLP)
  END IF

  !! Checking the difference of virtual potential temperature between air at zt and sea surface:
  tmp = t_air*(1. + rctv0*q_air) - sst*(1. + rctv0*0.98*q_sat(sst, SLP))
  WRITE(*,'("  => Difference of virt. pot. temp. between ",i2,"m and sea surface = ",f6.2," K")') INT(zt), tmp(1,1)
  PRINT *, ''


  Tpot2 = t_air*(1. + rctv0*q_air)

  PRINT *, 'Air virtual temperature at zt = ', Tpot2-rt0
  PRINT *, 'Temperature diff. air/sea     =', t_air - sst
  PRINT *, 'Virt. temp. diff. air/sea     =', Tpot2 - sst*(1. + rctv0*qsat_sst)
  PRINT *, ''; PRINT *, ''


  PRINT *, 'Give wind speed at zu=10m (m/s):'
  READ(*,*) W10
  PRINT *, ''


  DO ialgo = 1, nb_algos

     calgob = trim(vca(ialgo))

     SELECT CASE(ialgo)
     CASE(1)
        CALL TURB_COARE_2Z(zt, zu, sst, t_air, qsat_sst, q_air, W10, Cd, Ch, Ce, t_zu, q_zu, Ublk)
     CASE(2)
        CALL TURB_NCAR_2Z( zt, zu, sst, t_air, qsat_sst, q_air, W10, Cd, Ch, Ce, t_zu, q_zu, Ublk)
     CASE(3)
        CALL TURB_ECMWF_2Z(zt, zu, sst, t_air, qsat_sst, q_air, W10, Cd, Ch, Ce, t_zu, q_zu, Ublk)
     CASE DEFAULT
        write(6,*) 'Bulk algorithm #', ialgo, ' is unknown!!!' ; STOP
     END SELECT

     vCd(ialgo) = REAL(1000.*Cd(1,1) ,4)
     vCh(ialgo) = REAL(1000.*Ch(1,1) ,4)
     vCe(ialgo) = REAL(1000.*Ce(1,1) ,4)
     vTu(ialgo) = REAL(   t_zu(1,1) ,4)
     vQu(ialgo) = REAL(   q_zu(1,1) ,4)

  END DO


  PRINT *, ''; PRINT *, ''


  IF ( zt < zu ) THEN
     PRINT *, ''; PRINT *, 'Temperaure and humidity at z = zt :'
     PRINT *, 't_zt  =', t_air ;  PRINT *, 'q_zt  =', q_air ; PRINT *, ''
  END IF

  PRINT *, ''; PRINT *, 'Temperaure and humidity at z = zu :'
  PRINT *, '========================================================================='
  PRINT *, '  Algorithm:           ',trim(vca(1)),'    |    ',trim(vca(2)),'       |    ',trim(vca(3))
  PRINT *, '========================================================================='
  PRINT *, '    t_zu     =   ', vTu        , '[K]'
  PRINT *, '    q_zu     =   ', REAL(1000.*vQu ,4)  , '[g/kg]'
  PRINT *, ''




  !! Air density at zu (10m)
  rho = rho_air(t_zu, q_zu, SLP)
  tmp = SLP - rho*grav*zu
  rho = rho_air(t_zu, q_zu, tmp)


  PRINT *, ''
  PRINT *, 'With a pressure of', SLP
  PRINT *, 'Density of air at zu =', rho
  IF ( zt < zu )  PRINT *, 'Density of air at zt  =', rho_air(t_air, q_air, SLP)
  PRINT *, ''
  Cp_ma = Cp_moist_air(q_zu)
  PRINT *, ' Cp of moist air => ', Cp_ma, '[J/K/kg]'
  PRINT *, ''


  PRINT *, ''
  PRINT *, '   *** Bulk Transfer Coefficients:'
  PRINT *, '========================================================================='
  PRINT *, '  Algorithm:           ',trim(vca(1)),'    |    ',trim(vca(2)),'       |    ',trim(vca(3))
  PRINT *, '========================================================================='
  PRINT *, '      C_D     =   ', vCd        , '[10^-3]'
  PRINT *, '      C_E     =   ', vCe        , '[10^-3]'
  PRINT *, '      C_H     =   ', vCh        , '[10^-3]'
  PRINT *, ''


  PRINT *, ''

END PROGRAM TEST_COEF











SUBROUTINE usage_test()
  !!
  PRINT *,''
  PRINT *,'   List of command line options:'
  PRINT *,''
  PRINT *,' -p   => ask for sea-level pressure, otherwize assume 1010 hPa'
  PRINT *,''
  PRINT *,' -r   => Ask for relative humidity rather than specific humidity'
  PRINT *,''
  PRINT *,' -h   => Show this message'
  PRINT *,''
  STOP
  !!
END SUBROUTINE usage_test
!!
