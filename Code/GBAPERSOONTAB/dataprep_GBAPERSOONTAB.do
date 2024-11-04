/*=============================================================================* 
* DATA PREPARATION - GBAPERSOONTAB
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 30-10-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	GBA DEMOGRAPHIC FILE
		
* Short description of output:
*
* nidio_gba_rin_2023:
* - Demographic characteristics of individuals who are registered in the GBR.
*	(Unit: RIN).
*

* --------------------------------------------------------------------------- */
* 1. GBA DEMOGRAPHIC FILE
* ---------------------------------------------------------------------------- *

	import spss using "${GBAPERSOON2023}", case(lower) clear
	
	//Select only persoons registered in GBA
	keep if rinpersoons=="R"
	drop rinpersoons
	
	// Keep all variables excluding censored birthdays
	keep rinpersoon gbageboorteland gbageslacht gbageboortelandmoeder ///
	gbageboortelandvader gbaaantaloudersbuitenland gbaherkomstgroepering ///
	gbageneratie gbageboortejaar gbageboortemaand gbageslachtmoeder ///
	gbageslachtvader gbageboortejaarmoeder gbageboortemaandmoeder ///
	gbageboortejaarvader gbageboortemaandvader gbaimputatiecode ///
	gbaherkomstland gbageboortelandnl
	
	// Simplify variable names
	rename (gbageboorteland gbageslacht gbageboortelandmoeder gbageboortelandvader ///
	gbaaantaloudersbuitenland gbaherkomstgroepering gbageneratie gbageboortejaar ///
	gbageboortemaand gbageslachtmoeder gbageslachtvader gbageboortejaarmoeder ///
	gbageboortemaandmoeder gbageboortejaarvader gbageboortemaandvader ///
	gbaimputatiecode gbaherkomstland gbageboortelandnl) (rin_cntbirth rin_sex ///
	rin_cntbirth_m rin_cntbirth_f rin_nrprntsfrgnbrn rin_miggrp rin_miggen ///
	rin_birthy rin_birthm rin_sex_m rin_sex_f rin_birthy_m rin_birthm_m ///
	rin_birthy_f rin_birthm_f rin_miggrp_imputed rin_miggrp_cbs rin_nlbrn)
	
	// World region
	* Merge world region classification from utility file
	rename rin_miggrp_cbs land
	gsort land
	merge m:1 land using "${CNTRY}", keepusing(WERELDDEEL2 landtype) ///
		keep(master match) nogen
	* Merge world region classification (NIDIO definition))
	do "${sdir}/_AUXILIARY/Country_codes/wrldrgn_nidio"
	rename (land WERELDDEEL2 wregion landtype) ///
		(rin_miggrp_cbs rin_wrldrgn rin_wrldrgn_nidio rin_wstrn)
	order rin_wrldrgn rin_wrldrgn_nidio rin_wstrn, after(rin_miggrp_cbs)
	
	// Harmonize variable values
	* Country of birth
	foreach var of varlist rin_cntbirth* rin_miggrp rin_miggrp_cbs {
		destring `var', replace
		mvdecode `var', mv(0) 
	}
	
	* Sex
	foreach var of varlist rin_sex* {
		replace `var' = "" if `var'=="-"
		destring `var', replace
		mvdecode `var', mv(0) 
	}
	
	* Birth year & birth month
	foreach var of varlist rin_birth* {
		replace `var' = "" if `var'=="--" | `var'=="----"
		destring `var', replace
		mvdecode `var', mv(0) 
	}
	
	* Additional migration variables 
	foreach var of varlist rin_nrprntsfrgnbrn rin_miggen rin_miggrp_imputed ///
	rin_nlbrn {
		destring `var', replace 
	}
	
	* World region
	replace rin_wrldrgn = "" if rin_wrldrgn=="-"
	destring rin_wrldrgn, replace
	
	replace rin_wstrn = "" if rin_wstrn=="-"
	destring rin_wstrn, replace
	
	// Labeling
	labels_nidio, module(gba)
	
	gsort rinpersoon
	
	// Save
	save "${dGBA}/nidio_gba_rin_2023", replace
	
	clear
	