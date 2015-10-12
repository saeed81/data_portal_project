! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

PROGRAM TEST_THERMO

  USE mod_const
  USE mod_thermo

  IMPLICIT NONE

  REAL :: dt

  INTEGER, PARAMETER :: ntemp = 101


  REAL, DIMENSION(1,ntemp) :: vsst, vmsl, vqsat1, vqsat2, vqsat3, vqsat4, vsst_k, vrho, vtmp


  REAL, PARAMETER :: &
       &   t_min =  -5. , &
       &   t_max =  35.

  INTEGER :: jt

  CHARACTER(len=128) :: cfout1, cfout2

  jpi = 1
  jpj = ntemp


  dt = (t_max - t_min)/(ntemp - 1)

  PRINT *, 'dt = ', dt

  vsst(1,:) = (/ ( t_min + (jt-1)*dt , jt=1,ntemp ) /)

  !PRINT *, vsst

  vsst_k = vsst + rt0


  vmsl(:,:) = Patm

  !! Advanced formula:
  vqsat1(:,:) = 0.98*q_sat(vsst_k, vmsl)


  !! Simple with constant density
  vrho  (:,:) = 1.2
  vqsat2(:,:) = 0.98*q_sat_simple(vsst_k, vrho)


  !! Simple with better density
  vrho  (:,:) = rho_air(vsst_k, vqsat1, vmsl) ! we use the good q_sat to get a good rho
  vqsat3(:,:) = 0.98*q_sat_simple(vsst_k, vrho)

  !! Same but using density of air at 2m => T=SST-2 and not saturated => 80% hum!
  vtmp(:,:) = 0.8                          ! Relative humidity at 2m
  vrho(:,:) = vsst_k - 1.5                  ! Air temperature at 2m
  vtmp(:,:) = q_air_rh(vtmp, vrho, vmsl)   ! Specific humidity at 2m
  vrho(:,:) = rho_air(vrho, vtmp, vmsl)    ! air density at 2m
  vqsat4(:,:) = 0.98*q_sat_simple(vsst_k, vrho)




  cfout1 = 'qsat_test.dat'

  OPEN(11, FILE=cfout1, FORM='formatted', STATUS='unknown',RECL=512)
  WRITE(11,*) '#  SST   Method 1 (advanced)  Method 2 (simple)  Method 3 (simple) Method 4       Rho_air'
  DO jt = 1, ntemp
     WRITE(11,*) REAL(vsst(1,jt),4), REAL(vqsat1(1,jt),4), REAL(vqsat2(1,jt),4), REAL(vqsat3(1,jt),4), &
          &      REAL(vqsat4(1,jt),4), REAL(vrho(1,jt),4)
  END DO
  CLOSE(11)

  !CALL PT_SERIES(vsst(1,:), REAL(vqsat1(1,:),4), 'qsat1_good.nc', 'sst', 'q_sat', 'kg/kg', 'Specific hum. at sat.', &
  !     &         REAL(0.,4) ,   cun_t='degC')


  !! Plot errors in %
  cfout2 = 'error_qsat_test.dat'

  OPEN(11, FILE=cfout2, FORM='formatted', STATUS='unknown',RECL=512)
  WRITE(11,*) '#  Temperature  Method 2 / Method 1 (%)   Method 3 / Method 1 (%)    Method 4 / Method 1 (%) '
  DO jt = 1, ntemp
     WRITE(11,*) REAL(vsst(1,jt),4), REAL(100.*(vqsat2(1,jt)-vqsat1(1,jt))/vqsat1(1,jt),4), &
          &      REAL(100.*(vqsat3(1,jt)-vqsat1(1,jt))/vqsat1(1,jt),4), &
          &      REAL(100.*(vqsat4(1,jt)-vqsat1(1,jt))/vqsat1(1,jt) , 4)
  END DO
  CLOSE(11)


  PRINT *, ''
  PRINT *, trim(cfout1), ' and ', trim(cfout2), ' written!'
  PRINT *, ''



END PROGRAM TEST_THERMO
