/*=============================================================================* 
* DATA PREPARATION - (S)POLISBUS
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 02-12-2024
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. 	POLIS (2006-2009)
		2.  SPOLIS (2010-2023) 
		3.  APPEND YEARLY FILES
		
* Short description of output:
*
* - Longitudinal job files (Unit: Job/months)
*
* nidio_spolis_month_2006_2023: 
* Unique job observations existing in September between 2006 and 2023. Compensation 
* and working hours as in September of the given calendar year.
	
* --------------------------------------------------------------------------- */
* 1. POLIS (2006-2009)
* ---------------------------------------------------------------------------- *

	*POLIS
	foreach year of num 2006/2009 {
		use rinpersoons rinpersoon baanrugid aanvbus eindbus baandagen basisloon ///
			basisuren bijzonderebeloning extrsal incidentsal lningld lnowrk ///
			overwerkuren vakbsl voltijddagen contractsoort polisdienstverband ///
			beid caosector datumaanvangikv datumeindeikv soortbaan reguliereuren ///
			wekarbduurklasse datumaanvangikvorg CAO_crypt ///
			using "${polis`year'}", replace
			
		rename _all, lower
		
		*Harmonize variable names
		foreach var of var baandagen basisloon basisuren bijzonderebeloning ///
			extrsal incidentsal lningld lnowrk overwerkuren vakbsl voltijddagen ///
			contractsoort polisdienstverband beid caosector datumaanvangikv ///
			datumeindeikv soortbaan reguliereuren wekarbduurklasse ///
			datumaanvangikvorg cao_crypt{
				rename `var' s`var' 
			}
		rename (aanvbus eindbus) (sdatumaanvangiko sdatumeindeiko)
		
		// Keep only workers registered in GBR
		keep if rinpersoons=="R"
		drop rinpersoons
		
		// SELECTION: Only observations in September
		gen month = substr(sdatumeindeiko,5,2)
		destring month, replace
		
		keep if month==9
		drop month
		
		// Recast baanrugid as str** to enable merging
		capture recast str baanrugid
		
		// Prepare date indicators
		gen job_start_caly = date(sdatumaanvangikv, "YMD")
		gen job_end_caly = date(sdatumeindeikv, "YMD")
		
		gen job_tenure = date(sdatumaanvangikvorg, "YMD")
		* Set as missing before 2013. Until then, variable is capped at 01-01 of 
		* same year 
		if `year'<=2012 { 
			replace job_tenure=.
		}
		
		gen year = `year'
		order year, before(rinpersoon)
		
		format job_start_caly job_end_caly job_tenure %d
		drop sdatumaanvangiko sdatumeindeiko sdatumaanvangikv sdatumeindeikv ///
			sdatumaanvangikvorg
		
		// Aggregate compensation and working time variables
		// (within job-months)
		foreach var of var sbaandagen-svoltijddagen {
			gegen `var'_month = total(`var'), by(rinpersoon baanrugid)
		}
		
		// Pick one observation on job-month level & remove all other observations
		gegen select = tag(rinpersoon baanrugid)
		keep if select==1
		
		// Drop non-aggregated variables
		drop sbaandagen-svoltijddagen select
		
		// Create full-time-factor on job-level (month)
		gen ft_factor = svoltijddagen_month / sbaandagen_month
		
		// Destring variables
		* BEID
		* Remove BEID which are not registered in ABR
		gen be_prefix = substr(sbeid,1,1)
		drop if be_prefix=="F" | be_prefix=="P"
		drop be_prefix
		*Destring
		destring sbeid, replace
		rename sbeid beid
		order beid, after(rinpersoon)
		* Contract duration
		gen cntrct = 0
		replace cntrct = 1 if scontractsoort=="B" | scontractsoort=="b"
		replace cntrct = . if scontractsoort=="N" | scontractsoort=="n"
		drop scontractsoort
		rename cntrct scontractsoort
		order scontractsoort, before(spolisdienstverband)
		* Full-time / Part-time
		destring spolisdienstverband, replace
		* Working time category
		destring swekarbduurklasse, replace
		* Job type 
		destring ssoortbaan, replace
		* CAO
		destring scaosector, replace
		recode scaosector (1000 = 1) (2000 = 2) (3000/3800 = 3)
		recast str32 scao_crypt
		sort scao_crypt
		merge m:1 scao_crypt using "${BedrijfstakCAO}", keep(master match) ///
			nogen keepusing(cao)
		rename cao caocode
		destring caocode, gen(cao)
		recode cao (9999=0) (1/9998=1) (.=2)
		order scao_crypt caocode cao, after(scaosector)
		
		gsort rinpersoon baanrugid
		
		// Save dataset
		save "${dSPOLIS}/spolis_month_`year'", replace
		
	}
	*
	
	// Merge longitudinal job identifier
	
	* Prepare SPOLISLONGBAANTAB
	import spss using "${polis_long}", case(lower) clear
	keep if rinpersoons=="R"
	gsort rinpersoon baanrugid
	rename lbaanid slbaanid
	save "${dSPOLIS}/polislongbaantab", replace
	
	foreach year of num 2006/2009 {
		
		use "${dSPOLIS}/spolis_month_`year'", replace
	
		merge 1:1 rinpersoon baanrugid using "${dSPOLIS}/polislongbaantab", ///
			keep(master match) keepusing(slbaanid) nogen
			
		order slbaanid, after(baanrugid)
		
		// Longitudinal job id
		// Assign baanrugid or ikvid in case no longitudinal ID has been assigned
		capture replace slbaanid = ikvid if slbaanid=="" & ikvid!=""
		capture replace slbaanid = baanrugid if slbaanid=="" & baanrugid!=""
		
		// Save dataset
		save "${dSPOLIS}/spolis_month_`year'", replace
	}
	*
	
	erase "${dSPOLIS}/polislongbaantab.dta"
	
	// Merge main job identifier
	
	foreach year of num 2006/2009 {
		
		* Prepare SPOLISHOOFDBAANBUS
		import spss using "${mainjob`year'}", case(lower) clear
		keep if rinpersoons=="R"
		drop rinpersoons
		rename baanrugidhbaan baanrugid
		
		gen start = substr(aanvanghbaan,5,2)
		destring start, replace
		gen end = substr(eindehbaan,5,2)
		destring end, replace
		
		* Date ranges are on a daily level and can fluctuate. Therefore,
		* approximate mainjob period with earliest and latest month. Recode later
		* with full data in case of multiple 'mainjobs' within job-months.
		gegen mjstart=min(start), by(rinpersoon baanrugid)
		gegen mjend=max(end), by(rinpersoon baanrugid)
		
		* Create list of job IDs that are designated as main jobs during September.
		drop if mjstart>9 | mjend<9
		
		drop aanvanghbaan eindehbaan start end mjstart mjend
		
		gsort rinpersoon baanrugid
		gegen select = tag(rinpersoon baanrugid)
		keep if select==1
		drop select
		
		save "${dSPOLIS}/mainjob`year'", replace

		*  Merge to SPOLIS
		use "${dSPOLIS}/spolis_month_`year'", replace
		
		merge 1:1 rinpersoon baanrugid using "${dSPOLIS}/mainjob`year'", ///
			keep(master match) gen(mainjob)
		
		* Recode mainjob identifier
		lab drop _merge
		recode mainjob (1=0) (3=1)
		
		*Clean duplicates (in case of two or more main jobs within September)
		* Assign main job tag only to the main job ID with the highest compensation
		gegen nr_mj = total(mainjob), by(rinpersoon)
		gegen maxcomp = max(slningld_month) if mainjob==1, by(rinpersoon)
		replace mainjob=0 if nr_mj!=1 & maxcomp!=slningld_month
		drop nr_mj maxcomp
		
		* In case of identical max earnings: designate only one job ID within 
		* person ID as the main job
		gegen nr_mj = total(mainjob), by(rinpersoon)
		gegen tag=tag(rinpersoon) if mainjob==1
		replace mainjob=0 if nr_mj!=1 & tag==0 
		drop nr_mj tag
		
		save "${dSPOLIS}/spolis_month_`year'", replace
		
		* Erase mainjob files
		erase "${dSPOLIS}/mainjob`year'.dta"
	}
	*

