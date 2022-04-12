
* Build Contact Tracing ;


******* 
	Build_Household_End_14_days 
******* ;

* Merge first positive on households ;
proc sql;
	create table	data.Contact_house

	as select 
				H.*,
				F.PrDate,
				F.Ct_value,
				F.TCD,
				F.WGS_Selection,
				F.WGS_genome,
				F.variant,
				F.WHO_VARIANT,
				F.LINEAGES_OF_INTEREST,
				F.LINEAGE

	from		data.home_full_2			H

	inner join	data.First_Positive_2		F
		on H.pnr = F.pnr
		and F.new_positive = 1

	where 2 <= house_members <= 6

	order by
			house_number,
			PrDate
;quit;

data data.Contact_house_first ;
	set data.Contact_house ;
		by house_number ;
			if first.house_number then output ; 
run;
data data.Contact_house_first ;
	set data.Contact_house_first ;
		rename  pnr  = PNR_index ;
		rename PrDate = PrDate_index ;
		rename  female = Female_index ;
		rename  age = Age_index ;
		rename  age_5 = Age_index_5 ;
		rename  age_10 =Age_index_10 ;
		rename  age_20 = Age_index_20 ;
		rename agegroup_2 = agegroup_2_index ;
		rename Ct_value = Ct_value_index   ;
		rename TCD = TCD_index ;
		rename WGS_Selection = WGS_Selection_index ;
		rename WGS_genome = WGS_genome_index ;
		rename WHO_VARIANT = WGS_variant_index ;
		rename lineage = WGS_lineage_index ;
		rename LINEAGES_OF_INTEREST = LINEAGES_OF_INTEREST_index ;

run;

proc sql;
	create table data.contact_1

	as select
				H.*,
				F.*

	from		data.home_full_2				H

	inner join	data.Contact_house_first		F
		on H.house_number = F.house_number
;quit;

data  data.contact_1 ;
	set data.contact_1 ;
		if pnr = PNR_index then delete ;

		index_week = week(PrDate_index, 'v') ;

		format PrDate_index date9. ;
		format UtDate_index date9. ;

run;

proc sql;
	create table	data.contact_2

	as select distinct
						C.*,
						D.*,
						M.PrDate,
						M.test_pos,
						F.LINEAGE as LINEAGE_secondary,
						F.WGS_Selection as WGS_Selection_secondary,
						F.WGS_genome as WGS_genome_secondary,
						F.WHO_VARIANT,
						M.Test,
						M.CT_value,
						VI.Full_Vaccine_Name as Full_Vaccine_Name_index,
						VI.first_VaccineDate as first_VaccineDate_index,
						VI.fully_vaccinated_Date as fully_vaccinated_Date_index,
						VI.revacc1_VaccineDate as revacc1_VaccineDate_index,
						VS.Full_Vaccine_Name as Full_Vaccine_Name,
						VS.first_VaccineDate as first_VaccineDate,
						VS.fully_vaccinated_Date as fully_vaccinated_Date,
						VS.revacc1_VaccineDate as revacc1_VaccineDate


	from			data.contact_1				C

	right join		data.dates_day_final		D
		on 	C.pnr
		and	c.PrDate_index -0 <= d.date <= c.PrDate_index +14

	left join		data.miba_final_1			M
		on 	c.pnr = m.pnr
		and	d.date = m.PrDate
		and m.Casedef = "SARS2"

	left join		data.vaccine_2				VI
		on C.pnr_index = VI.pnr

	left join		data.vaccine_2				VS
		on C.pnr = VS.pnr

	left join		data.First_positive_2		F
		on C.pnr = F.pnr

	where c.pnr ^= ""

	order by
			house_number,
			pnr,
			date
;quit;


