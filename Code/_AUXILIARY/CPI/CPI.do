/*=============================================================================* 
* DATA PREPARATION - CPI
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 27-09-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	CPI datasets
		
* Short description of output:
*
* - Constructs CPI dataset following official CBS statistics
*
* CPI:
* CPI during the reference year.
* CPI_month:
* CPI in the month of September during the reference year. 

* --------------------------------------------------------------------------- */
* 1. CPI DATASETS
* ---------------------------------------------------------------------------- *

	// CPI

	set obs 18
	gen year=.
	gen CPI=.
	
	* Year
	local j = 2006
	forvalues i = 1/18 {
		replace year = `j' in `i'
		local ++j
	}
	*
	
	* CPI
	replace CPI = 0.8582 if year==2006
	replace CPI = 0.872 if year==2007
	replace CPI = 0.8937 if year==2008
	replace CPI = 0.9044 if year==2009
	replace CPI = 0.9159 if year==2010
	replace CPI = 0.9373 if year==2011
	replace CPI = 0.9604 if year==2012
	replace CPI = 0.9844 if year==2013
	replace CPI = 0.994 if year==2014
	replace CPI = 1 if year==2015
	replace CPI = 1.0032 if year==2016
	replace CPI = 1.017 if year==2017
	replace CPI = 1.0344 if year==2018
	replace CPI = 1.0616 if year==2019
	replace CPI = 1.0751 if year==2020
	replace CPI = 1.1039 if year==2021
	replace CPI = 1.2143 if year==2022
	replace CPI = 1.2609 if year==2023
	
	save "${sdir}/_AUXILIARY/CPI/CPI.dta", replace
	clear
	
	
	// CPI_month

	set obs 18
	gen year=.
	gen CPI=.
	
	* Year
	local j = 2006
	forvalues i = 1/18 {
		replace year = `j' in `i'
		local ++j
	}
	*
	
	* CPI
	replace CPI = 0.8646 if year==2006
	replace CPI = 0.8759 if year==2007
	replace CPI = 0.9028 if year==2008
	replace CPI = 0.9062 if year==2009
	replace CPI = 0.9205 if year==2010
	replace CPI = 0.9453 if year==2011
	replace CPI = 0.9672 if year==2012
	replace CPI = 0.9908 if year==2013
	replace CPI = 0.9996 if year==2014
	replace CPI = 1.005 if year==2015
	replace CPI = 1.0057 if year==2016
	replace CPI = 1.0203 if year==2017
	replace CPI = 1.0395 if year==2018
	replace CPI = 1.067 if year==2019
	replace CPI = 1.0788 if year==2020
	replace CPI = 1.1079 if year==2021
	replace CPI = 1.2689 if year==2022
	replace CPI = 1.2716 if year==2023
	
	save "${sdir}/_AUXILIARY/CPI/CPI_month.dta", replace
	clear
	