/*=============================================================================* 
* DATA PREPARATION - EBB
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 08-12-2025
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	EBB OCCUPATION
		
* Short description of output:
*
* - Occupation codes based on EBB 2006-2024 (Unit: RIN-years)
*
* nidio_ebb_occ_2006_2024: 
* Respondent's occupation (ISCO-08) as collected by EBB survey.

* --------------------------------------------------------------------------- */
* 1. EBB OCCUPATION
* ---------------------------------------------------------------------------- *

	foreach year of num 2006/2024 {
		
		import spss using "${ebbnw`year'}", case(lower) clear
	
		* Select relevant variables
		keep rinpersoons rinpersoon sleutelebb ebbstkpeilingnummer ///
			ebbgewjaargewichta ebbpb1poswrkflexzzp1 ebbtw1isco2008v
		
		* Select on R in rinpersoons
		keep if rinpersoons=="R"
		drop rinpersoons
	
		* Remove inactive and unemployed respondents
		drop if ebbtw1isco2008v=="9997"
	
		* Harmonize & simplify variable names
		rename ebbstkpeilingnummer rin_svynr_EBB
		rename ebbgewjaargewichta rin_weight_EBB
		rename ebbpb1poswrkflexzzp1 rin_position_EBB
		rename ebbtw1isco2008v rin_ISCO08
	
		* Extract year from survey date
		gen rin_svydate_EBB = date(sleutelebb, "YMD") 
		format rin_svydate_EBB %d
		gen year = year(rin_svydate_EBB)
		drop sleutelebb
		drop if year<=2005 | year>=2025
	
		*Destring svynr & ISCO-08
		destring rin_svynr_EBB rin_position_EBB rin_ISCO08, replace
	
		* Decode missing values in ISCO-08
		mvdecode rin_position_EBB , mv(9)
		mvdecode rin_ISCO08, mv(9998 9999)
	
		* Variable order
		order year rinpersoon rin_svydate_EBB rin_svynr rin_weight_EBB ///
			rin_position_EBB rin_ISCO08
		
		// Save temporary file
		save "${dEBB}/temp_ebbnw`year'", replace
	}
	*
	
	// Append files to create yearly EBB occupation database 2006-2024
	append using "${dEBB}/temp_ebbnw2006" "${dEBB}/temp_ebbnw2007" ///
		"${dEBB}/temp_ebbnw2008" "${dEBB}/temp_ebbnw2009" ///
		"${dEBB}/temp_ebbnw2010" "${dEBB}/temp_ebbnw2011" ///
		"${dEBB}/temp_ebbnw2012" "${dEBB}/temp_ebbnw2013" ///
		"${dEBB}/temp_ebbnw2014" "${dEBB}/temp_ebbnw2015" ///
		"${dEBB}/temp_ebbnw2016" "${dEBB}/temp_ebbnw2017" ///
		"${dEBB}/temp_ebbnw2018" "${dEBB}/temp_ebbnw2019" ///
		"${dEBB}/temp_ebbnw2020" "${dEBB}/temp_ebbnw2021" ///
		"${dEBB}/temp_ebbnw2022" "${dEBB}/temp_ebbnw2023"
		
	// Labeling
	labels_nidio, module(ebb)
	
	gsort year rinpersoon
		
	save "${dEBB}/nidio_ebb_occ_2006_2024", replace
	
	*Delete temporary files
	foreach year of num 2006/2024 {
		erase "${dEBB}/temp_ebbnw`year'.dta"
	}
	*
	
	clear
	