data data.contact_3 ;
	set data.contact_2 ;

		time_from_index = date - PrDate_index ;

		if test = . then test = 0 ;
		if pnr = "" then delete ;

			by house_number pnr ;
				if first.pnr then 
					do;
						test_cum 	 = 0 ;
						test_pos_cum = 0 ;
					end;
					test_cum 		+ test ;
					test_pos_cum 	+ test_pos ;

		ever_test 		= min(test_cum,1) ;
		ever_test_pos	= min(test_pos_cum,1) ;

		ever_test_1 	= min(test_cum,1) ;
		ever_test_pos_1	= min(test_pos_cum,1) ;

		ever_test_2 	= min(test_cum,2) ;
			if ever_test_2 < 2 then ever_test_2 = 0 ;
			if ever_test_2 = 2 then ever_test_2 = 1 ;
		ever_test_pos_2	= min(test_pos_cum,2) ;
			if ever_test_pos_2 < 2 then ever_test_pos_2 = 0 ;



		if first_VaccineDate_index <= PrDate_index < fully_vaccinated_Date_index then Vaccination_status_index = "Partly vaccinated" ;
		if fully_vaccinated_Date_index <= PrDate_index then Vaccination_status_index = "Fully vaccinated" ;
		if PrDate_index < first_VaccineDate_index then Vaccination_status_index = "Not vaccinated" ;
		if first_VaccineDate_index = . then Vaccination_status_index = "Not vaccinated" ;
		if fully_vaccinated_Date_index = . and first_VaccineDate_index ne . then Vaccination_status_index = "Partly vaccinated" ;

		if first_VaccineDate <= PrDate_index < fully_vaccinated_Date then Vaccination_status = "Partly vaccinated" ;
		if fully_vaccinated_Date <= PrDate_index then Vaccination_status = "Fully vaccinated" ;
		if PrDate_index < first_VaccineDate then Vaccination_status = "Not vaccinated" ;
		if first_VaccineDate = . then Vaccination_status = "Not vaccinated" ;
		if fully_vaccinated_Date = . and first_VaccineDate ne . then Vaccination_status = "Partly vaccinated" ;

		if Vaccination_status_index = "Fully vaccinated"  then Fully_vaccinated_index = 1 ;
		if Vaccination_status_index = "Not vaccinated"  then Fully_vaccinated_index = 0 ;

		if Vaccination_status = "Fully vaccinated"  then Fully_vaccinated = 1 ;
		if Vaccination_status = "Not vaccinated"  then Fully_vaccinated = 0 ;

		Time_since_FVaccinated_index = PrDate_index - fully_vaccinated_Date_index ;
			if Time_since_FVaccinated_index < 0 then Time_since_FVaccinated_index = . ;
		Time_since_FVaccinated_index_m1 = int(Time_since_FVaccinated_index/30)+1 ;
		if Fully_vaccinated_index = 0 then Time_since_FVaccinated_index_m1 = 0 ;
		Time_since_FVaccinated_index_m2 = int(Time_since_FVaccinated_index/60)+1 ;		
		if Fully_vaccinated_index = 0 then Time_since_FVaccinated_index_m2 = 0 ;

		Time_since_FVaccinated = PrDate_index - fully_vaccinated_Date ;
			if Time_since_FVaccinated < 0 then Time_since_FVaccinated = . ;
		Time_since_FVaccinated_m1 = int(Time_since_FVaccinated/30)+1 ;
		if Fully_vaccinated = 0 then Time_since_FVaccinated_m1 = 0 ;
		Time_since_FVaccinated_m2 = int(Time_since_FVaccinated/60)+1 ;
		if Fully_vaccinated = 0 then Time_since_FVaccinated_m2 = 0 ;

		Revacc_index = 0 ;
		if revacc1_VaccineDate_index NE . and revacc1_VaccineDate_index <= PrDate_index then Revacc_index = 1 ;

		Revacc = 0 ;
		if revacc1_VaccineDate NE . and revacc1_VaccineDate <= PrDate_index then Revacc = 1 ;

run;

proc sql;
	create table data.first_day

	as select
				pnr,
				test_pos,
				test_pos_cum,
				time_from_index

	from data.contact_3

	where 	test_pos = 1
	and		test_pos_cum = 1
;quit;

