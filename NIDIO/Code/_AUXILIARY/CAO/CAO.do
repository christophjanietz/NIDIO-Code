/*=============================================================================* 
* DATA PREPARATION - CAO
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 02-12-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	Bedrijfstak-CAOs  
		
* Short description of output:
*
* - Saves Bedrijfstak-CAO code crosswalk as dta. file.
*

* --------------------------------------------------------------------------- */
* 1. Bedrijfstak-CAOs 
* ---------------------------------------------------------------------------- *

	import spss using "${CAO}", case(lower) clear
	
	sort scao_crypt
	
	save "${sdir}/_AUXILIARY/CAO/CAO.dta", replace
	global BedrijfstakCAO "${sdir}/_AUXILIARY/CAO/CAO.dta"
	
	clear
	