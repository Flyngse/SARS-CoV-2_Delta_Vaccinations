

* VES ;
ods output GEEEmpPEst = parms ;
proc genmod data = data.analysis_final_2 ;
	where Fully_vaccinated_index = 0;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		Time_since_FVaccinated_m2 (ref="0")
		/ ;
	model
			ever_test_pos_100  = 	
								Time_since_FVaccinated_m2
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			repeated subject=house_number / type=ind ;
run;quit;
%let name = parms_VES_index_unvaccinated ;
data &name. ;
	set parms ;
		EST_VE = (1-exp(estimate))*100 ;
		LCL_VE = (1-exp(UpperCL))*100 ;
		UCL_VE = (1-exp(LowerCL))*100 ;
		EST_VE_2 = round(EST_VE) ;
		VE_CI = "(" || strip(round(LCL_VE)) || ";" || strip(round(UCL_VE)) || ")" ;
run;
proc export 
	data = &name. 
	dbms = xlsx
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\&name..xlsx"
	replace
	;
run;

ods output GEEEmpPEst = parms ;
proc genmod data = data.analysis_final_2 ;
	where Fully_vaccinated_index = 1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		Time_since_FVaccinated_m2 (ref="0")
		/ ;
	model
			ever_test_pos_100  = 	
								Time_since_FVaccinated_m2
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			repeated subject=house_number / type=ind ;
run;quit;
%let name = parms_VES_index_vaccinated ;
data &name. ;
	set parms ;
		EST_VE = (1-exp(estimate))*100 ;
		LCL_VE = (1-exp(UpperCL))*100 ;
		UCL_VE = (1-exp(LowerCL))*100 ;
		EST_VE_2 = round(EST_VE) ;
		VE_CI = "(" || strip(round(LCL_VE)) || ";" || strip(round(UCL_VE)) || ")" ;
run;
proc export 
	data = &name. 
	dbms = xlsx
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\&name..xlsx"
	replace
	;
run;


ods output GEEEmpPEst = parms ;
proc genmod data = data.analysis_final_2 ;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		Time_since_FVaccinated_m2 (ref="0")
		/ ;
	model
			ever_test_pos_100  = 	
								Time_since_FVaccinated_m2
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			repeated subject=house_number / type=ind ;
run;quit;
%let name = parms_VES_index_pool ;
data &name. ;
	set parms ;
		EST_VE = (1-exp(estimate))*100 ;
		LCL_VE = (1-exp(UpperCL))*100 ;
		UCL_VE = (1-exp(LowerCL))*100 ;
		EST_VE_2 = round(EST_VE) ;
		VE_CI = "(" || strip(round(LCL_VE)) || ";" || strip(round(UCL_VE)) || ")" ;
run;
proc export 
	data = &name. 
	dbms = xlsx
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\&name..xlsx"
	replace
	;
run;

ods output GEEEmpPEst = parms ;
proc genmod data = data.analysis_final_2 ;
	where Fully_vaccinated = 0;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		Time_since_FVaccinated_index_m2 (ref="0")
		/  ;
	model
			ever_test_pos_100  = Time_since_FVaccinated_index_m2	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			repeated subject=house_number / type=ind ;
run;quit;
%let name = parms_VET_sec_unvaccinated ;
data &name. ;
	set parms ;
		EST_VE = (1-exp(estimate))*100 ;
		LCL_VE = (1-exp(UpperCL))*100 ;
		UCL_VE = (1-exp(LowerCL))*100 ;
		EST_VE_2 = round(EST_VE) ;
		VE_CI = "(" || strip(round(LCL_VE)) || ";" || strip(round(UCL_VE)) || ")" ;
run;
proc export 
	data = &name. 
	dbms = xlsx
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\&name..xlsx"
	replace
	;
run;


* VET_pool ;
ods output GEEEmpPEst = parms ;
proc genmod data = data.analysis_final_2 ;
where Fully_vaccinated = 1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		Time_since_FVaccinated_index_m2 (ref="0")
		/  ;
	model
			ever_test_pos_100  = 	Time_since_FVaccinated_index_m2	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			repeated subject=house_number / type=ind ;
run;quit;
%let name = parms_VET_sec_vaccinated ;
data &name. ;
	set parms ;
		EST_VE = (1-exp(estimate))*100 ;
		LCL_VE = (1-exp(UpperCL))*100 ;
		UCL_VE = (1-exp(LowerCL))*100 ;
		EST_VE_2 = round(EST_VE) ;
		VE_CI = "(" || strip(round(LCL_VE)) || ";" || strip(round(UCL_VE)) || ")" ;
run;
proc export 
	data = &name. 
	dbms = xlsx
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\&name..xlsx"
	replace
	;
run;


* VET_pool ;
ods output GEEEmpPEst = parms ;
proc genmod data = data.analysis_final_2 ;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		Time_since_FVaccinated_index_m2 (ref="0")
		/  ;
	model
			ever_test_pos_100  = 	Time_since_FVaccinated_index_m2	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			repeated subject=house_number / type=ind ;
run;quit;
%let name = parms_VET_sec_pool ;
data &name. ;
	set parms ;
		EST_VE = (1-exp(estimate))*100 ;
		LCL_VE = (1-exp(UpperCL))*100 ;
		UCL_VE = (1-exp(LowerCL))*100 ;
		EST_VE_2 = round(EST_VE) ;
		VE_CI = "(" || strip(round(LCL_VE)) || ";" || strip(round(UCL_VE)) || ")" ;
run;
proc export 
	data = &name. 
	dbms = xlsx
	outfile = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\&name..xlsx"
	replace
	;
run;
	
