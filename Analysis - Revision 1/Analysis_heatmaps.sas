
******************** Heat maps ;


proc sort data = super_shead6  ;
	by lineage ;
run;

ods output GEEEmpPEst = parms_pos ;
proc genmod data = super_shead6 plots=none;
	by  lineage ;
	class 
		Age_index_20
		Age_20
		pnr
		house_number
		/ param=glm;
	model
			ever_test_pos_100 = Age_index_20*Age_20 / noint  ;
			weight weight_d1 ;
			repeated subject = house_number / type=ind;
run;quit;
data parms_pos ;
	set parms_pos ;
		length var $10 ;
		var = "Positive" ;
run;
data parms ;
	set 
		
		parms_pos 
		;
		age_index = Level1+0 ;
		age_secondary = Level2+0 ;
			format estimate comma10.0 ;

		if Stderr = 0.0000 then delete ;

		estimate2 = ' ' || strip(put(estimate,10.0)) || ' ' ;
		standarderror = '(' || strip(put(Stderr,10.1)) || ')' ;
run;


proc sql;
	create table aa

	as select 
				lineage,
				Age_index_20,
				Age_20,
				count(distinct PNR_index) as count_index,
				count(*) as count_pot_sec,
				sum(ever_test_pos_100/100) as pos_sec

	from super_shead6

	group by 
				lineage,
				Age_index_20,
				Age_20
;quit;

proc sql;
	create table parms_2

	as select
				p.*,
				a.*

	from 	parms	p

	left join aa	a
		on p.lineage = a.lineage
		and p.age_index = a.Age_index_20
		and p.age_secondary = a.Age_20
;quit;

data parms_3 ;
	set parms_2 ;

		n = '[' ||strip(put(pos_sec,comma20.)) || '/' ||strip(put(count_pot_sec,comma20.))|| '/' || strip(put(count_index,comma20.)) || ']' ;
		if pos_sec <5 then n = '[<5/' ||strip(put(count_pot_sec,comma20.))|| '/' || strip(put(count_index,comma20.)) || ']' ;

		q = strip(standarderror)||';'||strip(n) ;
run;



ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Household Transmission\WGS\Output Revision 1\" ;
ods graphics / reset=index imagename = "Age_by_Age_TransmissionRATE_1" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title 'Probability of being tested and testing positive by 5 year age group' ;
Title ;

proc sgplot data = parms_3  noborder noautolegend ;
	where age_index <= 80 
	and age_secondary <= 80
	and lineage = "B.1.1.7"
	;
	heatmapparm
				x = age_index
				y = age_secondary
				colorresponse= estimate 
				/ colormodel = (green yellow red) 
				;

	text 
				x = age_index
				y = age_secondary
				text = estimate2 / position=top vcenter=baseline textattrs=(size=15px)
				;
	text 
				x = age_index
				y = age_secondary
				text = q / position=bottom textattrs=(size=11px)  splitchar=";" splitpolicy=splitalways vcenter=baseline 
				;

	yaxis 
			label = "Age of Potential Secondary Case (years)" 
			values = (0 to 80 by 20)
			;
	xaxis 
			values = (0 to 80 by 20)
			label = "Age of Primary Case (years)" 
			;
	gradlegend / Title="Transmission Rate (%)" ;
run;


ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Household Transmission\WGS\Output Revision 1\" ;
ods graphics / reset=index imagename = "Age_by_Age_TransmissionRATE_2" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title 'Probability of being tested and testing positive by 5 year age group' ;
Title ;

proc sgplot data = parms_3  noborder noautolegend ;
	where age_index <= 80 
	and age_secondary <= 80
	and lineage = "Other"
	;
	heatmapparm
				x = age_index
				y = age_secondary
				colorresponse= estimate 
				/ colormodel = (green yellow red) 
				;

	text 
				x = age_index
				y = age_secondary
				text = estimate2 / position=top vcenter=baseline textattrs=(size=15px)
				;
	text 
				x = age_index
				y = age_secondary
				text = q / position=bottom textattrs=(size=11px)  splitchar=";" splitpolicy=splitalways vcenter=baseline 
				;

	yaxis 
			label = "Age of Potential Secondary Case (years)" 
			values = (0 to 80 by 20)
			;
	xaxis 
			values = (0 to 80 by 20)
			label = "Age of Primary Case (years)" 
			;
	gradlegend / Title="Transmission Rate (%)" ;
run;



ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Household Transmission\WGS\Output Revision 1\" ;
ods graphics / reset=index imagename = "Age_by_Age_TransmissionRATE_3" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title 'Probability of being tested and testing positive by 5 year age group' ;
Title ;

proc sgplot data = parms_3  noborder noautolegend ;
	where age_index <= 80 
	and age_secondary <= 80
	and lineage = "No Genome"
	;
	heatmapparm
				x = age_index
				y = age_secondary
				colorresponse= estimate 
				/ colormodel = (green yellow red) 
				;

	text 
				x = age_index
				y = age_secondary
				text = estimate2 / position=top vcenter=baseline textattrs=(size=15px)
				;
	text 
				x = age_index
				y = age_secondary
				text = q / position=bottom textattrs=(size=11px)  splitchar=";" splitpolicy=splitalways vcenter=baseline 
				;

	yaxis 
			label = "Age of Potential Secondary Case (years)" 
			values = (0 to 80 by 20)
			;
	xaxis 
			values = (0 to 80 by 20)
			label = "Age of Primary Case (years)" 
			;
	gradlegend / Title="Transmission Rate (%)" ;
run;
