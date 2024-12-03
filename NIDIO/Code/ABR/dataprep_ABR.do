/*=============================================================================* 
* DATA PREPARATION - ABR
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 23-10-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	OG LONGITUDINAL FILE
		2.  OG-BE LONGITUDINAL FILE
		3.  OG-KVK LONGITUDINAL FILE
		4.  OG SIZE FILE
		
* Short description of output:
*
* - Longitudinal organization files (Unit: OG-years)
*
* nidio_abr_og_register_2006_2023: 
* Unique yearly OG observations (OG-years) between 2006 and 2023.
*
* nidio_abr_ogbe_register_2006_2023:  
* BE units attached to OG-years between between 2006 and 2023.
* Includes additional variables such as size, industry, and municipality measured
* at the BE level.
*
* nidio_abr_ogkvk_register_2006_2023: 
* KVK IDs & FINRs attached to OG-years (with at least one SPOLIS observations) 
* between between 2006 and 2023.
*
* nidio_abr_og_size_2006_2023: 
* Number of employees per OG-year between 2006 and 2023.

* --------------------------------------------------------------------------- */
* 1. OG LONGITUDINAL FILE
* ---------------------------------------------------------------------------- *

	foreach year of num 2006/2023 {
		
		import spss using "${abr_OG`year'}", case(lower) clear
			
		// Harmonize variable names (2021 & 2022)
		capture rename (ogidentificatie ogsectorcodegecoordineerd ogmaandbegin ///
			ogmaandeinde) (rog_identificatie rog_sectorcodegecoordineerd ///
			rog_datumontstaantoepassing rog_datumopheffingtoepassing)
	
		// Rename OG ID according to convention
		rename rog_identificatie ogid 
	
		// Add calendar year
		gen year = `year'
		order year, before(ogid)
	
		// Sector code - Harmonization & Simplification
		*Old classification
		if year<=2016 {
		
			rename rog_sectorcodegeco* og_sectorcode 
			gen og_sector = substr(og_sectorcode,1,2)
			destring og_sector, replace
	
			*Between 2006 to 2009: Non-governmental non-profit organizations 
			* received sector code 11023 instead of 15000
			replace og_sector = 15 if og_sectorcode=="11023"
	
			gen og_ownership = substr(og_sectorcode,4,1)
			destring og_ownership, replace
			replace og_ownership=. if og_sector!=11 & og_sector!=12
			recode og_ownership (4=0)
		}
		* New classification	
		else {
			rename rog_sectorcodegeco* og_sectorcode
			gen og_sector = substr(og_sectorcode,1,2)
			destring og_sector, replace
		
			gen og_ownership = substr(og_sectorcode,5,1)
			destring og_ownership, replace
			replace og_ownership=. if og_sector!=11 & og_sector!=12	
		}
	
		// Start / end observation OG
		tostring rog_datumontstaantoepassing rog_datumopheffingtoepassing, replace
	
		gen og_start = date(rog_datumontstaantoepassing, "YMD") 
		format og_start %d
		gen og_end = date(rog_datumopheffingtoepassing, "YMD") 
		format og_end %d
	
		drop rog_datumontstaantoepassing rog_datumopheffingtoepassing
		
		// Save temporary file
		save "${dABR}/temp_og`year'", replace
	}
	*
	
	// Append files to create yearly OG register 2006-2023
	append using "${dABR}/temp_og2006" "${dABR}/temp_og2007" "${dABR}/temp_og2008" ///
		"${dABR}/temp_og2009" "${dABR}/temp_og2010" "${dABR}/temp_og2011" ///
		"${dABR}/temp_og2012" "${dABR}/temp_og2013" "${dABR}/temp_og2014" ///
		"${dABR}/temp_og2015" "${dABR}/temp_og2016" "${dABR}/temp_og2017" ///
		"${dABR}/temp_og2018" "${dABR}/temp_og2019" "${dABR}/temp_og2020" ///
		"${dABR}/temp_og2021" "${dABR}/temp_og2022"
		
	// Coding error by CBS in 2017: multiple sector codes are incorrectly assigned
	// Solution: Recode 2017 sectorcode to 2018 sectorcode if inconsistent
	gsort ogid year
	bys ogid: replace og_sector = og_sector[_n+1] if year==2017 & ///
		year[_n+1]==2018 & (og_sector!=og_sector[_n+1])
	bys ogid: replace og_ownership = og_ownership[_n+1] if year==2017 & ///
		year[_n+1]==2018 & (og_ownership!=og_ownership[_n+1])
	bys ogid: replace og_sectorcode = og_sectorcode[_n+1] if year==2017 & ///
		year[_n+1]==2018 & (og_sectorcode!=og_sectorcode[_n+1])
		
	// Labeling
	labels_nidio, module(abr)
		
	gsort year ogid
		
	* Remove households & foreign entities from OG register
	keep if og_sector == 11 | og_sector == 12 | og_sector == 13 | og_sector == 15
		
	save "${dABR}/nidio_abr_og_register_2006_2023", replace	
	
	*Delete temporary files
	foreach year of num 2006/2023 {
		erase "${dABR}/temp_og`year'.dta"
	}
	*
	
