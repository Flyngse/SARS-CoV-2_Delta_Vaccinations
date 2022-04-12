
*****
* Ct value distribution for primary cases - Histogram¨;

proc means data = Primary_cases_stat p10 q1 median q3 p95 mean maxdec=2 ;
	class Fully_vaccinated_index ;
	var ct_value_index ;
run;

ods listing gpath = "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\BreakTrough and Transmissibility\Output\" ;
ods graphics / reset=index imagename = "CT_value_PrimaryCase_Density" imagefmt=pdf ;
ods graphics on / attrpriority=none border=off ;
proc sgplot data = Primary_cases_stat ;
		styleattrs 
				datacontrastcolors = (blue green ) 
				datasymbols=(diamondfilled squarefilled) 
				datalinepatterns=( solid dash ) 
				datacolors=(blue green ) 
				;
	where Fully_vaccinated_index ne . ;
	density	ct_value_index / type=kernel 
						group=Vaccination_status_index
						;
	xaxis
		values = (14 to 42 by 2 ) 
		label = "Ct Value" ;
		;
	yaxis label = "Density (%)" ;

	keylegend / Title="Primary Case"  position=topright location=inside across=1 noborder opaque;

run;

