



proc means data = data.analysis_final_2 maxdec=2 N mean;
	var same_variant same_lineage;
run;


proc genmod data = data.analysis_final_2 ;
	where same_lineage ne . ;
	class 
		pnr
		house_number
		/ param=glm;
	model
			same_lineage  = count	
								/ noint
								;
			repeated subject=house_number / type=ind ;
run;quit;


data zz ;
	set data.analysis_final_2 ;
		where same_lineage ne . ;
run;

proc sort data = zz ;
	by fully_vaccinated ;
run;

proc genmod data = zz ;
	by fully_vaccinated ;
	class 
		pnr
		house_number
		/ param=glm;
	model
			same_lineage  = count	
								/ noint
								;
			repeated subject=house_number / type=ind ;
run;quit;


proc sort data = zz ;
	by fully_vaccinated_index ;
run;

proc genmod data = zz ;
	by fully_vaccinated_index ;
	class 
		pnr
		house_number
		/ param=glm;
	model
			same_lineage  = count	
								/ noint
								;
			repeated subject=house_number / type=ind ;
run;quit;


proc sort data = zz ;
	by fully_vaccinated fully_vaccinated_index;
run;

proc genmod data = zz ;
	by fully_vaccinated fully_vaccinated_index;
	class 
		pnr
		house_number
		/ param=glm;
	model
			same_lineage  = count	
								/ noint
								;
			repeated subject=house_number / type=ind ;
run;quit;

