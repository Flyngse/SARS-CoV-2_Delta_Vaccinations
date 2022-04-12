
ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\VES_Prim_not_vacc_tested.xlsx" ;
* VES_NOT vaccinated index ;
proc genmod data = data.analysis_final_2 ;
	where Fully_vaccinated_index = 0 and ever_test =1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		
		/ ;
	model
			ever_test_pos_100  = 	
								fully_vaccinated
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;
ods excel close ;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\VES_Prim_fully_vacc_tested.xlsx" ;
* VES_fully vaccinated index ;
proc genmod data = data.analysis_final_2 ;
	where Fully_vaccinated_index = 1 and ever_test =1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		/ ;
	model
			ever_test_pos_100  = Fully_vaccinated	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;
ods excel close ;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\VES_Prim_pool_tested.xlsx" ;
* VES_Pool vaccinated index ;
proc genmod data = data.analysis_final_2 ;
	where ever_test =1 ;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		/ ;
	model
			ever_test_pos_100  = Fully_vaccinated	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;
ods excel close ;


ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\VET_sec_not_vacc_tested.xlsx" ;
* VET_NOT vaccinated secondary ;
proc genmod data = data.analysis_final_2 ;
	where Fully_vaccinated = 0 and ever_test =1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		/  ;
	model
			ever_test_pos_100  = Fully_vaccinated_index	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated_index 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;
ods excel close ;


ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\VET_sec_fully_vacc_tested.xlsx" ;
* VET_Fully vaccinated secondary ;
proc genmod data = data.analysis_final_2 ;
where Fully_vaccinated = 1 and ever_test =1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		/  ;
	model
			ever_test_pos_100  = Fully_vaccinated_index	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated_index 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;
ods excel close ;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\VET_Sec_pool_tested.xlsx" ;
* VET_POLL vaccinated secondary ;
proc genmod data = data.analysis_final_2 ;
	where  ever_test =1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		/  ;
	model
			ever_test_pos_100  = Fully_vaccinated_index	
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated_index 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;
ods excel close ;

ods excel file="F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\VEC_combined_tested.xlsx" ;
* VEC - combined ;
proc genmod data = data.analysis_final_2 ;
where Fully_vaccinated_twice ne . and ever_test =1;
	class 
		Age_10 (ref="25")
		Age_5 (ref="22.5")
		Age_index_10 (ref="25")
		Age_index_5 (ref="22.5")
		pnr
		house_number
		house_members (ref="2")
		index_week
		/  ;
	model
			ever_test_pos_100  = Fully_vaccinated_twice
									index_week
									female
									female_index
									Age_10
									Age_index_10
									house_members				
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated_twice 1 -1  / exp ;
			repeated subject=house_number / type=ind ;
run;quit;
ods excel close ;

