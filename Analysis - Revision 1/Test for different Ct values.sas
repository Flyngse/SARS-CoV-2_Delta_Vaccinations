


data zz ;
	set data.prob_test_absorb_2 ;
		where 	test_pos = 1 
		and test_pos_day ne . 
		and ct_value ne .
		;
run;



* Figure ;

ods output GeeemppEst = parms ;
proc genmod data = zz plots=none ;
	class 
			house_number 
			test_pos_day
			age_5 (ref="12.5")	
			age_10 (ref="35")			
		house_members (ref="2")
		index_week
			/ param=glm;
	model	ct_value = test_pos_day fully_vaccinated*test_pos_day age_5 / noint;
	repeated subject=house_number / type=ind ;	
run;quit;

proc sql;
	create table parms_2

	as select
				p.*,
				a.estimate as baseline

	from 		parms		P

	left join 	parms		A
		on P.Level1 = A.level1
		and A.parm = "test_pos_day"

	order by parm, level1
;quit;

data parms_2 ;
	set parms_2 ;
		where parm not in ("Age_5", "Intercept") ;
		format estimate 10.1 ;

		if parm = "Fully_vac*test_pos_d" then group = "Fully vaccinated" ;
		if parm = "test_pos_day" then group = "Not vaccinated" ;


		day = level1+0 ;

		if group = "Not vaccinated" then estimate2 = estimate ;

		if group = "Fully vaccinated" then
			do;
				estimate2 = estimate + baseline ;
					format estimate2 10.0 ;
				UCL2 = upperCL + baseline ;
				LCL2 = LowerCL + baseline ;
			end;

run;

proc sort data = parms_2 ;
	by parm day ;
run;


ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\" ;
ods graphics / reset=index imagename = "CT_value_secondaryCase" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = parms_2 ;
		styleattrs 
				datacontrastcolors = (blue green ) 
				datasymbols=(diamondfilled squarefilled) 
				datalinepatterns=( solid dash ) 
				datacolors=(blue green ) 
				;
	series
			y = estimate2
			x = level1
			/ markers  group=group name="estimates";
	band
			x = level1 upper=UCL2 lower=LCL2 /  name="band" fillattrs=(color=blue transparency=0.9);

	yaxis values=(24 to 34 by 2)  label="Ct value" ;

	xaxis  label="Days since primary case" ;
	
	keylegend "estimates" / Title="" exclude=("band") position=topleft location=inside across=1 noborder opaque;

run;




* Table ;

ods output GeeemppEst = parms ;
proc genmod data = zz plots=none ;
	class 
			house_number 
			test_pos_day
			age_5 (ref="12.5")	
			age_10 (ref="35")			
		house_members (ref="2")
			/ param=glm;
	model	ct_value = fully_vaccinated test_pos_day    / ;
	repeated subject=house_number / type=ind ;	
run;quit;

ods output GeeemppEst = parms ;
proc genmod data = zz plots=none ;
	class 
			house_number 
			test_pos_day
			age_5 (ref="12.5")	
			age_10 (ref="35")			
		house_members (ref="2")
			/ param=glm;
	model	ct_value = fully_vaccinated test_pos_day  age_5  / ;
	repeated subject=house_number / type=ind ;	
run;quit;

ods output GeeemppEst = parms ;
proc genmod data = zz plots=none ;
	class 
			house_number 
			test_pos_day
			age_5 (ref="42.5")	
			age_10 (ref="35")		
			age_index_5	
		house_members (ref="2")
			/ param=glm;
	model	ct_value = fully_vaccinated test_pos_day  age_5 fully_vaccinated_index age_index_5  / noint;
	repeated subject=house_number / type=ind ;	
run;quit;


ods output GeeemppEst = parms ;
proc genmod data = zz plots=none ;
	where ct_value_index ne . ;
	class 
			house_number 
			test_pos_day
			age_5 (ref="42.5")	
			age_10 (ref="35")		
			age_index_5	
		house_members (ref="2")
		ct_value_index
			/ param=glm;
	model	ct_value = fully_vaccinated test_pos_day  age_5 fully_vaccinated_index age_index_5 ct_value_index / noint;
	repeated subject=house_number / type=ind ;	
run;quit;




proc means data = zz maxdec=2 mean std;
	where fully_vaccinated_index ne . and test_pos_day ne . and ct_value ne . ;
	var ct_value ;
run;

proc means data = zz  maxdec=2 mean std;
	where fully_vaccinated_index ne . and test_pos_day ne . and ct_value ne . and fully_vaccinated=0;
	var ct_value ;
run;



proc genmod data = zz plots=none ;
	class 
			house_number 
			test_pos_day
			age_5 (ref="12.5")	
			age_10 (ref="35")			
		house_members (ref="2")
		index_week
			/ param=glm;
	model	ct_value = fully_vaccinated test_pos_day fully_vaccinated*test_pos_day age_5 / type3 ;
	repeated subject=house_number / type=ind ;	
run;quit;