proc sql;
	create table data.contact_4

	as select
				C.*,
				F.time_from_index as test_pos_day

	from		data.contact_3		C

	left join	data.first_day		F
		on C.pnr = F.pnr
;quit;

data data.contact_4 ;
	set data.contact_4 ;
		if test_pos_day = . then test_pos_day = 99 ;
run;

data data.super_shead_CO_prim_homes_1 ;
	set data.contact_4 ;	
		where 	time_from_index = 14 ;
				keep
				test_pos_day
				house_number
				co_primary_dayZERO_home
				;

		co_primary_dayZERO_home = 0 ;
		if test_pos_day = 0 then co_primary_dayZERO_home = 1 ;
run;


proc sql;
	create table	data.Co_primary_homes

	as select distinct 	
						house_number,
						max(co_primary_dayZERO_home) as co_primary_dayZERO_home

	from data.super_shead_CO_prim_homes_1

	group by house_number
;quit;

proc sql;
	create table data.contact_4x

	as select
				A.*,
				C.co_primary_dayZERO_home

	from 		data.contact_4			A

	left join 	data.Co_primary_homes	C
		on A.house_number = C.house_number
;quit;


data data.prob_test_absorb ;
	set data.contact_4x ;
		where
			Age_index_5 <90
			and 1 < house_members < 7
			and female_index ne .
			and house_members ne .
			and 0 < test_pos_day 
			and '01JUN2021'd <= PrDate_index <= '26oct2021'd 
			and LINEAGES_OF_INTEREST_index = "Delta"

			;

		ever_test_100 = ever_test*100 ;
		ever_test_pos_100 = ever_test_pos*100 ; 

		ever_test_1_100 	= ever_test_1*100 ;
		ever_test_pos_1_100	= ever_test_pos_1*100 ;
		ever_test_2_100 	= ever_test_2*100 ;
		ever_test_pos_2_100	= ever_test_pos_2*100 ;
run;


data data.contact_5 ;
	set data.prob_test_absorb ;
		where 	time_from_index = 14 ;
		count = 1 ;
run;

* collapse on househould ;
proc sql ;
	create table data.HH

	as select
				house_number,
				house_members,
				sum(ever_test) as N_test_HH,
				sum(ever_test_pos) as N_positive_HH				

	from 	data.contact_5

	where 	time_from_index = 14

	group by
			house_number,
			house_members
;quit;

proc sql;
	create table	data.contact_6

	as select
				c.*,
				H.N_test_HH,
				H.N_positive_HH

	from 		data.contact_5		C

	left join	data.HH				H
		on c.house_number = H.house_number
;quit;

data data.super_shead ;
	set data.contact_6 ;
		ever_test_100 = ever_test*100 ;
		ever_test_pos_100 = ever_test_pos*100 ; 
		ever_test_2_100 	= ever_test_2*100 ;
run;

***** CT BUILD ;
data data.super_shead5 ;
	set data.super_shead ;

		*CT_value = CT_value_index ;
		CT_value_index_exist = 1 ;  
		if CT_value_index = . then CT_value_index_exist = 0 ;  

		*if CT_value_index < 28 then CT_value_median_above = 0 ;
		*if CT_value_index >= 28 then CT_value_median_above = 1 ;

		*if CT_value_index < 25 then CT_value_Q = 1 ; 
		*if 25 <= CT_value_index < 28 then CT_value_Q = 2 ; 
		*if 28 <= CT_value_index < 32 then CT_value_Q = 3 ; 
		*if 32 <= CT_value_index <= 38 then CT_value_Q = 4 ; 
		*if CT_value < 18 then CT_value_Q = . ;
		*if CT_value > 38 then CT_value_Q = . ;

		*if CT_value_Q = 1 then CT_value_Q2 = (25+18)/2 ;
		*if CT_value_Q = 2 then CT_value_Q2 = (28+25)/2 ;
		*if CT_value_Q = 3 then CT_value_Q2 = (32+28)/2 ;
		*if CT_value_Q = 4 then CT_value_Q2 = (38+32)/2 ;

		CT_value_index_1 = round(CT_value_index) ;
		CT_value_index_2 = (int((CT_value_index - 1) / 2) + 1 ) * 2 - 1;

		weight = 1 / (house_members-1) ;

