


proc sort data = data.analysis_final_2 ; 
	by Age_index_20 Age_20;
run;

ods output estimate = parms_pos ;
proc genmod data = data.analysis_final_2 ;
	by Age_index_20 Age_20;
	class 
		pnr
		house_number
		house_members (ref="2")
		index_week
		/ ;
	model
			ever_test_pos_100  = Fully_vaccinated	
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;

data parms_pos2 ;
	set parms_pos ;
		where label = "Exp(Risk Ratio)" ;
			VE = (1-LBetaEstimate) *100 ;
				format VE 10.0 ;
			SE = StdErr*100 ;
				format SE 10.1 ;
			LCL = (1-LBetaUpperCL)*100 ;
			UCL = (1-LBetaLowerCL)*100 ;

run;

data parms ;
	set parms_pos2 ;
		if SE > 15 then delete ;
		estimate2 = ' ' || strip(put(VE,10.0)) || ' ' ;
		CI = '(' || strip(put(LCL,10.0)) || ';' || strip(put(UCL,10.0)) || ')' ;
run;


ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output - Revision 1" ;
ods graphics / reset=index imagename = "Age_by_Age_POOL_VES" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title 'Probability of being tested and testing positive by 5 year age group' ;
Title ;

proc sgplot data = parms  noborder noautolegend ;
	where Age_index_20 <= 80 
	and Age_20 <= 80
	;
	heatmapparm
				x = Age_index_20
				y = Age_20
				colorresponse= VE 
				/ colormodel = (orange yellow green )
				;

	text 
				x = Age_index_20
				y = Age_20
				text = estimate2 / textattrs=(size=14px) position=top vcenter=baseline
				;
	text 
				x = Age_index_20
				y = Age_20
				text = CI / textattrs=(size=10px) position=bottom  vcenter=baseline
				;
	yaxis 
			label = "Age of Contact (years)" 
			values = (0 to 80 by 20)
			;
	xaxis 
			values = (0 to 80 by 20)
			label = "Age of Primary Case (years)" 
			;
	gradlegend / Title="VE against susceptibility to infection" ;
run;



proc sort data = data.analysis_final_2 ; ;
	by Age_index_20 Age_20;
run;

ods output estimate = parms_pos ;
proc genmod data = data.analysis_final_2 ;
	by Age_index_20 Age_20;
	class 
		pnr
		house_number
		house_members (ref="2")
		index_week
		/ ;
	model
			ever_test_pos_100  = Fully_vaccinated_index	
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated_index 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;

data parms_pos2 ;
	set parms_pos ;
		where label = "Exp(Risk Ratio)" ;
			VE = (1-LBetaEstimate) *100 ;
				format VE 10.0 ;
			SE = StdErr*100 ;
				format SE 10.1 ;
			LCL = (1-LBetaUpperCL)*100 ;
			UCL = (1-LBetaLowerCL)*100 ;
run;

data parms ;
	set parms_pos2 ;
		if SE > 15 then delete ;
		estimate2 = ' ' || strip(put(VE,10.0)) || ' ' ;
		CI = '(' || strip(put(LCL,10.0)) || ';' || strip(put(UCL,10.0)) || ')' ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output - Revision 1" ;
ods graphics / reset=index imagename = "Age_by_Age_POOL_VET" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title 'Probability of being tested and testing positive by 5 year age group' ;
Title ;


proc sgplot data = parms  noborder noautolegend ;
	where Age_index_20 <= 80 
	and Age_20 <= 80
	;
	heatmapparm
				x = Age_index_20
				y = Age_20
				colorresponse= VE 
				/ colormodel = (orange yellow green )
				;

	text 
				x = Age_index_20
				y = Age_20
				text = estimate2 / textattrs=(size=14px) position=top vcenter=baseline
				;
	text 
				x = Age_index_20
				y = Age_20
				text = CI / textattrs=(size=10px) position=bottom  vcenter=baseline
				;

	yaxis 
			label = "Age of Contact (years)" 
			values = (0 to 80 by 20)
			;
	xaxis 
			values = (0 to 80 by 20)
			label = "Age of Primary Case (years)" 
			;
	gradlegend / Title="VE against infectiousness" ;
run;




proc sort data = data.analysis_final_2 ; ;
	by Age_index_20 Age_20;
run;

ods output estimate = parms_pos ;
proc genmod data = data.analysis_final_2 ;
	where Fully_vaccinated_twice ne . ;
	by Age_index_20 Age_20;
	class 
		pnr
		house_number
		house_members (ref="2")
		index_week
		/ ;
	model
			ever_test_pos_100  = Fully_vaccinated_twice	
								/ dist=poisson link=log
								;
			estimate 'Risk Ratio' Fully_vaccinated_twice 1 -1 / exp ;
			repeated subject=house_number / type=ind ;
run;quit;

data parms_pos2 ;
	set parms_pos ;
		where label = "Exp(Risk Ratio)" ;
			VE = (1-LBetaEstimate) *100 ;
				format VE 10.0 ;
			SE = StdErr*100 ;
				format SE 10.1 ;
			LCL = (1-LBetaUpperCL)*100 ;
			UCL = (1-LBetaLowerCL)*100 ;

run;

data parms ;
	set parms_pos2 ;
		if SE > 15 then delete ;
		estimate2 = ' ' || strip(put(VE,10.0)) || ' ' ;
		CI = '(' || strip(put(LCL,10.0)) || ';' || strip(put(UCL,10.0)) || ')' ;
run;


ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output - Revision 1" ;
ods graphics / reset=index imagename = "Age_by_Age_VE_CombinedEffect" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
Title 'Probability of being tested and testing positive by 5 year age group' ;
Title ;

proc sgplot data = parms  noborder noautolegend ;
	where Age_index_20 <= 80 
	and Age_20 <= 80
	;
	heatmapparm
				x = Age_index_20
				y = Age_20
				colorresponse= VE 
				/ colormodel = (orange yellow green )
				;

	text 
				x = Age_index_20
				y = Age_20
				text = estimate2 / textattrs=(size=14px) position=top vcenter=baseline
				;
	text 
				x = Age_index_20
				y = Age_20
				text = CI / textattrs=(size=10px) position=bottom  vcenter=baseline
				;

	yaxis 
			label = "Age of Contact (years)" 
			values = (0 to 80 by 20)
			;
	xaxis 
			values = (0 to 80 by 20)
			label = "Age of Primary Case (years)" 
			;
	gradlegend / Title= "Total VE" ;
run;


