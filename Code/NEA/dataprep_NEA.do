/*=============================================================================* 
* DATA PREPARATION - NEA
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 23-10-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	NEA OCCUPATION
		
* Short description of output:
*
* - Occupation codes based on NEA 2006-2022
*
* nidio_nea_occ_2006_2022: 
* Respondent's occupation (ISCO-08) as collected by NEA survey. Before 2011, NEA
* collected occupations only based on an idiosyncratic questionnaire item. 
* Starting from 2011, ISCO-08 are available (Unit: RIN-years).

* --------------------------------------------------------------------------- */
* 1. NEA OCCUPATION
* ---------------------------------------------------------------------------- *
	
	// 2005-2013
	* Load dataset
	import spss using "${nea0513}", case(lower) clear
	
	* Select variables
	keep rinpersoon jaar weeg beroep isco08_unitgroup
	
	* Remove years before 2006
	drop if jaar<2006
	
	* Simplify variable names
	rename jaar year
	rename beroep rin_neaocc
	rename isco08_unitgroup rin_ISCO08
	rename weeg rin_weight_NEA // proportional weight (relative to other respondents)
	
	* Variable order
	order rinpersoon, after(year)
	
	gsort year rinpersoon
	
	* Save temporary file
	save "${dNEA}/temp_occ_0613", replace
	
	
	// 2014-2022
	* Load dataset
	import spss using "${nea1422}", case(lower) clear
	
	* Select variables
	keep rinpersoon jaar weeg isco08_unitgroup
	
	* Simplify variable names
	rename jaar year
	rename isco08_unitgroup rin_ISCO08
	rename weeg rin_weight_NEA // proportional weight (relative to other respondents)
	
	* Create empty NEA occupation variable
	gen rin_neaocc = .
	
	* Variable order
	order rinpersoon, after(year)
	order rin_weight_NEA, after(rinpersoon) 
	order rin_neaocc, after(rin_ISCO08)
	
	
	// Append files to create yearly NEA occupation database 2006-2022
	append using "${dNEA}/temp_occ_0613"
	
	* Remove original occupation label
	lab drop labels651
	
	* Decode missing values in ISCO-08
	mvdecode rin_ISCO08, mv(9999)
	
	// Labeling
	labels_nidio, module(nea)
	
	gsort year rinpersoon
	
	save "${dNEA}/nidio_nea_occ_2006_2022", replace	
	
	*Delete temporary files
	erase "${dNEA}/temp_occ_0613.dta"
	
	clear