run;

%macro qq() ;
	proc sql;
		create table data.Any_transmission_d&ii.

		as select distinct
					house_number,
					house_members,
					min( sum(ever_test_pos_1), 1)*100 as transmission_d&ii.,
					count(pnr) as count_pot_sec_cases_d&ii.,
					 1/count(pnr) as weight_d&ii.

		from data.super_shead5

		where &ii. <= test_pos_day

		group by house_number
	;quit;
%mend;

%let ii = 1 ;
%qq() ;
%let ii = 2 ;
%qq() ;
%let ii = 3 ;
%qq() ;
%let ii = 4 ;
%qq() ;

proc sql;
	create table data.Any_transmission

	as select
				D1.house_number,
				D1.transmission_d1,
				D1.weight_d1,
				D2.transmission_d2,
				D2.weight_d2,
				D3.transmission_d3,
				D3.weight_d3,
				D4.transmission_d4,
				D4.weight_d4

	from 		data.Any_transmission_d1		D1

	left join 	data.Any_transmission_d2		D2
		on D1.house_number = D2.house_number

	left join 	data.Any_transmission_d3		D3
		on D1.house_number = D3.house_number

	left join 	data.Any_transmission_d4		D4
		on D1.house_number = D4.house_number
;quit;

proc sql;
	create table data.super_shead6

	as select
				S.*,
				T.*,
				C.co_primary_dayZERO_home


	from 		data.super_shead5		S

	left join 	data.Any_transmission	T	
		on S.house_number = T.house_number

	left join 	data.Co_primary_homes	C
		on S.house_number = C.house_number
;quit;

data data.Analysis_final ;
	set data.super_shead6 ;
		if Fully_vaccinated_index = 1 and Fully_vaccinated = 1 then Fully_vaccinated_twice = 1 ;
		if Fully_vaccinated_index = 0 and Fully_vaccinated = 0 then Fully_vaccinated_twice = 0 ;

		same_vaccine_status=0 ;
		if Fully_vaccinated_index = Fully_vaccinated then same_vaccine_status=1 ;
		*if Fully_vaccinated_index <> Fully_vaccinated then same_vaccine_status=0 ;
		*if Fully_vaccinated_index =. or Fully_vaccinated = . then same_vaccine_status=0 ;

		if Full_Vaccine_Name_index = "" then Full_Vaccine_Name_index = "None" ;
		if Full_Vaccine_Name = "" then Full_Vaccine_Name = "None" ;
	

run;

data data.analysis_final_2 ;
	set data.analysis_final ;
		*where Fully_vaccinated_index ne . and Fully_vaccinated ne .  and Age_10<80 and Age_index_10<70 and 25<index_week and Revacc =0 and Revacc_index=0;
		where Fully_vaccinated_index ne . and Fully_vaccinated ne .  and Age_10<80 and Age_index_10<80 and 25<index_week and Revacc =0 and Revacc_index=0;
		*where Fully_vaccinated_index ne . and Age_10<80 and Age_index_10<70 and 25<index_week ;
		*if Vaccination_status = "Partly vaccinated" then delete ;
		if co_primary_dayZERO_home = 1 then delete ;


		if LINEAGES_OF_INTEREST_index = "Delta" then wgs_lineage_index_2 = "Other Delta Lineages" ;
		if wgs_lineage_index = "B.1.617.2" then wgs_lineage_index_2 = wgs_lineage_index ;
		if wgs_lineage_index = "AY.4" then wgs_lineage_index_2 = wgs_lineage_index ;

		if LINEAGES_OF_INTEREST = "Delta" then LINEAGE_secondary_2 = "Other Delta Lineages" ;
		if LINEAGE_secondary = "B.1.617.2" then LINEAGE_secondary_2 = LINEAGE_secondary ;
		if LINEAGE_secondary = "AY.4" then LINEAGE_secondary_2 = LINEAGE_secondary ;

		if LINEAGE_secondary = WGS_lineage_index  then same_lineage = 1 ;
		if LINEAGE_secondary ne WGS_lineage_index then same_lineage = 0 ;
		if LINEAGE_secondary = "" or WGS_lineage_index = "" then same_lineage = . ;
		if ever_test_pos_100 = 0 then same_lineage = . ; 

		if WHO_VARIANT = WGS_variant_index  then same_variant = 1 ;
		if WHO_VARIANT ne WGS_variant_index then same_variant = 0 ;
		if WHO_VARIANT = "" or WGS_variant_index = "" then same_variant = . ;
		if ever_test_pos_100 = 0 then same_variant = . ; 