* --------------------------------------------------------------------------- */
* 2. OG-BE LONGITUDINAL FILE
* ---------------------------------------------------------------------------- *

********************************************************************************
* Preparing ABR_BE
********************************************************************************
	
	foreach year of num 2006/2023 {
		import spss using "${abr_BE`year'}", case(lower) clear
		
		* Starting in 2021: differing variable names
		if `year'>=2021 {
			rename (be_id maandbegin maandeinde bekernpersoon ogidentificatie ///
			sbi93gecoordineerd sbigecoordineerd gksbsgecoordineerd ///
			ogsectorcodegecoordineerd rechtsvormcode wpactueel lbe postcode_crypt ///
			gemcode) (rbe_identificatie rbe_datumontstaantoepassing ///
			rbe_datumopheffingtoepassing vep_identificatie_kernpersoon ///
			rog_identificatie rbe_sbi93gecoordineerd rbe_sbigecoordineerd ///
			rbe_gksbsgecoordineerd rog_sectorcodegecoordineerd vep_rechtsvormcode ///
			rbe_werkzamepersonen lbe postcode6_crypt gemcode)
		}
	
		// Harmonize & Simplify variable names & 
		// Rename ID variables according to convention
		capture rename rog_identificatie ogid
		
		capture rename rbe_identificatie beid
		capture rename be_id beid
		
		capture rename vep_identificatie_kernpersoon vepid
		
		capture rename rbe_sbi93gecoordineerd be_SBI93 // Not available in 2013 & 2014
		capture rename rbe_sbigecoordineerd be_SBI08 // Available from 2010-
		rename rbe_gksbsgecoordineerd be_gksbs
		rename rbe_werkzamepersonen be_employees
		rename lbe be_lbe
		rename gemcode be_municipality_code
		capture clonevar vep_legalform = vep_rechtsvormcode
		rename postcode6_crypt vep_postcode_crypt
	
		order ogid, before(beid)
		order vepid, after(beid)
	
		// Add calendar year
		gen year = `year'
		order year, before(ogid)
		
		// Drop variables that are not required
		drop rog_sectorcodegecoordineerd // consistent with ABR_OG
		capture drop vep_vestigingsadrespostcodenumer // incomplete time series
		
		// GKSBS - Destring
		destring be_gksbs, replace
		
		// SBI - Harmonization
		if `year'<=2009 {
		    rename be_SBI93 RBE_SBI93GECOORDINEERD
		    gen SECT = ""
			do "${sdir}/_AUXILIARY/SBI/SBI_93to08_recode"
			rename (RBE_SBI93GECOORDINEERD SECT) (be_SBI93 be_SBI08)
		}
		
		gen industry = substr(be_SBI08,1,2)
		gen be_industry = real(industry)
		drop industry
		
		recode be_industry (1/3 = 1) (6/9 = 2) (10/33 = 3) (35 = 4) (36/39 = 5) ///
			(41/43 = 6) (45/47 = 7) (49/53 = 8) (55/56 = 9) (58/63 = 10) ///
			(64/66 = 11) (68 = 12) (69/75 = 13) (77/82 = 14) (84=15) (85 = 16) ///
			(86/88 = 17) (90/93 = 18) (94/96 = 19) (97/98 = 20) (99 = 21)
		
		// Legal form - Harmonization & Simplification
		// (Starting with 2015 CBS has simplified the coding scheme)
		destring vep_legalform, replace
		order vep_legalform, after(vep_rechtsvormcode)
		recode vep_legalform (1=1) (2=2) (5=5) (7 8 9 = 6) (10 11 13 = 12) ///
			(20 21 22 24 = 25) (30 31 32 33 = 35) (40 41 42 = 43) (50 51 52 53 = 57) ///
			(55 56 = 58) (60 61 62 63 65 66 = 67) (70 71 72 78 = 77) (73=73) (74=74) ///
			(80 81 82 83 85 = 87) (91 94 95 96 100/899 = 90) (93 99 = 93) (97/98=.) ///
			(901/997 = 900) (999=.)
	
		// Start / end observation OG
		tostring rbe_datumontstaantoepassing rbe_datumopheffingtoepassing, replace
	
		gen be_start = date(rbe_datumontstaantoepassing, "YMD") 
		format be_start %d
		gen be_end = date(rbe_datumopheffingtoepassing, "YMD") 
		format be_end %d
	
		drop rbe_datumontstaantoepassing rbe_datumopheffingtoepassing
	
		// Order of variables
		order be_start be_end be_gksbs be_employees be_lbe be_municipality, after(beid)
		capture order be_SBI08 be_industry, after(be_end)
		capture order be_SBI93, after(be_end)
		order vep_rechtsvormcode vep_legalform vep_postcode_crypt, after(vepid)
		
		// Save temporary file
		save "${dABR}/temp_be`year'", replace
	}
	*
	
	// Append files to create yearly BE register 2006-2023
	append using "${dABR}/temp_be2006" "${dABR}/temp_be2007" "${dABR}/temp_be2008" ///
		"${dABR}/temp_be2009" "${dABR}/temp_be2010" "${dABR}/temp_be2011" ///
		"${dABR}/temp_be2012" "${dABR}/temp_be2013" "${dABR}/temp_be2014" ///
		"${dABR}/temp_be2015" "${dABR}/temp_be2016" "${dABR}/temp_be2017" ///
		"${dABR}/temp_be2018" "${dABR}/temp_be2019" "${dABR}/temp_be2020" ///
		"${dABR}/temp_be2021" "${dABR}/temp_be2022"
		
	gsort year ogid
	
	save "${dABR}/be_register_2006_2023", replace	
	
	*Delete temporary files
	foreach year of num 2006/2023 {
		erase "${dABR}/temp_be`year'.dta"
	}
	*
	
