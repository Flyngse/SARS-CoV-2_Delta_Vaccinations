

proc sort data = data.prob_test_absorb_2 ;
by fully_vaccinated ;
run;
ods output GeeemppEst = parms_1 ;
proc genmod data = data.prob_test_absorb_2 plots=none ;
	by fully_vaccinated ;
	class 
			time_from_index
			house_number
			/ param=glm;
	model	ever_test_100 = time_from_index / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;
ods output GeeemppEst = parms_2 ;
proc genmod data = data.prob_test_absorb_2 plots=none ;
	by fully_vaccinated ;
	class 
			time_from_index
			house_number
			/ param=glm;
	model	ever_test_2_100 = time_from_index / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;

data parms_1x ;
	set parms_1 ;
		length var $ 12 ;
		Var = "Tested once" ; 
run;
data parms_2x ;
	set parms_2 ;
		length var $ 12 ;
		if Level1 = "0" then delete ;
		Var = "Tested twice" ; 
run;

data parms ;
	set 
		parms_1x 
		parms_2x 
		;

		Days = Level1+0 ;
		format estimate comma10.0 ;
		format LowerCL comma10.0 ;
		format UpperCL comma10.0 ;	

		if Fully_vaccinated = 1 then group = "Fully vaccinated" ;
		if Fully_vaccinated = 0 then group = "Not vaccinated" ;

		length group2 $ 32 ;
		group2 = trim(var) ||" - "|| group ;

		time_from_index = Level1+0 ;

		day = level1+0 ;

run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output - Revision 1" ;
ods graphics / reset=index imagename = "ProbTest" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = parms ;
	styleattrs 
				datacontrastcolors = (blue green blue green) 
				datasymbols=( diamondfilled trianglefilled diamond triangle ) 
				datalinepatterns=(solid solid dot dot) 
				datacolors=(blue green blue green) 
				;

	series
			y = estimate
			x = level1
			/ markers  group=group2 name="estimates";
	band	x = level1 upper=UpperCL lower=LowerCL /  name="band" transparency=0.9 group=group2;
	yaxis values=(0 to 100 by 10)  label="Probability of Test (%)" grid;
	xaxis  label="Days since primary case" ;
	keylegend "estimates" / Title="" exclude=("band") position=bottomright location=inside across=1 noborder opaque;
run;






ods output GeeemppEst = parms_1 ;
proc genmod data = data.prob_test_absorb_2 plots=none ;
	where time_from_index = 7 ;
	by fully_vaccinated ;
	class 
			age_5
			house_number
			/ param=glm;
	model	ever_test_100 = age_5 / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;

data parms_1x ;
	set parms_1 ;
		length var $ 12 ;
		Var = "Tested once" ; 
run;

data parms ;
	set 
		parms_1x 
		;

		Days = Level1+0 ;
		format estimate comma10.0 ;
		format LowerCL comma10.0 ;
		format UpperCL comma10.0 ;	

		if Fully_vaccinated = 1 then group = "Fully vaccinated" ;
		if Fully_vaccinated = 0 then group = "Not vaccinated" ;

		length group2 $ 32 ;
		group2 = trim(var) ||" - "|| group ;

		age = Level1+0 ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output - Revision 1" ;
ods graphics / reset=index imagename = "ProbTest_age" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = parms ;
	styleattrs 
				datacontrastcolors = (blue green blue green) 
				datasymbols=( diamondfilled trianglefilled diamond triangle ) 
				datalinepatterns=(solid solid dot dot) 
				datacolors=(blue green blue green) 
				;

	series
			y = estimate
			x = age
			/ markers  group=group2 name="estimates";
	band	x = level1 upper=UpperCL lower=LowerCL /  name="band" transparency=0.9 group=group2;
	yaxis values=(0 to 100 by 10)  label="Probability of Test (%)" grid;
	xaxis  	label = "Age (years)"	values = (0 to 80 by 5)	;
	keylegend "estimates" / Title="" exclude=("band") position=bottomright location=inside across=1 noborder opaque;
run;





ods output GeeemppEst = parms_1 ;
proc genmod data = data.prob_test_absorb_2 plots=none ;
	where time_from_index = 7 ;
	by fully_vaccinated ;
	class 
			index_week
			house_number
			/ param=glm;
	model	ever_test_100 = index_week / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;

data parms_1x ;
	set parms_1 ;
		length var $ 12 ;
		Var = "Tested once" ; 
run;

data parms ;
	set 
		parms_1x 
		;

		Days = Level1+0 ;
		format estimate comma10.0 ;
		format LowerCL comma10.0 ;
		format UpperCL comma10.0 ;	

		if Fully_vaccinated = 1 then group = "Fully vaccinated" ;
		if Fully_vaccinated = 0 then group = "Not vaccinated" ;

		length group2 $ 32 ;
		group2 = trim(var) ||" - "|| group ;

		index_week = Level1+0 ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output - Revision 1" ;
ods graphics / reset=index imagename = "ProbTest_week" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = parms ;
	styleattrs 
				datacontrastcolors = (blue green blue green) 
				datasymbols=( diamondfilled trianglefilled diamond triangle ) 
				datalinepatterns=(solid solid dot dot) 
				datacolors=(blue green blue green) 
				;

	series
			y = estimate
			x = index_week
			/ markers  group=group2 name="estimates";
	band	x = level1 upper=UpperCL lower=LowerCL /  name="band" transparency=0.9 group=group2;
	yaxis values=(0 to 100 by 10)  label="Probability of Test (%)" grid;
	xaxis  	label = "Calendar week"	values=(26 to 43 by 1);
	keylegend "estimates" / Title="" exclude=("band") position=bottomright location=inside across=1 noborder opaque;
run;