run;

data data.prob_test_absorb_2;
	set data.prob_test_absorb ;
		where Fully_vaccinated_index ne . and Fully_vaccinated ne .  and Age_10<80 and Age_index_10<80 and 25<index_week and Revacc =0 and Revacc_index=0;
		if co_primary_dayZERO_home = 1 then delete ;

		if LINEAGE_secondary = WGS_lineage_index  then same_lineage = 1 ;
		if LINEAGE_secondary ne WGS_lineage_index then same_lineage = 0 ;
		if LINEAGE_secondary = "" or WGS_lineage_index = "" then same_lineage = . ;
		if ever_test_pos_100 = 0 then same_lineage = . ; 
run;

proc sql;
	create table Primary_cases_stat

	as select distinct
						PNR_index,
						TCD_index,
						ct_value_index,
						Age_index_5,
						Age_index_10,
						female_index,
						count,
						house_members,
						Vaccination_status_index,
						fully_vaccinated_index,
						index_week,
						WGS_Selection_index,
						WGS_lineage_index,
						WGS_variant_index,
						wgs_lineage_index_2,
						Full_Vaccine_Name_index

	from data.analysis_final_2
;quit;



/*
proc means data = Primary_cases_stat maxdec=0 N;
	class WGS_lineage_index ;
	var count ;
run;

proc means data = Primary_cases_stat maxdec=0 N;
	class WGS_variant_index wgs_lineage_index_2;
	var count ;
run;

proc means data = data.analysis_final_2 maxdec=2 N mean;
	var same_variant same_lineage;
run;


proc means data = Primary_cases_stat maxdec=2;
	var same_lineage ;
run;


proc means data = Primary_cases_stat maxdec=2;
	class WGS_variant_index wgs_lineage_index_2;
	var same_lineage ;
run;



proc means data = data.analysis_final_2 maxdec=2;
	class fully_vaccinated_index;
	var same_lineage ;
run;



proc means data = data.analysis_final_2 maxdec=2;
	class test_pos_day;
	var same_lineage ;
run;

proc means data = data.analysis_final_2 maxdec=2;
	class index_week;
	var same_lineage ;
run;

data bb ;
	set data.analysis_final_2 ;
		where same_lineage ne . ;
run;


data bb ;
	set data.analysis_final_2 ;
		where same_lineage = 0 ;
run;



proc means data = data.analysis_final_2 maxdec=2;
	var same_lineage ;
run;


proc means data = data.analysis_final_2 maxdec=2;
	class ever_test_pos_100 ;
	var same_lineage ;
run;




proc means data = data.analysis_final_2 maxdec=2;
	class ever_test_pos_100 test_pos_day;
	var same_lineage ;
run;


proc means data = data.analysis_final_2 maxdec=2;
	class test_pos_day ;
	var same_lineage ;
run;


proc means data = data.analysis_final_2 maxdec=2;
	class test_pos_day ;
	var same_lineage ;
run;

proc means data = data.analysis_final_2 maxdec=2;
	class Vaccination_status_index ;
	var same_lineage ;
run;


proc means data = data.analysis_final_2 maxdec=2;
	class Vaccination_status ;
	var same_lineage ;
run;

*/

