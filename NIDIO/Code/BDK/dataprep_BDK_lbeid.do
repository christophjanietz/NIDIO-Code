/*=============================================================================* 
* DATA PREPARATION - LONGITUDINAL BEID (BDK) 
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 28-08-2025
* ---------------------------------------------------------------------------- *

	INDEX: 
		0.  SETTINGS 
		1. 	PREPARE EDGELIST OF BEID CHANGES
		2.  INTERMEDIATE STEP IN R: IDENTIFY CLUSTER IDS
		3.  PREPARE DATASET WITH LONGITUDINAL BEID
		
* Short description of output:
*
* - Dataset with longitudinal BEID. Establishes an overarching ID for 
*   organizations with changing BEIDs over time based on switches registered
*   in the BDK.
*


* --------------------------------------------------------------------------- */
* 1. PREPARE EDGELIST OF BEID CHANGES
* ---------------------------------------------------------------------------- *

	foreach year of num 2007/2023 {
		
		import spss using "${bdk_kopp_`year'}", case(lower) clear
		
		rename (jaar beginbeid beid) (year alter ego)
		drop eindbeid
		order alter, after(ego)
		
		// Save temporary file
		save "${dBDK}/temp_kopp`year'_A", replace
		
	}
	*
	
	foreach year of num 2007/2023 {
		
		import spss using "${bdk_kopp_`year'}", case(lower) clear
		
		rename (jaar beid eindbeid) (year ego alter)
		drop beginbeid
		
		// Save temporary file
		save "${dBDK}/temp_kopp`year'_B", replace
		
	}
	*
	
	foreach year of num 2007/2022 {
		
		import spss using "${bdk_kopp_switch_`year'}", case(lower) clear
		
		rename (jaar_1 eindbeid_jaar_1 beginbeid_jaar_2) (year ego alter)
		drop jaar_2
		
		// Save temporary file
		save "${dBDK}/temp_switch`year'_A", replace
		
	}
	*
	
	foreach year of num 2007/2022 {
		
		import spss using "${bdk_kopp_switch_`year'}", case(lower) clear
		
		rename (jaar_1 eindbeid_jaar_1 beginbeid_jaar_2) (year alter ego)
		drop jaar_2
		order alter, after(ego)
		
		// Save temporary file
		save "${dBDK}/temp_switch`year'_B", replace
		
	}
	*
	
	use "${dBDK}/temp_kopp2023_A", replace
	 
	// Append files to create edgelist to identify 
	append using "${dBDK}/temp_kopp2007_A" "${dBDK}/temp_kopp2008_A" ///
		"${dBDK}/temp_kopp2009_A" "${dBDK}/temp_kopp2010_A" "${dBDK}/temp_kopp2011_A" ///
		"${dBDK}/temp_kopp2012_A" "${dBDK}/temp_kopp2013_A" "${dBDK}/temp_kopp2014_A" ///
		"${dBDK}/temp_kopp2015_A" "${dBDK}/temp_kopp2016_A" "${dBDK}/temp_kopp2017_A" ///
		"${dBDK}/temp_kopp2018_A" "${dBDK}/temp_kopp2019_A" "${dBDK}/temp_kopp2020_A" ///
		"${dBDK}/temp_kopp2021_A" "${dBDK}/temp_kopp2022_A" ///
		"${dBDK}/temp_kopp2009_B" "${dBDK}/temp_kopp2010_B" "${dBDK}/temp_kopp2011_B" ///
		"${dBDK}/temp_kopp2012_B" "${dBDK}/temp_kopp2013_B" "${dBDK}/temp_kopp2014_B" ///
		"${dBDK}/temp_kopp2015_B" "${dBDK}/temp_kopp2016_B" "${dBDK}/temp_kopp2017_B" ///
		"${dBDK}/temp_kopp2018_B" "${dBDK}/temp_kopp2019_B" "${dBDK}/temp_kopp2020_B" ///
		"${dBDK}/temp_kopp2021_B" "${dBDK}/temp_kopp2022_B" "${dBDK}/temp_kopp2023_B" ///
		"${dBDK}/temp_switch2007_A" "${dBDK}/temp_switch2008_A" ///
		"${dBDK}/temp_switch2009_A" "${dBDK}/temp_switch2010_A" "${dBDK}/temp_switch2011_A" ///
		"${dBDK}/temp_switch2012_A" "${dBDK}/temp_switch2013_A" "${dBDK}/temp_switch2014_A" ///
		"${dBDK}/temp_switch2015_A" "${dBDK}/temp_switch2016_A" "${dBDK}/temp_switch2017_A" ///
		"${dBDK}/temp_switch2018_A" "${dBDK}/temp_switch2019_A" "${dBDK}/temp_switch2020_A" ///
		"${dBDK}/temp_switch2021_A" "${dBDK}/temp_switch2022_A" ///
		"${dBDK}/temp_switch2007_B" "${dBDK}/temp_switch2008_B" ///
		"${dBDK}/temp_switch2009_B" "${dBDK}/temp_switch2010_B" "${dBDK}/temp_switch2011_B" ///
		"${dBDK}/temp_switch2012_B" "${dBDK}/temp_switch2013_B" "${dBDK}/temp_switch2014_B" ///
		"${dBDK}/temp_switch2015_B" "${dBDK}/temp_switch2016_B" "${dBDK}/temp_switch2017_B" ///
		"${dBDK}/temp_switch2018_B" "${dBDK}/temp_switch2019_B" "${dBDK}/temp_switch2020_B" ///
		"${dBDK}/temp_switch2021_B" "${dBDK}/temp_switch2022_B" 
		
	gsort year ego
	
	// Drop duplicates
	duplicates drop year ego alter, force
	
	save "H:/bdk_lbeid_2007_2023", replace
	
	*Delete temporary files
	foreach year of num 2007/2023 {
		erase "${dBDK}/temp_kopp`year'_A.dta"
		erase "${dBDK}/temp_kopp`year'_B.dta"
	}
	*
	foreach year of num 2007/2022 {
		erase "${dBDK}/temp_switch`year'_A.dta"
		erase "${dBDK}/temp_switch`year'_B.dta"
	}
	*
	
* --------------------------------------------------------------------------- */
* 2. INTERMEDIATE STEP IN R: IDENTIFY CLUSTER IDS
* ---------------------------------------------------------------------------- *
  
	rscript using "${sBDK}/lbeid.R", rpath(C:/Program Files/R/R-4.4.3/bin/Rscript.exe)

* --------------------------------------------------------------------------- */
* 3. PREPARE DATASET WITH LONGITUDINAL BEID
* ---------------------------------------------------------------------------- *

	use "H:/bdk_lbeid.dta", replace
	
	// Destring BEID
	destring beid, replace
	
	// Variable names
	lab var beid "BE ID"
	lab var lbeid "Longitudinal BE ID (based on ID switches registered in BDK)"
	lab var N "Number of unique BE IDs within longitudinal BE ID"
		
	// Save generated longitudinal IDs
	save "${dBDK}/nidio_bdk_lbeid", replace
	
	// Delete edgelist file
	erase "H:/bdk_lbeid_2007_2023.dta"
	erase "H:/bdk_lbeid.dta"