* --------------------------------------------------------------------------- */
* 2. SPOLIS (2010-2023)
* ---------------------------------------------------------------------------- *


	foreach year of num 2010/2023 {
		use rinpersoons rinpersoon ikvid sdatumaanvangiko sdatumeindeiko sbaandagen ///
			sbasisloon sbasisuren sbijzonderebeloning sextrsal sincidentsal slningld ///
			slnowrk soverwerkuren svakbsl svoltijddagen scontractsoort spolisdienstverband ///
			sbeid scaosector sdatumaanvangikv sdatumeindeikv ssoortbaan sreguliereuren ///
			swekarbduurklasse sdatumaanvangikvorg SCAO_crypt using ///
			"${spolis`year'}", replace
			
		rename _all, lower
	
		// Keep only workers registered in GBR
		keep if rinpersoons=="R"
		drop rinpersoons
		
		// SELECTION: Only observations in September
		gen month = substr(sdatumeindeiko,5,2)
		destring month, replace
		
		keep if month==9
		drop month
		
		// Recast ikvid as str** to enable merging
		capture recast str ikvid
		
		// Prepare date indicators
		gen job_start_caly = date(sdatumaanvangikv, "YMD")
		gen job_end_caly = date(sdatumeindeikv, "YMD")
		
		gen job_tenure = date(sdatumaanvangikvorg, "YMD")
		* Set as missing before 2013. Until then, variable is capped at 01-01 of 
		* same year 
		if `year'<=2012 { 
			replace job_tenure=.
		}
		
		gen year = `year'
		order year, before(rinpersoon)
		
		format job_start_caly job_end_caly job_tenure %d
		drop sdatumaanvangiko sdatumeindeiko sdatumaanvangikv sdatumeindeikv ///
			sdatumaanvangikvorg
		
		// Aggregate compensation and working time variables
		// (within job-months)
		foreach var of var sbaandagen-svoltijddagen {
			gegen `var'_month = total(`var'), by(rinpersoon ikvid)
		}
		
		// Pick one observation on job-month level & remove all other observations
		gegen select = tag(rinpersoon ikvid)
		keep if select==1
		
		// Drop non-aggregated variables, max hours identifier, exact date variables
		drop sbaandagen-svoltijddagen select
		
		// Create full-time-factor on job-level (month)
		gen ft_factor = svoltijddagen_month / sbaandagen_month
		
		// Destring variables
		* BEID
		* Remove BEID which are not registered in ABR
		gen be_prefix = substr(sbeid,1,1)
		drop if be_prefix=="F" | be_prefix=="P"
		drop be_prefix
		*Destring
		destring sbeid, replace
		rename sbeid beid
		order beid, after(rinpersoon)
		* Contract duration
		gen cntrct = 0
		replace cntrct = 1 if scontractsoort=="B" | scontractsoort=="b"
		replace cntrct = . if scontractsoort=="N" | scontractsoort=="n"
		drop scontractsoort
		rename cntrct scontractsoort
		order scontractsoort, before(spolisdienstverband)
		* Full-time / Part-time
		destring spolisdienstverband, replace
		* Working time category
		destring swekarbduurklasse, replace
		* Job type 
		destring ssoortbaan, replace
		* CAO
		destring scaosector, replace
		recode scaosector (1000 = 1) (2000 = 2) (3000/3800 = 3)
		recast str32 scao_crypt
		sort scao_crypt
		merge m:1 scao_crypt using "${BedrijfstakCAO}", keep(master match) ///
			nogen keepusing(cao)
		rename cao caocode
		destring caocode, gen(cao)
		recode cao (9999=0) (1/9998=1) (.=2)
		order scao_crypt caocode cao, after(scaosector)
		
		gsort rinpersoon ikvid
		
		// Save dataset
		save "${dSPOLIS}/spolis_month_`year'", replace
		
	}
	*
	
	// Merge longitudinal job identifier
	
	* Prepare SPOLISLONGBAANTAB
	import spss using "${spolis_long}", case(lower) clear
	keep if rinpersoons=="R"
	gsort rinpersoon ikvid
	save "${dSPOLIS}/spolislongbaantab", replace
	
	foreach year of num 2010/2023 {
		
		use "${dSPOLIS}/spolis_month_`year'", replace
	
		merge 1:1 rinpersoon ikvid using "${dSPOLIS}/spolislongbaantab", ///
			keep(master match) keepusing(slbaanid) nogen
			
		order slbaanid, after(ikvid)
		
		// Longitudinal job id
		// Assign baanrugid or ikvid in case no longitudinal ID has been assigned
		capture replace slbaanid = ikvid if slbaanid=="" & ikvid!=""
		capture replace slbaanid = baanrugid if slbaanid=="" & baanrugid!=""
		
		// Save dataset
		save "${dSPOLIS}/spolis_month_`year'", replace
	}
	*
	
	erase "${dSPOLIS}/spolislongbaantab.dta"
	
	// Merge main job identifier
	
	foreach year of num 2010/2023 {
		
		* Prepare SPOLISHOOFDBAANBUS
		import spss using "${mainjob`year'}", case(lower) clear
		keep if rinpersoons=="R"
		drop rinpersoons
		rename ikvidhbaan ikvid
		
		gen start = substr(saanvanghbaan,5,2)
		destring start, replace
		gen end = substr(seindehbaan,5,2)
		destring end, replace
		
		* Date ranges are on a daily level and can fluctuate. Therefore,
		* approximate mainjob period with earliest and latest month. Recode later
		* with full data in case of multiple 'mainjobs' within job-months.
		gegen mjstart=min(start), by(rinpersoon ikvid)
		gegen mjend=max(end), by(rinpersoon ikvid)
		
		* Create list of job IDs that are designated as main jobs during September.
		drop if mjstart>9 | mjend<9
		
		drop saanvanghbaan seindehbaan start end mjstart mjend
		
		gsort rinpersoon ikvid
		gegen select = tag(rinpersoon ikvid)
		keep if select==1
		drop select
		
		save "${dSPOLIS}/mainjob`year'", replace

		*  Merge to SPOLIS
	    use "${dSPOLIS}/spolis_month_`year'", replace
		
		merge 1:1 rinpersoon ikvid using "${dSPOLIS}/mainjob`year'", ///
			keep(master match) gen(mainjob)
		
		* Recode mainjob identifier
		lab drop _merge
		recode mainjob (1=0) (3=1)
		
		*Clean duplicates (in case of two or more main jobs within September)
		* Assign main job tag only to the main job ID with the highest compensation
		gegen nr_mj = total(mainjob), by(rinpersoon)
		gegen maxcomp = max(slningld_month) if mainjob==1, by(rinpersoon)
		replace mainjob=0 if nr_mj!=1 & maxcomp!=slningld_month
		drop nr_mj maxcomp
		
		* In case of identical max earnings: designate only one job ID within 
		* person ID as the main job
		gegen nr_mj = total(mainjob), by(rinpersoon)
		gegen tag=tag(rinpersoon) if mainjob==1
		replace mainjob=0 if nr_mj!=1 & tag==0 
		drop nr_mj tag
		
		save "${dSPOLIS}/spolis_month_`year'", replace
		
		* Erase mainjob files
		erase "${dSPOLIS}/mainjob`year'.dta"
	}
	*
	
