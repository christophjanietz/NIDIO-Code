/*=============================================================================* 
* DATA PREPARATION - BDK
*==============================================================================*
 	Project: Beyond Boardroom / NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 08-12-2025
* ---------------------------------------------------------------------------- *

	INDEX: 
		0.  SETTINGS 
		1. 	BDK BE REGISTER
		
* Short description of output:
*
* - Demographic data of organizations 2007-2024
*
*

* --------------------------------------------------------------------------- */
* 1. BDK BE REGISTER
* ---------------------------------------------------------------------------- *

	foreach year of num 2007/2024 {
		
		import spss using "${bdk`year'}", case(lower) clear
		
		// Reduce variable set
		drop pabfactor werkzamepersonen werknemers
	
		// Rename variables
		rename jaar year
		order year, before(beid)
		
		rename datumontstaantoepassing_bdk _be_start_bdk
		rename datumopheffingtoepassing_bdk _be_end_bdk
		rename datumontstaantoepassing_abr _be_start_abr
		rename datumopheffingtoepassing_abr _be_end_abr
		rename oprichtingsdatumbedrijf _be_founding
		rename rechtsvorm be_rechtvormcode_bdk
		rename grootteklasse be_gksbs_bdk
		rename sbi be_SBI08_bdk
		rename zelfstandigmkb be_mkb
		rename buitenlands be_foreign
		rename uci be_uci
		rename oprichting be_birth
		rename opheffing be_death
		rename snellegroeier be_fastgrowth_bdk
		
		// Prepare date variables
		
		* Set open ends as missing as in ABR (now coded as fictious end date 2079-06-06)
		replace _be_end_bdk = . if _be_end_bdk==20790606
		replace _be_end_abr = . if _be_end_abr==20790606
		
		* Start / end observation BEID in BDK
		tostring _be_start_bdk _be_end_bdk, replace
	
		gen be_start_bdk = date(_be_start_bdk, "YMD") 
		format be_start_bdk %d
		gen be_end_bdk = date(_be_end_bdk, "YMD") 
		format be_end_bdk %d
		
		* Start / end observation BEID in ABR
		tostring _be_start_abr _be_end_abr, replace
	
		gen be_start_abr = date(_be_start_abr, "YMD") 
		format be_start_abr %d
		gen be_end_abr = date(_be_end_abr, "YMD") 
		format be_end_abr %d
		
		* Founding date
		tostring _be_founding, replace
	
		gen be_founding = date(_be_founding, "YMD") 
		format be_founding %d
	
		drop _be_start_bdk _be_end_bdk _be_start_abr _be_end_abr _be_founding
		order be_start_bdk-be_founding,after(beid)
		
		// GKSBS - Destring
		destring be_gksbs, replace
		
		// Legal type - Destring
		replace be_rechtvormcode_bdk="2" if be_rechtvormcode_bdk=="00x"
		destring be_rechtvormcode_bdk, replace
		
		* Remove old labels
		lab drop labels3
	
		// Save temporary file
		save "${dBDK}/temp_bdk`year'", replace
	}
	*
	
	// Append files to create yearly BDK register 2007-2024
	append using "${dBDK}/temp_bdk2007" "${dBDK}/temp_bdk2008" ///
		"${dBDK}/temp_bdk2009" "${dBDK}/temp_bdk2010" "${dBDK}/temp_bdk2011" ///
		"${dBDK}/temp_bdk2012" "${dBDK}/temp_bdk2013" "${dBDK}/temp_bdk2014" ///
		"${dBDK}/temp_bdk2015" "${dBDK}/temp_bdk2016" "${dBDK}/temp_bdk2017" ///
		"${dBDK}/temp_bdk2018" "${dBDK}/temp_bdk2019" "${dBDK}/temp_bdk2020" ///
		"${dBDK}/temp_bdk2021" "${dBDK}/temp_bdk2022" "${dBDK}/temp_bdk2023"
		
	// Labeling
	labels_nidio, module(bdk)
		
	gsort year beid
	
	save "${dBDK}/nidio_bdk_be_2007_2024", replace	
	
	*Delete temporary files
	foreach year of num 2007/2024 {
		erase "${dBDK}/temp_bdk`year'.dta"
	}
	*
