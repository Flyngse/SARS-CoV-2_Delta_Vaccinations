********************************
	BUILD_HouseHoldTransmission - START
********************************;

********************************
	BUILD - START
********************************;

%let in = In04942 ;
libname Data "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Data\" ;

options compress = yes;
options obs = max ;
dm 'cle log' ;
options compress=yes ;


********;

%let today = %sysfunc(today(), yymmdd6.); %put &today. ;
%let YesterDay = %sysfunc( intnx(day, %sysfunc(today()), -1), yymmdd6.) ; %put &YesterDay. ;
%let DayBeforeYesterDay = %sysfunc( intnx(day, %sysfunc(today()), -2), yymmdd6.) ; %put &DayBeforeYesterDay. ;
%let Update = &YesterDay. ; %put &Update. ;

**************;
** BUILD ;
**************;

* Formater ;
%include "F:\Projekter\FSEID00004942\Formater_2019.sas" ;

* WGS ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Build\WGS, Build.sas" ;

* Vaccinations ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Build\Vaccinations.sas" ;

* MIBA ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Build\MIBA, Build.sas" ;

* CPR ;
*%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Household Transmission\WGS\Build\CPR, Build.sas" ;

* DATES ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Build\DATES, Build.sas" ;

* Households ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Build\Households, Build.sas" ;

* Build ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Build\Build_Household_End_14_days.sas" ;


**************;
** ANALYSIS ;
**************;

* Descriptive Statistics ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Descriptive Stats.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Descriptive Stats_2.sas" ;


* Relative Risk ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\RR.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\RR having been tested.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\RR waning immunity.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\RR waning immunity_tested.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\RR 2_CT.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\RR 2_CT_tested.sas" ;


* Correlation of vaccination status ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Correlation of vaccination status.sas" ;

* same lineage ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Same Lineage.sas" ;

* secondary case ct value;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Test for different Ct values.sas" ;
* primary case ct value ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Ct_value_primaryCase.sas" ;

* Heatmaps ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Analysis_heatmaps.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Heat maps_RR.sas" ;

* Testing prob ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\Testing Prob across vaccinated and not vaccinated_V2.sas" ;
%include "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Analysis - Revision 1\PointProbTesting.sas" ;



*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	BUILD - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;
