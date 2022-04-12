

* descriptives ;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\PotentialSecondaryCases_stat_3_prim.xlsx" ;
proc freq data= data.analysis_final_2 ;
	table Vaccination_status_index / nocol norow nopercent nocum;
run;
* Sex ;
proc freq data= data.analysis_final_2 ;
	table female_index*Vaccination_status_index / nocol norow nopercent nocum;
run;
* Age ;
proc freq data= data.analysis_final_2 ;
	table Age_index_10*Vaccination_status_index / nocol norow nopercent nocum;
run;
* Houshold Size ;
proc freq data= data.analysis_final_2 ;
	table house_members*Vaccination_status_index / nocol norow nopercent nocum;
run;
proc freq data= data.analysis_final_2 ;
	table Full_Vaccine_Name_index*Vaccination_status_index / nocol norow nopercent nocum;
run;
ods excel close ;


ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\PositiveSecondaryCases_stat_3_prim.xlsx" ;
proc freq data= data.analysis_final_2 ;
	where ever_test_pos_100 = 100 ;
	table Vaccination_status_index / nocol norow nopercent nocum;
run;
* Sex ;
proc freq data= data.analysis_final_2 ;
	where ever_test_pos_100 = 100 ;
	table female_index*Vaccination_status_index / nocol norow nopercent nocum;
run;
* Age ;
proc freq data= data.analysis_final_2 ;
	where ever_test_pos_100 = 100 ;
	table Age_index_10*Vaccination_status_index / nocol norow nopercent nocum;
run;
* Houshold Size ;
proc freq data= data.analysis_final_2 ;
	where ever_test_pos_100 = 100 ;
	table house_members*Vaccination_status_index / nocol norow nopercent nocum;
run;
proc freq data= data.analysis_final_2 ;
	where ever_test_pos_100 = 100 ;
	table Full_Vaccine_Name_index*Vaccination_status_index / nocol norow nopercent nocum;
run;
ods excel close ;
