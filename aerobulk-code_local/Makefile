# AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
# https://sourceforge.net/p/aerobulk

include make.macro

All: lib/libaerobulk.a cgibin/test_coef.x cgibin/test_flux.x cgibin/test_thermo.x cgibin/cx_vs_wind_test.x

LIB = -L./lib -laerobulk

LIB_SRC = src/cgi/mod_const.f90 \
	  src/cgi/mod_thermo.f90 \
	  src/cgi/mod_blk_coare.f90 \
          src/cgi/mod_blk_ncar.f90 \
	  src/cgi/mod_blk_ecmwf.f90 \
          src/cgi/mod_aerobulk_compute.f90 \
	  src/cgi/aerobulk.f90

LIB_OBJ = $(LIB_SRC:.f90=.o)

.SUFFIXES: 
.SUFFIXES: .f90 .o

lib/libaerobulk.a: $(LIB_OBJ)
	@echo ""
	@mkdir -p lib
	ar -rv lib/libaerobulk.a  $(LIB_OBJ)
	ranlib lib/libaerobulk.a
	@echo ""

cgibin/test_coef.x: src/cgi/test_coef.f90 lib/libaerobulk.a
	@mkdir -p cgibin
	$(FC) $(FF) src/cgi/test_coef.f90 -o cgibin/test_coef.x $(LIB)

cgibin/test_flux.x: src/cgi/test_flux.f90 lib/libaerobulk.a
	@mkdir -p cgibin
	$(FC) $(FF) src/cgi/test_flux.f90 -o cgibin/test_flux.x $(LIB)

cgibin/test_thermo.x: src/cgi/test_thermo.f90 lib/libaerobulk.a
	@mkdir -p cgibin
	$(FC) $(FF) src/cgi/test_thermo.f90 -o cgibin/test_thermo.x $(LIB)

cgibin/cx_vs_wind_test.x: src/cgi/cx_vs_wind_test.f90 lib/libaerobulk.a
	@mkdir -p cgibin dat
	$(FC) $(FF) src/cgi/cx_vs_wind_test.f90 -o cgibin/cx_vs_wind_test.x $(LIB)


.f90.o: $(LIB_SRC)
	@mkdir -p mod
	$(FC) -c $(FF) $< -o $*.o

clean:
	rm -rf mod cgibin lib src/cgi/*.o *~ \#* dat

#/*.x  *.log *~ out  mod/* lib/* *.nc tmp.* \#* *.info  config.dat *.tmp


