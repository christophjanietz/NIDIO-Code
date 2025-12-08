/*=============================================================================* 
* DATA PREPARATION - HOOGSTEOPLTAB
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 08-12-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1.  PREPARE OPLNR FILE
		2. 	APPENDING EDUCATION FILES
		
* Short description of output:
*
* - Longitudinal education file.
*
* nidio_opl_rin_2006_2024: 
* description (Unit: RIN-years).
*
	
* --------------------------------------------------------------------------- */
* 1. PREPARE OPLNR FILE
* ---------------------------------------------------------------------------- *

	use "${OPLNR}", replace

	foreach v of varlist _all {
		rename `v' , upper
	}
	*

	drop CTO
	rename CTO2021V cto

	merge n:n cto using "${CTO}", keep(match) nogen

	rename (OPLNR ISCED2011LevelHB ISCEDF2013RICHTINGNLSOI2021V) ///
		(oplnrhb ISCED2011 ISCED2013R4)
	destring ISCED2011, replace force
	replace ISCED2011 = . if ISCED2011==9

	keep oplnr ISCED2011 ISCED2013R4

	save "${sdir}/_AUXILIARY/EDU/OPLEIDINGSNRREF_nidio.dta" , replace

* --------------------------------------------------------------------------- */
* 2. APPENDING EDUCATION FILES
* ---------------------------------------------------------------------------- *

	foreach year of num 2006/2024 {
		use "${opl`year'}", replace
	
		// Consistent lower case of variable names
		rename _all, lower
	
		*Select only persoons registered in GBA
		keep if rinpersoons=="R"
		drop rinpersoons
	
		*Harmonize variable names 
		capture rename gewichthoogsteopl edu_wgt
		
		// Add calendar year
		gen year = `year'
		order year, before(rinpersoon)
		
		// Simplify variable names 
		if year>=2013 & year<=2024 {
			rename (oplnivsoi2016agg4hbmetnirwo oplnivsoi2016agg4hgmetnirwo) ///
			(rin_edu_soi2016 rin_edu_soi2016_hg)
		}
		if year>=2016 & year<=2024 {
			rename (richtdetailiscedf2013hbmetnirwo richtdetailiscedf2013hgmetnirwo) ///
			(rin_edufield_soi2016 rin_edufield_soi2016_hg)
		}
		if year>=2019 & year<=2024 {
			rename (oplnivsoi2021agg4hbmetnirwo oplnivsoi2021agg4hgmetnirwo ///
			richtsoi2021scedf2013hbnirwo richtsoi2021scedf2013hgnirwo) ///
			(rin_edu_soi2021 rin_edu_soi2021_hg rin_edufield_soi2021 ///
			rin_edufield_soi2021_hg)
		}
		*
		
		// Merge ISCED2011 via OPLNR
		merge m:1 oplnrhb using "${sdir}/_AUXILIARY/EDU/OPLEIDINGSNRREF_nidio.dta", ///
			keep(master match) nogen keepusing(ISCED2011)
		rename ISCED2011 rin_edu_isced2011
			
		// Drop education code source variables
		capture drop oplnrhb oplnrhg bronoplarchiefhb bronoplarchiefhg rgebb
		capture drop oplnrhb oplnrhg
		
		// Drop 'highest followed education' variables
		capture drop rin_edu_soi2021_hg 
		capture drop rin_edufield_soi2021_hg
		capture drop rin_edu_soi2016_hg 
		capture drop rin_edufield_soi2016_hg
		
		// Destring SOI levels
		capture destring rin_edu_soi2016, replace
		capture destring rin_edu_soi2021, replace
		
		sort rinpersoon
		
		// Save temporary file
		tempfile temp_opl`year'
		save `temp_opl`year''
	}
	*
	
	// Append files to create yearly OG register 2006-2024
	use "`temp_opl2006'", replace
	append using "`temp_opl2007'" "`temp_opl2008'" "`temp_opl2009'" ///
		"`temp_opl2010'" "`temp_opl2011'" "`temp_opl2012'" ///
		"`temp_opl2013'" "`temp_opl2014'" "`temp_opl2015'" ///
		"`temp_opl2016'" "`temp_opl2017'" "`temp_opl2018'" ///
		"`temp_opl2019'" "`temp_opl2020'" "`temp_opl2021'" ///
		"`temp_opl2022'" "`temp_opl2023'" "`temp_opl2024'"
	
	// Labelling
	labels_nidio, module(opl)
		
	save "${dOPL}/nidio_opl_rin_2006_2024", replace
	
	clear
