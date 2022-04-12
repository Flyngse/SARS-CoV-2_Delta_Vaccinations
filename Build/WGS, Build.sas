********************************
	WGS - START
********************************;

/*
proc import
	datafile 	= "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Data\wgs_data_20210927_cpr10.csv"
	out 		= WGS
	dbms		= csv
	replace ;
	delimiter 	= ";" ;
	getnames 	= yes ;
run; 
*/

proc import
	datafile 	= "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Data\wgs_data_20211110_cpr10.csv"
	out 		= WGS
	dbms		= csv
	replace ;
	delimiter 	= ";" ;
	getnames 	= yes ;
run; 



data WGS ;
	set WGS ;
		rename CPR_ENCRYPTED = pnr ;
		WGS_Selection = 1 ;

		keep
				CPR_ENCRYPTED
				pnr
				CLADE
				LINEAGE
				SEQUENCE_STATUS
				WGS_Selection
				WHO_VARIANT
				LINEAGES_OF_INTEREST
				;
run;

data data.WGS ;
	set WGS ;
		length variant $ 10 ;
		variant = "Other" ;
		if lineage in ("B.1.617.2", "AY.1", "AY.2", "AY.3") then variant = "Delta";
		if LINEAGE = "B.1.1.7" then variant = "Alpha";
		if LINEAGE = "" then variant = "No Genome" ;
run;

/*
proc sort data = data.wgs ;
	by variant ;
run;

proc sql;
	select
			variant,
			count(*)

	from data.wgs

	group by variant
;quit;
*/


*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	WGS - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;


/*
proc sql;
	create table data.zz

	as select
				pnr,
				count(*) as count

	from data.wgs

	group by pnr

	order by count
;quit;
*/
