! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

PROGRAM TEST_FLUX

  USE mod_const
  USE mod_thermo
  USE aerobulk

  IMPLICIT NONE

  INTEGER, PARAMETER :: nb_algos = 3

  CHARACTER(len=10), DIMENSION(nb_algos), PARAMETER :: vca = (/ 'coare', 'ncar ', 'ecmwf' /)

  REAL(4), DIMENSION(nb_algos) :: vTau, vQlat, vQsens

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

  REAL(wp), DIMENSION(lx,ly) :: sst, qsat_air, SLP, &
       &  W10, t_air, q_air, RH, Tau, Qlat, Qsens, tmp

  REAL :: zt

  LOGICAL :: l_ask_for_slp = .FALSE. , &  !: ask for SLP, otherwize assume SLP = 1010 hPa
       &     l_use_rh      = .FALSE.      !: ask for RH rather than q for humidity

  jpi = lx ; jpj = ly



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


  PRINT *, 'Give wind speed at zu=10m (m/s):'
  READ(*,*) W10
  PRINT *, ''


  DO ialgo = 1, nb_algos

     calgob = trim(vca(ialgo))

     CALL AEROBULK_MODEL(calgob, zt, zu, sst, t_air, q_air, W10, 0.*W10, SLP, &
          &              Qlat, Qsens, Tau, tmp, Nitter=20)

     vTau  (ialgo) = REAL(1000.*Tau(1,1),4)
     vQlat (ialgo) = REAL(Qlat(1,1),4)
     vQsens(ialgo) = REAL(Qsens(1,1),4)

  END DO
  !!        Wind stress      =   166.4716       150.7672       185.4389     (mN/m^2)
  PRINT *, '========================================================================='
  PRINT *, '  Algorithm:           ',trim(vca(1)),'    |    ',trim(vca(2)),'       |    ',trim(vca(3))
  PRINT *, '========================================================================='
  PRINT *, 'Wind stress      =', vTau(:),   '(mN/m^2)'
  PRINT *, 'Latent heat flux =', vQlat(:),  '(W/m^2)'
  PRINT *, 'Sens.  heat flux =', vQsens(:), '(W/m^2)'
  PRINT *, ''
  PRINT *, 'Turb.  heat flux =', vQsens(:)+vQlat(:), '(W/m^2)'



END PROGRAM TEST_FLUX



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
