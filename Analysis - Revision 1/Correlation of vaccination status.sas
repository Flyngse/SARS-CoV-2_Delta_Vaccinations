


proc reg data = data.Analysis_final_2 plots=none;
	model same_vaccine_status = count ;
run; quit;

proc reg data = data.Analysis_final_2 plots=none;
	where 12 < age_index and 12 < age ;
	model same_vaccine_status = count ;
run; quit;




ods output GEEEmpPEst = parms_pos ;
proc genmod data = data.Analysis_final_2 plots=none;
	class 
		Age_index_10
		Age_10
		pnr
		house_number
		/ param=glm;
	model
			same_vaccine_status = Age_index_10*Age_10 / noint  ;
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
			format estimate comma10.1 ;


		estimate2 = ' ' || strip(put(estimate,10.1)) || ' ' ;
run;


ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\" ;
ods graphics / reset=index imagename = "Age_by_Age_HHCOR_10Year" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title 'Probability of being tested and testing positive by 5 year age group' ;
Title ;

proc sgplot data = parms  noborder noautolegend ;
	where age_index <= 80 
	and age_secondary <= 80
	;

	heatmapparm
				x = age_index
				y = age_secondary
				colorresponse= estimate 
				/ colormodel = (lightyellow lightblue     gray)
				;

	text 
				x = age_index
				y = age_secondary
				text = estimate2 / position=top 
				;

	yaxis 
			label = "Age of Contact (years)" 
			values = (0 to 80 by 10)
			;
	xaxis 
			values = (0 to 80 by 10)
			label = "Age of Primary Case (years)" 
			;
	gradlegend / Title="Correlation" ;
run;


