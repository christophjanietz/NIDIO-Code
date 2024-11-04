/*=============================================================================* 
* DATA PREPARATION - NFO
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 23-10-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1.  APPENDING NFO FINANCIAL DATA
		2.  OG FINANCIAL DATA LONGITUDINAL FILE
		
* Short description of output:
*
* - Longitudinal financial data files
*
* nidio_nfo_finances_2006_2022: 
* Financial data including fully appended source files.
*
* nidio_nfo_og_2006_2022: 
* Unique yearly OG observations with aggregated financial data between 2006 and 
* 2022 (Unit: OG-years).

* --------------------------------------------------------------------------- */
* 1. APPENDING NFO FINANCIAL DATA
* ---------------------------------------------------------------------------- *
	
	foreach year of num 2006/2022 {
		
		import spss using "${nfo`year'}", case(lower) clear
	
		// Consistent lower case of variable names
		rename _all, lower
		
		// Harmonize variable names
		rename (vep_finr_crypt ond_id bron b37 r01 r02 r04 r05_r06 r07 r20) ///
			(finr ogid source assets revenue ccost lcost cdeprec profit result)
		
		// Add calendar year
		gen year = `year'
		order year, before(finr)
		
		// Reduce number of variables
		keep year finr ogid source oph assets revenue ccost lcost cdeprec profit ///
			result
			
		save "${dNFO}/temp_nfo`year'", replace
	}
	*
	
	// Append files to create yearly financial data file 2006-2022
	append using "${dNFO}/temp_nfo2006" "${dNFO}/temp_nfo2007" ///
		"${dNFO}/temp_nfo2008" "${dNFO}/temp_nfo2009" "${dNFO}/temp_nfo2010" ///
		"${dNFO}/temp_nfo2011" "${dNFO}/temp_nfo2012" "${dNFO}/temp_nfo2013" ///
		"${dNFO}/temp_nfo2014" "${dNFO}/temp_nfo2015" "${dNFO}/temp_nfo2016" ///
		"${dNFO}/temp_nfo2017" "${dNFO}/temp_nfo2018" "${dNFO}/temp_nfo2019" ///
		"${dNFO}/temp_nfo2020" "${dNFO}/temp_nfo2021"
	
	// Labeling
	labels_nidio, module(nfo)
		
	gsort year ogid finr
	
	save "${dNFO}/nidio_nfo_finances_2006_2022", replace	
	
	// Erase stored temp files
	foreach year of num 2006/2022 {
		erase "${dNFO}/temp_nfo`year'.dta"
	}
	*
	
* --------------------------------------------------------------------------- */
* 2. OG FINANCIAL DATA LONGITUDINAL FILE
* ---------------------------------------------------------------------------- *

********************************************************************************
* Preparing NFO with available OGID
********************************************************************************	
	
	use "${dNFO}/nidio_nfo_finances_2006_2022", replace
	
	// Data with available OGID
	keep if ogid!=.
	
	// Sum financial data in case of multiple exisiting FINR within OG-year
	gegen og_oph = mean(oph), by(year ogid)
	foreach var of varlist assets-result {
		gegen og_`var' = total(`var'), by(year ogid)
	}
	
	drop finr oph assets revenue ccost lcost cdeprec profit result
	
	// Reduce dataset to one OG observation
	gduplicates drop year ogid, force
	
	gsort year ogid
	
	save "${dNFO}/og_finances_2006_2022", replace
	
********************************************************************************
* Preparing NFO with missing OGID
********************************************************************************

	use "${dNFO}/nidio_nfo_finances_2006_2022", replace
	
	// Data with missing OGID
	keep if ogid==.
	
	// Drop if FINR is also missing (non-linkable data)
	drop if finr==""
	
	// Data error: several FINR appear two times (with same values) in 2006
	gduplicates drop year finr, force
	
	// Recast finr as str32 to enable merging
	capture recast str finr
	
	drop ogid
	gsort year finr
	
	save "${dNFO}/finr_finances_2006_2022", replace
	
	// Link to OGID
	use "${dABR}/nidio_abr_ogkvk_register_2006_2023", replace
	drop if year==2023
	
	gsort year finr
	
	merge m:1 year finr using "${dNFO}/finr_finances_2006_2022", keep(match) ///
		keepusing(source oph revenue assets ccost lcost cdeprec profit result) ///
		nogen
	// --> 13.25% of all FINR are matched
		
	// --> In several cases, FINR is associated with multiple OG IDs
	//	   In most cases, these OGs are restructuring during the same calendar year.
		
	// Sum financial data in case of multiple FINR within OG-year
	gegen og_oph = mean(oph), by(year ogid)
	foreach var of varlist assets-result {
		gegen og_`var' = total(`var'), by(year ogid)
	}
	
	// Reduce variable set
	keep year ogid source og_oph og_assets og_revenue og_ccost og_lcost ///
		og_cdeprec og_profit og_result
	
	// Reduce dataset to one OG observation
	gduplicates drop year ogid, force
	
	gsort year ogid
	
	save "${dNFO}/finr_finances_2006_2022", replace

	
********************************************************************************
* Append both datasets
********************************************************************************

	append using "${dNFO}/og_finances_2006_2022"
	
	gsort year ogid
	
	// Sum financial data in case of multiple FINR within OG-year
	rename (og_oph og_assets og_revenue og_ccost og_lcost og_cdeprec og_profit ///
		og_result) (oph assets revenue ccost lcost cdeprec profit result)
	gegen og_oph = mean(oph), by(year ogid)
	foreach var of varlist assets-result {
		gegen og_`var' = total(`var'), by(year ogid)
	}
	
	drop oph assets revenue lcost ccost cdeprec profit result
	
	// Reduce dataset to one OG observation
	gduplicates drop year ogid, force
	
	// Labeling
	labels_nidio, module(nfo)
	
	gsort year ogid
	
	save "${dNFO}/nidio_nfo_og_2006_2022", replace
	
	erase "${dNFO}/og_finances_2006_2022.dta"
	erase "${dNFO}/finr_finances_2006_2022.dta"
	
	clear
