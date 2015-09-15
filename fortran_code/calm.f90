PROGRAM calm

  IMPLICIT NONE

  REAL(8) :: zla

  CHARACTER(LEN=32) :: cla

  INTEGER           :: ila


  CALL getarg(1,cla)

  READ(cla,'(I20)') ila

  PRINT *, REAL(ila,4)

END PROGRAM calm
