// AeroBulk / 2015 / L. Brodeau (brodeau@gmail.com), S. Falahat (sd.falahat@gmail.com)
// https://sourceforge.net/p/aerobulk

#ifndef CPLUSPLUS_MODCONST_H_ 

#define CPLUSPLUS_MODCONST_H_ 

#include<iostream>

namespace mdl

{
    
    std::int64_t jpi, jpj;   //: 2D dimensions of array to be used in AeroBulk

    bool l_first_call = true;

    bool l_last_call  = false;

    const bool ldebug_blk_algos = false;

    std::int64_t nb_itt{4};     //: number of itteration in the bulk algorithm

    const long double rpi  = 3.141592653589793;
    const long double rt0  = 273.16;
    
    const long double grav  = 9.8;       //: gravity
    const long double  Patm  = static_cast<long double>(101000);
    
    //const long double Cp       = 1000.5 ; //NO      &  //: Specic heat of moist air, constant pressure    [J/K/kg]
    const long double   Cp_dry   = 1005.0 ;  //: Specic heat of dry air, constant pressure      [J/K/kg]
    const long double   Cp_vap   = 1860.0 ;  //: Specic heat of water vapor, constant pressure  [J/K/kg]
    //
    const long double  R_dry   = 287.05;  //: Specific gas constant for dry air              [J/K/kg]
    const long double  R_vap   = 461.495;  //: Specific gas constant for water vapor          [J/K/kg]
    //
    const long double  eps   = R_dry/R_vap;     //: ratio of specific constant for dry air
    //                                //: (R_dry) and specific constant for water vapor
    //                                //: (Rvap) = > Rd/Rv => 0.622
    //       
    const long double   ctv   = (1. - eps)/eps;   //: for virtual temperature (== (1-eps)/eps) => 0.608
    //
    //
    const long double   L0vap = 2.46E6;   //: Latent heat of vaporization for sea-water in J/kg
    const long double   vkarmn = 0.4;   //: Von Karman's constant
    const long double   Pi    = 3.141592654;
    const long double   twoPi = 2.*Pi;
    
    const long double   eps_w = 0.987;   //: emissivity of water
    const long double   sigma = 5.67E-8;   //: Stefan Boltzman constant
    //
    const long double   sea_albedo  = 0.066;   //: Default sea surface albedo over ocean when nothing better is available
    //
    const long double   Tswf  = 273.;          //: BAD////// because sea-ice not used yet//////
    //  Tswf  = 271.4          //: freezing point of sea-water (K)
    const long double   to_rad = Pi/180.;
    
    const long double   R_earth = 6.37E6; // Earth radius (m)
    const long double   rtilt_earth = 23.5;
    
    const long double   Sol0 = 1366.;        // Solar constant W/m^2

    
    const std::int64_t tdmn[12]{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    const std::int64_t tdml[12]{31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    //// Max and min values for variable (for netcdf files)
  
    //REAL, PARAMETER :: &
    //&                qlat_min = -1200., qlat_max = 200., &
    //     &                qsen_min = -900. , qsen_max = 300., &
    //     &                taum_min =    0., taum_max =   4.,  &
    //     ////
    //     &                msl_min  = 85000., msl_max = 105000., &
    //     &                tair_min =  223., tair_max = 323.,  &
    //     &                qair_min =    0., qair_max = 0.03,  &
    //     &                w10_min  =    0., w10_max  = 45.,   &
    //     &                sst_min  =  270., sst_max  = 310.,  &
    //     &                ice_min  =    0., ice_max  =   1.,  &
    //     &                cx_min   =    0., cx_max   = 0.01,  &
    //     &                rho_min  =   0.8, rho_max  =  1.5       // density of air
    // 
  
}


#endif 
