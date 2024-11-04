/*=============================================================================* 
* PROGRAM - GENHWAGE
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 19-02-2024
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - GENHWAGE computes hourly wage measures by using SPOLIS variables as input.
*
* Options:
* - dataformat: Specify data format of used SPOLIS file (required).
*	'month'={SPOLIS month format}; 'year'={SPOLIS year format}
*
* - generate: Specify name of computed variable (required).
*
* - concept (default 'basis'): Numerator of the hourly wage measure. 
*   Choice is between various wage concepts:
* 		'basis': {sbasisloon};
* 		'extra': {sbasisloon + sbijzonderebeloning};
*		'bonus': {sbasisloon + sincidentsal}
* 
* - denom (default 'basis'): Denominator of the hourly wage measure. 
* 	'basis'={sbasisuuren}; 'regular'={sregulierenuuren}
*
* - overwork (default 0): Adds overwork compensation and hours on request.
* 	0={no}; 1={yes}
*
* - real (default 0): Calculates inflation-adjusted wages on request.
* 	0={no}; 1={yes}
* 
* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *


program define genhwage
	syntax , DATAformat(string) GENerate(string) [concept(string) denom(string) ///
		overwork(integer 0) real(integer 0)]
	
	* Header
		display as txt "GENHWAGE"
		display as txt "--------------------------------------------------------"
		
	* Abort program if variable specified in generate() is already defined
		quietly capture confirm variable `generate' real_`generate', exact
		if !_rc {
			display as error "Variable `generate' or real_`generate' already defined"
			exit(0)
		}
		*
		
	* Calculate hourly wage numerator based on chosen concept
		if `"`concept'"'=="extra" {
			quietly gen _numerator = sbasisloon_`dataformat' + sbijzonderebeloning_`dataformat'
			display as txt "Chosen numerator = Basis compensation + all extras (incl. bonus)"
		}
		else if `"`concept'"'=="bonus" {
			quietly gen _numerator = sbasisloon_`dataformat' + sincidentsal_`dataformat'
			display as txt "Chosen numerator = Basis compensation + bonus"
		}
		else {
			quietly gen _numerator = sbasisloon_`dataformat'
			display as txt "Chosen numerator = Basis compensation"
		}
		*
		
	* Define hourly wage denominator based on specified working time measure
		if `"`denom'"'=="regular" {
			quietly gen _denominator = sreguliereuren_`dataformat'
			display as txt "Chosen denominator = Regular hours (excl. holidays)"
		}
		else {
			quietly gen _denominator = sbasisuren_`dataformat'
			display as txt "Chosen denominator = Basis hours"
		}
		*
		
	* Add overwork compensation and hours, if requested
		if `overwork'==1 {
			quietly replace _numerator = _numerator+slnowrk_`dataformat'
			quietly replace _denominator = _denominator+soverwerkuren_`dataformat'
			display as txt "Overwork compensation and hours included."
		}
		else {
			display as txt "Overwork compensation and hours excluded."
		}
		
	* Calculate hourly wage
		quietly gen `generate' = _numerator/_denominator
		lab var `generate' "Hourly wage measure"
		quietly drop _numerator _denominator 
		
	* Replace with real hourly wage, if requested
		if `real'==1 {
			if `"`dataformat'"'=="year" {
				quietly sort year 
				quietly merge m:1 year using "${CPI}", nogen keep(master match) ///
					keepusing(CPI)
				quietly gen real_`generate' = `generate'/CPI
				lab var real_`generate' "Real hourly wage measure"
				drop `generate' CPI
				display as txt "Inflation-adjusted hourly wage (using calendar year CPI)."
				display as txt "--------------------------------------------------------"
				display as res "Variable real_`generate' saved."
			}
			else if `"`dataformat'"'=="month" {
				quietly sort year 
				quietly merge m:1 year using "${CPI_month}", nogen keep(master match) ///
					keepusing(CPI)
				quietly gen real_`generate' = `generate'/CPI
				lab var real_`generate' "Real hourly wage measure"
				drop `generate' CPI
				display as txt "Inflation-adjusted hourly wage (using September CPI)."
				display as txt "--------------------------------------------------------"
				display as res "Variable real_`generate' saved."
			}
		}
		else {
			display as txt "--------------------------------------------------------"
			display as res "Variable `generate' saved."
		}	

end
				