********************************************************************************
* Preparing ABR_OG_BE
********************************************************************************

	foreach year of num 2006/2023 {
		
		import spss using "${abr_OG_BE`year'}", case(lower) clear
		
		// Rename ID variables according to convention
		capture rename rog_identificatie ogid
		capture rename ogidentificatie ogid
		
		capture rename rbe_identificatie beid
		capture rename be* beid

		capture rename (maandbegin maandeinde) (rop_datumontstaantoepassing ///
			rop_datumopheffingtoepassing)
		
		// Add calendar year
		gen year = `year'
		order year, before(ogid)
	
		// Start / end OG-BE link
		tostring rop_datumontstaantoepassing rop_datumopheffingtoepassing, replace
	
		gen ogbe_start = date(rop_datumontstaantoepassing, "YMD") 
		gen ogbe_end = date(rop_datumopheffingtoepassing, "YMD") 
	
		drop rop_datumontstaantoepassing rop_datumopheffingtoepassing
		
		// Interruptions of OG-BE link within calendar year (ignore, but tag)
		gduplicates tag year ogid beid, gen(ogbe_interruption)
		
		gegen ogbe_s=min(ogbe_start), by(year ogid beid)
		gegen ogbe_e=max(ogbe_end), missing by(year ogid beid)
		
		drop ogbe_start ogbe_end
		rename (ogbe_s ogbe_e) (ogbe_start ogbe_end)
		order ogbe_interruption, after(ogbe_end)
		
		format ogbe_start %d
		format ogbe_end %d
		
		gduplicates drop year ogid beid, force
		
		// Save temporary file
		save "${dABR}/temp_ogbe`year'", replace	
	}
	*
	
	// Append files to create yearly OG-BE link file 2006-2023
	append using "${dABR}/temp_ogbe2006" "${dABR}/temp_ogbe2007" "${dABR}/temp_ogbe2008" ///
		"${dABR}/temp_ogbe2009" "${dABR}/temp_ogbe2010" "${dABR}/temp_ogbe2011" ///
		"${dABR}/temp_ogbe2012" "${dABR}/temp_ogbe2013" "${dABR}/temp_ogbe2014" ///
		"${dABR}/temp_ogbe2015" "${dABR}/temp_ogbe2016" "${dABR}/temp_ogbe2017" ///
		"${dABR}/temp_ogbe2018" "${dABR}/temp_ogbe2019" "${dABR}/temp_ogbe2020" ///
		"${dABR}/temp_ogbe2021" "${dABR}/temp_ogbe2022"
		
	gsort year ogid beid
	
	save "${dABR}/ogbe_link_2006_2023", replace	
	
	*Delete temporary files
	foreach year of num 2006/2023 {
		erase "${dABR}/temp_ogbe`year'.dta"
	}
	*
	
