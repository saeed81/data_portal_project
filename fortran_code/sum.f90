PROGRAM sum_var
!!print sum
  IMPLICIT NONE

  REAL(8), DIMENSION(2) :: zla

  CHARACTER(LEN=32) :: cla

  REAL(8)          :: zila

  CALL getarg(1,cla)

  READ(cla,*) zila

  zla(1)  = REAL(zila,8)

  CALL getarg(2,cla)

  READ(cla,*) zila

  zla(2)  = REAL(zila,8)

  PRINT *, REAL(SUM(REAL(zla(:),8)),8)

END PROGRAM sum_var