* --------------------------------------------------------------------------- */
* 3. APPEND YEARLY FILES
* ---------------------------------------------------------------------------- *

	use "${dSPOLIS}/spolis_month_2006", replace
	
	append using "${dSPOLIS}/spolis_month_2007" "${dSPOLIS}/spolis_month_2008" ///
		"${dSPOLIS}/spolis_month_2009" "${dSPOLIS}/spolis_month_2010" ///
		"${dSPOLIS}/spolis_month_2011" "${dSPOLIS}/spolis_month_2012" ///
		"${dSPOLIS}/spolis_month_2013" "${dSPOLIS}/spolis_month_2014" ///
		"${dSPOLIS}/spolis_month_2015" "${dSPOLIS}/spolis_month_2016" ///
		"${dSPOLIS}/spolis_month_2017" "${dSPOLIS}/spolis_month_2018" ///
		"${dSPOLIS}/spolis_month_2019" "${dSPOLIS}/spolis_month_2020" ///
		"${dSPOLIS}/spolis_month_2021" "${dSPOLIS}/spolis_month_2022" ///
		"${dSPOLIS}/spolis_month_2023"
		
	order ikvid, after(baanrugid)
	
	// Job tenure
	// Fill missing job tenure before 2013 with later observed job starting date 
	// within the same job (Jobs observed after 2013)
	gegen min = min(job_tenure), by(rinpersoon slbaanid)
	replace job_tenure = min if job_tenure==.
	drop min
	// Fill missing job tenure before 2013 with earliest observed job starting
	// date within the same job (Jobs only observed before 2013)
	gegen min = min(job_start_caly), by(rinpersoon slbaanid)
	replace job_tenure = min if job_tenure==.
	replace job_tenure = min if job_tenure>min
	drop min
	// Code as missing if assigned 01-01-2006 (this date is assigned if left-censored)
	replace job_tenure = . if job_tenure==16802
	
	gsort rinpersoon year slbaanid
	
	// Labels
	labels_nidio, module(spolis)
	
	save "${dSPOLIS}/nidio_spolis_month_2006_2023", replace
	
	* Erase yearly files
	foreach year of num 2006/2023 {
		erase "${dSPOLIS}/spolis_month_`year'.dta"
	}
	*	
	
	clear
	