********************************************************************************
* Preparing ABR_BE_EVENTS
********************************************************************************

	foreach year of num 2006/2023 {
		
		import spss using "${abr_BE_event`year'}", case(lower) clear
		
		// Drop original value labels
		label drop _all
		
		// Rename ID variables according to convention
		capture rename rog_identificatie ogid
		capture rename ogidentificatie ogid
		
		capture rename rbe_identificatie beid
		capture rename be* beid
		
		capture rename vev_type ogbe_event
		capture rename eventtype ogbe_event
		
		// Multiply event date for merging 
		clonevar vev_datumtoepassing2 = vev_datumtoepassing
		
		// Add calendar year
		gen year = `year'
		order year ogid , before(beid)
		
		// Keep only IDs, eventdate, and detailed event type
		keep year ogid beid ogbe_event vev_datumtoepassing vev_datumtoepassing2
		
		// Start / end OG-BE link
		tostring vev_datumtoepassing vev_datumtoepassing2, replace
	
		gen ogbe_start = date(vev_datumtoepassing, "YMD") 
		gen ogbe_end = date(vev_datumtoepassing2, "YMD") 
		
		format ogbe_start %d
		format ogbe_end %d
	
		drop vev_datumtoepassing vev_datumtoepassing2
		order ogbe_start ogbe_end, after(beid)
		
		// Starting from 2021 event types are saved as string
		// Encode and then harmonize 
		if `year'>=2021 {
			encode ogbe_event, gen(event)
			lab drop event
			recode event (1=12) (2=9) (3=6) (4=4) (5=8) (6=7) (7=5) (8=10) ///
				(9=13) (10=21) (11=19) (12=16) (13=14) (14=18) (15=17) (16=15) (17=20)
			drop ogbe_event
			rename event ogbe_event
		}
		
		// Save temporary file
		save "${dABR}/temp_event`year'", replace	
	}
	*
	
	// Append files to create yearly OG-BE event link file 2006-2023
	append using "${dABR}/temp_event2006" "${dABR}/temp_event2007" "${dABR}/temp_event2008" ///
		"${dABR}/temp_event2009" "${dABR}/temp_event2010" "${dABR}/temp_event2011" ///
		"${dABR}/temp_event2012" "${dABR}/temp_event2013" "${dABR}/temp_event2014" ///
		"${dABR}/temp_event2015" "${dABR}/temp_event2016" "${dABR}/temp_event2017" ///
		"${dABR}/temp_event2018" "${dABR}/temp_event2019" "${dABR}/temp_event2020" ///
		"${dABR}/temp_event2021" "${dABR}/temp_event2022"
	
	gsort year ogid beid ogbe_start
	
	save "${dABR}/ogbe_event_2006_2023", replace	
	
	*Delete temporary files
	foreach year of num 2006/2023 {
		erase "${dABR}/temp_event`year'.dta"
	}
	*
		
	
