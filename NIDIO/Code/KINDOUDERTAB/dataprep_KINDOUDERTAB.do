/*=============================================================================* 
* DATA PREPARATION - KINDOUDERTAB
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 25-08-2025
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	PARENT REGISTER
		
* Short description of output:
*
* nidio_kindouder_parents_2023:
* - Register of parents up until 2023 (Unit: RIN).
*

* --------------------------------------------------------------------------- */
* 1. PARENT REGISTER
* ---------------------------------------------------------------------------- *
	
	foreach x in ma pa {
		import spss using "${kindouder2024}", case(lower) clear
		
		// Second local holding opposite code
		if "`x'"=="ma" {
			local y = "pa" 
		}
		else {
			local y = "ma" 
		}
		
		// Select on registration on GBR (code R)
		keep if rinpersoons=="R"
		*Mothers / Fathers (Dropping non-registered mothers and fathers)
		keep if rinpersoons`x'=="R"
		
		// Select variable subset 
		keep rinpersoon rinpersoon`x' rinpersoon`y' xkoppelnummer 
		
		capture rename rinpersoon`y' rinalterp
		capture order rinpersoon rinpersoon`x' rinalterp, before(xkoppelnummer)
	
		// Merge birth date of child 
		gsort rinpersoon
		merge 1:1 rinpersoon using "${dGBA}/nidio_gba_rin_2023", keep(master match) nogen ///
			keepusing(rin_birthy rin_birthm)
		
		// Harmonize variable names
		rename (rinpersoon rinpersoon`x' rin_birthy rin_birthm xkoppelnummer) ///
			(rinchild rinpersoon child_birthy child_birthm childparent_link)
	
		// Create mother / father identifier
		gen rin_mfchild = "`x'"
		
		// Save file
		save "${dKIND}/kindouder_`x'_2023", replace
	}
	*
	
	// Append mother and father files 
	append using "${dKIND}/kindouder_ma_2023" 
	
	// Create variable holding number of registered children in most recent year
	bys rinpersoon: gen rin_nrchildren= _N
	
	// Transform mf_child
	replace rin_mfchild="1" if rin_mfchild=="ma" 
	replace rin_mfchild="2" if rin_mfchild=="pa"
	destring rin_mfchild, replace
	
	order rinpersoon rin_nrchildren rin_mfchild rinchild child_birthy child_birthm ///
		childparent_link rinalterp
		
	// Restrict to births until 2023
	drop if child_birthy>2023
		
	// Labeling
	labels_nidio, module(kind)
	
	gsort rinpersoon child_birthy child_birthm rinchild
	
	save "${dKIND}/nidio_kindouder_parents_2023", replace
	
	erase "${dKIND}/kindouder_ma_2023.dta"
	erase "${dKIND}/kindouder_pa_2023.dta"
	
	clear
