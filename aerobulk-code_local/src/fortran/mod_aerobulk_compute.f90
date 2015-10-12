! AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
! https://sourceforge.net/p/aerobulk

MODULE mod_aerobulk_compute

  USE mod_thermo      !: thermodynamics functions
  USE mod_const       !: physical constants

  USE mod_blk_coare   !: COAREv3 algorithm
  USE mod_blk_ncar    !: Large & Yeager algorithm
  USE mod_blk_ecmwf   !: following ECMWF doc...

  IMPLICIT NONE

  PRIVATE

  PUBLIC :: aerobulk_compute

  !REAL(wp),    PARAMETER :: &
  !!


CONTAINS

  SUBROUTINE aerobulk_compute(calgo, zt, zu, sst, t_zt, &
       &                      q_zt, U_zu, V_zu, slp,    &
       &                      QL, QH, Tau_x, Tau_y)

    !!******************************
    !! 2015: L. Brodeau (brodeau@gmail.com)
    !!  => all constants taken from mod_thermo and mod_const must
    !!     be done or used from NEMO constant bank...    ... vkarmn ... grav ...
    !!******************************

    !!======================================================================================
    !!
    !! INPUT :
    !! -------
    !!    *  calgo: what bulk algorithm to use => 'coare'/'ncar'/'ecmwf'
    !!    *  zt   : height for temperature and spec. hum. of air           [m]
    !!    *  zu   : height for wind (10m = traditional anemometric height  [m]
    !!    *  sst  : SST                                                    [K]
    !!    *  t_zt : potential air temperature at zt                        [K]
    !!    *  q_zt : specific humidity of air at zt                         [kg/kg]
    !!    *  U_zu : zonal wind speed at zu                                 [m/s]
    !!    *  V_zu : meridional wind speed at zu                            [m/s]
    !!    *  slp  : mean sea-level pressure                                [Pa] ~101000 Pa
    !!
    !! OUTPUT :
    !! --------
    !!    *  QL     : Latent heat flux                                     [W/m^2]
    !!    *  QH     : Sensible heat flux                                   [W/m^2]
    !!    *  Tau_x  : zonal wind stress                                    [N/m^2]
    !!    *  Tau_y  : zonal wind stress                                    [N/m^2]
    !!
    !! OPTIONAL :
    !! ----------
    !!    *
    !!
    !!
    !!============================================================================



    !! I/O ARGUMENTS:
    CHARACTER(len=*),       INTENT(in)  :: calgo
    REAL(wp),                   INTENT(in)  :: zt, zu
    REAL(wp), DIMENSION(jpi,jpj), INTENT(in)  :: sst, t_zt, q_zt, U_zu, V_zu, slp
    REAL(wp), DIMENSION(jpi,jpj), INTENT(out) :: QL, QH, Tau_x, Tau_y

    REAL(wp), DIMENSION(:,:), ALLOCATABLE  ::  &
         &     XWzu,            & !: Scalar wind speed at zu m
         &   XSSQ,              & !: Specific humidiyt at the air-sea interface
         &   Cd, Ch, Ce,        & !: bulk transfer coefficients
         &  XTzu, XQzu,         & !:
         &     XUblk,           & !: Bulk scalar wind speed (XWzu corrected for low wind and unstable conditions)
         &     XRHO               !: density of air

    ALLOCATE ( XWzu(jpi,jpj), XSSQ(jpi,jpj), &
         &     Cd(jpi,jpj), Ch(jpi,jpj), Ce(jpi,jpj),       &
         &     XTzu(jpi,jpj), XQzu(jpi,jpj),              &
         &     XUblk(jpi,jpj), XRHO(jpi,jpj)  )


    !! Scalar wind:
    XWzu = sqrt( U_zu*U_zu + V_zu*V_zu )

    !! Computing specific humidity at saturation at sea surface temperature :
    XSSQ (:,:) = 0.98*q_sat(sst, slp)





    !! Calling Monin-Obukhov turbulent algorithm
    !! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    SELECT CASE(trim(calgo))
       !!
    CASE('coare')
       CALL TURB_COARE_2Z (zt, zu, sst, t_zt, XSSQ, q_zt, XWzu,  &
            &              Cd, Ch, Ce, XTzu, XQzu, XUblk)

    CASE('ncar')
       CALL TURB_NCAR_2Z(zt, zu, sst, t_zt, XSSQ, q_zt, XWzu, &
            &            Cd, Ch, Ce, XTzu, XQzu, XUblk)
       !!
    CASE('ecmwf')
       CALL TURB_ECMWF_2Z (zt, zu, sst, t_zt, XSSQ, q_zt, XWzu,  &
            &              Cd, Ch, Ce, XTzu, XQzu, XUblk)
       !!
    CASE DEFAULT
       write(6,*) 'ERROR: mod_aerobulk_compute.f90 => bulk algorithm ', trim(calgo), ' is unknown!!!'
       STOP
    END SELECT


    !! Need the air density at zu m, so using t and q corrected at zu m:
    XRHO = rho_air(XTzu, XQzu, slp)
    QH   = slp - XRHO*grav*zu      ! QH used as temporary array!
    XRHO = rho_air(XTzu, XQzu, QH)


    !! *** Wind stress ***
    Tau_x = Cd*XRHO * U_zu * XUblk
    Tau_y = Cd*XRHO * V_zu * XUblk


    !! *** Latent and Sensible heat fluxes ***
    QL = Ce*XRHO*Lvap(sst)         *(XQzu - XSSQ) * XUblk
    QH = Ch*XRHO*Cp_moist_air(XQzu)*(XTzu -  sst) * XUblk
    

    !PRINT *, 'LOLO DEBUG INTO mod_aerobulk_compute !!! ', trim(calgo)
    !PRINT *, 'Ce =', Ce
    !PRINT *, 'Qlat =', QL
    !PRINT *, 'Ublk =', XUblk
    !PRINT *, 'Ce/Ublk =', Ce/XUblk
    !PRINT *, 't_zu =', XTzu
    !PRINT *, 'q_zu =', XQzu
    !PRINT *, 'Rho =', XRHO
    !PRINT *, 'ssq =', XSSQ
    !PRINT *, 'Lvap =', Lvap(sst)
    !PRINT *, ''

    
    DEALLOCATE ( XWzu, XSSQ, Cd, Ch, Ce, XTzu, XQzu, XUblk, XRHO )

  END SUBROUTINE aerobulk_compute

END MODULE mod_aerobulk_compute