********************************************************************************
* Merge
********************************************************************************

	use "${dABR}/nidio_abr_og_register_2006_2023", replace
	
	// First merge: ABR_OG & ABR_BE
	merge 1:m year ogid using "${dABR}/be_register_2006_2023", keep(master match) ///
		nogen
	
	* Remove empty decimals in variable be_employees
	format %5.0f be_employees
	
	// Second merge: ABR_OGBE & ABR_OGBE_Link
	gsort year ogid beid
	
	merge 1:1 year ogid beid using "${dABR}/ogbe_link_2006_2023", keep(master match) ///
		nogen
		
	// Select only employers: Remove BEs not appearing in SPOLIS
	gsort year beid
	merge m:1 year beid using "${dSPOLIS}/nidio_spolis_beid_register_2006_2023", ///
		keep(match) nogen
	
	// Third merge: ABR_OGBE & ABR_OGBE_event
	gsort year ogid beid ogbe_start
	merge 1:1 year ogid beid ogbe_start using "${dABR}/ogbe_event_2006_2023", ///
		keep(master match) keepusing(ogbe_event) nogen
	rename ogbe_event ogbe_start_event
	gsort year ogid beid ogbe_end
	merge 1:1 year ogid beid ogbe_end using "${dABR}/ogbe_event_2006_2023", ///
		keep(master match) keepusing(ogbe_event) nogen
	rename ogbe_event ogbe_end_event
	order ogbe_start_event ogbe_end_event, after(ogbe_end)
	
	// Remove unlabeled variable from source data
	capture drop _v1
	
	// Labeling
	labels_nidio, module(abr)
	
	// Sort dataset & save
	gsort year ogid beid
		
	save "${dABR}/nidio_abr_ogbe_register_2006_2023", replace
	
	erase "${dABR}/ogbe_link_2006_2023.dta"
	erase "${dABR}/be_register_2006_2023.dta"
	erase "${dABR}/ogbe_event_2006_2023.dta"
	
	// Create reduced list containing only one observation per OG-year for 
	// matching with OG-KVK register.
	keep year ogid
	gduplicates drop year ogid, force
	save "${dABR}/abr_ogbe_list_2006_2023", replace
	
* --------------------------------------------------------------------------- */
* 3. OG-KVK LONGITUDINAL FILE
* ---------------------------------------------------------------------------- *

********************************************************************************
* Preparing ABR_OG_pers
********************************************************************************
	
	foreach year of num 2006/2023 {
		
		import spss using "${abr_OG_pers`year'}", case(lower) clear
		
		// Rename ID variables according to convention
		capture rename rog_identificatie ogid
		capture rename ogidentificatie ogid
		
		capture rename persoon_identificatie vepid
		capture rename cbspersoonidentificatie vepid
		
		capture rename (cpogmaandbegin cpogmaandeinde) (rop_datumontstaantoepassing ///
			rop_datumopheffingtoepassing)
		
		// Add calendar year
		gen year = `year'
		order year, before(ogid)
	
		// Start / end OG-VEP link
		tostring rop_datumontstaantoepassing rop_datumopheffingtoepassing, replace
	
		gen ogvep_start = date(rop_datumontstaantoepassing, "YMD") 
		gen ogvep_end = date(rop_datumopheffingtoepassing, "YMD") 
	
		drop rop_datumontstaantoepassing rop_datumopheffingtoepassing
		
		// Interruptions within calendar year of OG-VEP link (ignore, but tag)
		gduplicates tag year ogid vepid, gen(ogvep_interruption)
		
		gegen ogvep_s=min(ogvep_start), by(year ogid vepid)
		gegen ogvep_e=max(ogvep_end), missing by(year ogid vepid)
		
		drop ogvep_start ogvep_end
		rename (ogvep_s ogvep_e) (ogvep_start ogvep_end)
		order ogvep_interruption, after(ogvep_end)
		
		format ogvep_start %d
		format ogvep_end %d
		
		gduplicates drop year ogid vepid, force
		
		// Save temporary file
		save "${dABR}/temp_ogvep`year'", replace	
	}
	*
	
	// Append files to create yearly OG-VEP link file 2006-2023
	append using "${dABR}/temp_ogvep2006" "${dABR}/temp_ogvep2007" "${dABR}/temp_ogvep2008" ///
		"${dABR}/temp_ogvep2009" "${dABR}/temp_ogvep2010" "${dABR}/temp_ogvep2011" ///
		"${dABR}/temp_ogvep2012" "${dABR}/temp_ogvep2013" "${dABR}/temp_ogvep2014" ///
		"${dABR}/temp_ogvep2015" "${dABR}/temp_ogvep2016" "${dABR}/temp_ogvep2017" ///
		"${dABR}/temp_ogvep2018" "${dABR}/temp_ogvep2019" "${dABR}/temp_ogvep2020" ///
		"${dABR}/temp_ogvep2021" "${dABR}/temp_ogvep2022"
		
	gsort year ogid vepid
	
	save "${dABR}/ogvep_link_2006_2023", replace	
	
	*Delete temporary files
	foreach year of num 2006/2023 {
		erase "${dABR}/temp_ogvep`year'.dta"
	}
	*
	
