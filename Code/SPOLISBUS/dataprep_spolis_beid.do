/*=============================================================================* 
* DATA PREPARATION - SPOLIS (BEID REGISTER)
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 23-10-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	SPOLIS BEID FILE
		
* Short description of output:
*
* - Longitudinal register of BE IDs with observations in (S)POLIS.
*
* nidio_spolis_be_register_2006_2023: 
* File that lists all BEs with at least one employee registered in the SPOLIS.

* --------------------------------------------------------------------------- */
* 1. SPOLIS BEID FILE
* ---------------------------------------------------------------------------- *

	foreach year of num 2006/2009 {
		
		use beid using "${polis`year'}", replace 
		
		gduplicates drop beid, force
		
		// Add calendar year
		gen year = `year'
		order year, before(beid)
		
		gsort year beid
	
		// Save temporary file
		tempfile temp_beid`year'
		save `temp_beid`year''
	}
	*
	
	foreach year of num 2010/2012 {
		
		use SBEID using "${spolis`year'}", replace
		
		rename SBEID beid
		
		gduplicates drop beid, force
		
		// Add calendar year
		gen year = `year'
		order year, before(beid)
		
		sort year beid
	
		// Save temporary file
		tempfile temp_beid`year'
		save `temp_beid`year''
	}
	*
	
	foreach year of num 2013/2023 {
		
		use sbeid using "${spolis`year'}", replace
		
		rename sbeid beid
		
		gduplicates drop beid, force
		
		// Add calendar year
		gen year = `year'
		order year, before(beid)
		
		gsort year beid
	
		// Save temporary file
		tempfile temp_beid`year'
		save `temp_beid`year''
	}
	*
	
	// Append files to create yearly OG register 2006-2023
	use "`temp_beid2023'", replace
	append using "`temp_beid2006'" "`temp_beid2007'" "`temp_beid2008'" ///
		"`temp_beid2009'" "`temp_beid2010'" "`temp_beid2011'" ///
		"`temp_beid2012'" "`temp_beid2013'" "`temp_beid2014'" ///
		"`temp_beid2015'" "`temp_beid2016'" "`temp_beid2017'" ///
		"`temp_beid2018'" "`temp_beid2019'" "`temp_beid2020'" ///
		"`temp_beid2021'" "`temp_beid2022'"
		
	gsort year beid
	
	// Change format to facilitate merge
	gen long beidx = real(beid)
	drop beid
	rename beidx beid
	
	drop if beid==.
	
	// Labels
	labels_nidio, module(spolis)
	
	save "${dSPOLIS}/nidio_spolis_beid_register_2006_2023", replace	
	
	clear
