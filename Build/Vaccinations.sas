*******************************
	Vaccination - START
********************************;

/*
proc import
	datafile 	= "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Delta Transmissiblity\Data\vaccine_maalgrupper_211008.csv"
	out 		= vaccine
	dbms		= csv
	replace ;
	delimiter 	= ";" ;
	getnames 	= yes ;
	guessingrows = 10000 ;
run; 
*/


proc import
	datafile 	= "F:\Projekter\FSEID00004942\FrederikPlesnerLyngse\Delta Transmissiblity\Data\vaccine_maalgrupper_211112.csv"
	out 		= vaccine
	dbms		= csv
	replace ;
	delimiter 	= ";" ;
	getnames 	= yes ;
	guessingrows = 10000 ;
run; 


data DATA.vaccine ;
	set vaccine ;
		rename CPR_ENCRYPTED = pnr ;
run ;

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	Vaccination - END
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;

data data.vaccine_2 ;
	set DATA.vaccine ;
		keep 
			pnr
			second_VaccineName
			first_VaccineName
			first_VaccineDate
			second_VaccineDate
			revacc1_VaccineDate
			revacc1_VaccineName
			;
run;

data DATA.vaccine_2 ;
	set data.vaccine_2;

		* Astra ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca" ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;
		if first_VaccineName = "AstraZeneca Covid-19 vaccine" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "AstraZeneca Covid-19 vaccine" then Full_Vaccine_Name = "AstraZeneca_and_mRNA" ;		
		
		*Pfizer ;
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then Full_Vaccine_Name = "Pfizer" ;
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "Comirnaty Covid-19 Vaccine" then Full_Vaccine_Name = "Pfizer" ;
		* Moderna ;
		if first_VaccineName = "Moderna Covid-19 Vaccine" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "Moderna" ;
		if first_VaccineName = "Pfizer BioNTech Covid-19 vacc" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "Moderna" ;
		if first_VaccineName = "Comirnaty Covid-19 Vaccine" and second_VaccineName = "Moderna Covid-19 Vaccine" then Full_Vaccine_Name = "Moderna" ;

		* J&J ;
		if first_VaccineName = "Janssen COVID-19 vaccine"  then Full_Vaccine_Name = "Janssen" ;
		
		


		if first_VaccineName = "Janssen COVID-19 vaccine" then fully_vaccinated_Date = second_VaccineDate + 14 ;
		if second_VaccineName = "Pfizer BioNTech Covid-19 vacc" then fully_vaccinated_Date = second_VaccineDate + 7 ;
		if second_VaccineName = "Moderna Covid-19 Vaccine" then fully_vaccinated_Date = second_VaccineDate + 14 ;
		if second_VaccineName = "Comirnaty Covid-19 Vaccine" then fully_vaccinated_Date = second_VaccineDate + 14 ;
		if second_VaccineName = "AstraZeneca Covid-19 vaccine" then fully_vaccinated_Date = second_VaccineDate + 15 ;
		if first_VaccineDate ne . and second_VaccineDate = . then fully_vaccinated_Date = first_VaccineDate +2400 ;
			format fully_vaccinated_Date DATE9. ;			
run;