********************************************************************************
* Preparing ABR_CBS_KVK
********************************************************************************
	
	foreach year of num 2006/2023 {
		
		import spss using "${abr_CBS_KVK`year'}", case(lower) clear
		
		// Rename ID variables according to convention
		capture rename vep_identificatie vepid
		capture rename vep vepid
		capture rename cbspersoonidentificatie vepid
		
		capture rename vep_kvkdossiernummer_crypt kvkid
		capture rename vep_kvknummer_crypt kvkid
		capture rename vep_kvknummer kvkid
		capture rename kvknr kvkid
		capture rename kvknummer kvkid
		
		capture rename vep_finr_crypt finr
		capture rename vep_finr finr
		
		capture rename (cpogmaandbegin cpogmaandeinde) (vep_datumontstaantoepassing ///
			vep_datumopheffingtoepassing)
		capture rename (cpmaandbegin cpmaandeinde) (vep_datumontstaantoepassing ///
			vep_datumopheffingtoepassing)
		
		// Add calendar year
		gen year = `year'
		order year, before(vepid)
	
		// Start / end VEP-KVK link
		if `year'!=2019 & `year'!=2020 {
			tostring vep_datumontstaantoepassing vep_datumopheffingtoepassing, replace
	
			gen vepkvk_start = date(vep_datumontstaantoepassing, "YMD")
			format vepkvk_start %d
			gen vepkvk_end = date(vep_datumopheffingtoepassing, "YMD") 
			format vepkvk_end %d
	
			drop vep_datumontstaantoepassing vep_datumopheffingtoepassing
		}
		else {
			rename vep_datumontstaantoepassing vepkvk_start
			replace vepkvk_start = .
			rename vep_datumopheffingtoepassing vepkvk_end 
			replace vepkvk_end = .
		}
		
		// Data issue: 2022 & 2023 with many duplicates despite consistent KvK / Finr
		// Solution: Take min max dates within calendar year & drop duplicates
		if `year'==2022 | `year'==2023 {
			gegen vep_s=min(vepkvk_start), by(vepid)
			gegen vep_e=max(vepkvk_end), missing by(vepid)
		
			drop vepkvk_start vepkvk_end
			rename (vep_s vep_e) (vepkvk_start vepkvk_end)
		
			format vepkvk_start %d
			format vepkvk_end %d
		
			gduplicates drop vepid, force
		}
		
		// Keep specific set of variables
		keep year vepid kvkid finr vepkvk_start vepkvk_end
		
		// Save temporary file
		save "${dABR}/temp_vepkvk`year'", replace	
	}
	*
	
	// Append files to create yearly VEP-KVK link file 2006-2023
	append using "${dABR}/temp_vepkvk2006" "${dABR}/temp_vepkvk2007" ///
		"${dABR}/temp_vepkvk2008" "${dABR}/temp_vepkvk2009" "${dABR}/temp_vepkvk2010" ///
		"${dABR}/temp_vepkvk2011" "${dABR}/temp_vepkvk2012" "${dABR}/temp_vepkvk2013" /// 
		"${dABR}/temp_vepkvk2014" "${dABR}/temp_vepkvk2015" "${dABR}/temp_vepkvk2016" /// 
		"${dABR}/temp_vepkvk2017" "${dABR}/temp_vepkvk2018" "${dABR}/temp_vepkvk2019" ///
		"${dABR}/temp_vepkvk2020" "${dABR}/temp_vepkvk2021" "${dABR}/temp_vepkvk2022"
		
	gsort year vepid
	
	save "${dABR}/vepkvk_link_2006_2023", replace	
	
	*Delete temporary files
	foreach year of num 2006/2023 {
		erase "${dABR}/temp_vepkvk`year'.dta"
	}
	*
	
