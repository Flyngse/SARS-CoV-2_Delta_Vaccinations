


data zz ;
	set data.prob_test_absorb_2 ;
		where time_from_index = 14 ;
run;

proc sql;
	create table data.prob_test_absorb_2_expand

	as select
				A.*,
				D.date as date2,
				M.PrDate as PrDate2,
				M.Test as Test2

	from 		zz							A

	right join	data.dates_day_final		D
		on A.PrDate_index -14 < D.date <= A.PrDate_index +14

	left join		data.miba_final_1			M
		on 	A.pnr = m.pnr
		and	d.date = m.PrDate
		and m.Casedef = "SARS2"	

	where A.pnr ^= ""
;quit;

data data.prob_test_absorb_2_expand ;
	set data.prob_test_absorb_2_expand ;
		time_from_index_2 = date2 - PrDate_index  ;

		Tested_100 = Test2*100 ;
		if Test2 = . then Tested_100 = 0 ;
run;


proc sql;
	select 
			time_from_index_2,
			count(*) as count,
			mean(Tested_100) as Tested_100

	from data.prob_test_absorb_2_expand

	group by time_from_index_2
;quit;

proc sql;
	select 
			time_from_index_2,
			fully_vaccinated,
			count(*) as count,
			mean(Tested_100) as Tested_100

	from data.prob_test_absorb_2_expand

	group by time_from_index_2, fully_vaccinated
;quit;



proc sort data = data.prob_test_absorb_2_expand ;
by fully_vaccinated ;
run;
ods output GeeemppEst = parms_1 ;
proc genmod data = data.prob_test_absorb_2_expand plots=none ;
	by fully_vaccinated ;
	class 
			time_from_index_2
			house_number
			/ param=glm;
	model	Tested_100 = time_from_index_2 / noint ;
	repeated subject=house_number / type=ind ;	
run;quit;



data parms ;
	set 
		parms_1 
		;

		format estimate comma10.0 ;
		format LowerCL comma10.0 ;
		format UpperCL comma10.0 ;	

		if Fully_vaccinated = 1 then group = "Fully vaccinated" ;
		if Fully_vaccinated = 0 then group = "Not vaccinated" ;

		time_from_index = Level1+0 ;
		Days = Level1+0 ;
		day = level1+0 ;

run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output - Revision 1" ;
ods graphics / reset=index imagename = "ProbTest_pointProb_expand" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = parms ;
	where Days > -11 ;
	styleattrs 
				datacontrastcolors = (blue green blue green) 
				datasymbols=( diamondfilled trianglefilled diamond triangle ) 
				datalinepatterns=(solid solid dot dot) 
				datacolors=(blue green blue green) 
				;

	series
			y = estimate
			x = level1
			/ markers  group=group name="estimates";
	band	x = level1 upper=UpperCL lower=LowerCL /  name="band" transparency=0.9 group=group;
	yaxis values=(0 to 40 by 10)  label="Probability of Test (%)" grid;
	xaxis  label="Days since primary case" ;
	keylegend "estimates" / Title="" exclude=("band") position=topright location=inside across=1 noborder opaque;

	refline 0 / axis=x lineattrs=(pattern=dash) discreteoffset=-0.5 ;
run;