********************************************************************************
* Merge
********************************************************************************

	use "${dABR}/nidio_abr_og_register_2006_2023", replace
	
	// Select only employers: Remove OG-years not appearing in SPOLIS (via BE)
	gsort year ogid
	merge 1:1 year ogid using "${dABR}/abr_ogbe_list_2006_2023", ///
		keep(match) nogen
	
	// First merge: ABR_OG & ABR_OG_VEP
	merge 1:m year ogid using "${dABR}/ogvep_link_2006_2023", keep(master match) ///
		nogen
	
	// Second merge: ABR_OGVEP & ABR_VEP_KVK
	gsort year vepid
	merge m:1 year vepid using "${dABR}/vepkvk_link_2006_2023", keep(master match) ///
		nogen
	
	// Create variable containing number of VEP per year-OG
	bys year ogid: gen og_nrofvep = _N
	order og_nrofvep, after(og_ownership)
	
	// Recast kvkid and finr as str32 to enable merging
	capture recast str kvkid
	capture recast str finr
	
	// Labeling
	labels_nidio, module(abr)
	
	gsort year ogid vepid
		
	save "${dABR}/nidio_abr_ogkvk_register_2006_2023", replace
	
	erase "${dABR}/abr_ogbe_list_2006_2023.dta"
	erase "${dABR}/ogvep_link_2006_2023.dta"
	erase "${dABR}/vepkvk_link_2006_2023.dta"
	
* --------------------------------------------------------------------------- */
* 4. OG SIZE FILE
* ---------------------------------------------------------------------------- *

	use "${dABR}/nidio_abr_ogbe_register_2006_2023", replace
	
	* Calculate the total number of employees per OG-year. OG-years with only
	* one BE attached already hold final number. Complication: in case of multiple 
	* BEs, the same BE can appear twice (and count double) when a new BE code is 
	* assigned by CBS.
	
	* Generate number of BEs within OG-year
	bys year ogid: gen nr_be = _N
	
	gegen ogyear = tag(year ogid)
	tab nr_be if ogyear==1
	* --> 98.10% of all OG-years contain only 1 BE.
	
	gsort year ogid be_start
	
	* Identify repeated VEPIDs within OG-years. Repeated BEs with different ID 
	* are in most cases also VEPID duplicates. They often also hold the exact same
	* number of employees (specifically after 2010 given revised CBS size calculation).
	gduplicates drop year ogid vepid be_employees, force
	
	* Further approximate by deleting BEs that seize to exist in a calendar year 
	* and which have a duplicate VEP within OG-year 
	gduplicates tag year ogid vepid, gen(dupl)
	drop if be_end!=. & dupl!=0
	
	// Aggregate BE size at OG level
	gegen og_employees = total(be_employees), by(year ogid) 
	
	gduplicates drop year ogid, force
	keep year ogid og_employees
	sort ogid year
	
	// Labeling
	labels_nidio, module(abr)
	
	* Save file
	save "${dABR}/nidio_abr_og_size_2006_2023", replace

	clear