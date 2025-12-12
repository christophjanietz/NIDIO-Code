/*=============================================================================* 
* DATA PREPARATION - OCCUPATION CODES
*==============================================================================*
 	Project: Beyond Boardroom / NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 08-12-2025
* ---------------------------------------------------------------------------- *

	INDEX: 
		1. PREPARE OCCUPATIONAL DATA (EBB)
		2. PREPARE SPOLIS DATA (NIDIO SPOLIS YEAR)
		3. MERGE EBB OCCUPATIONS WITH JOB IDS
		4. GENERATE FILE WITH UNIQUE YEAR - JOB IDS
		
		
* Short description of output:
*
* Link EBB occupation codes to jobs in SPOLIS
*
* ebb_occ_job_total_2006_2024:
* Complete list of EBB observations including occupation codes matched with
* most plausible job ID from SPOLIS.
*
* ebb_occ_job_unique_2006_2023:
* Unique year-slbaanid combinations and matched occupation code based on EBB.
	
* --------------------------------------------------------------------------- */
* 1. PREPARE OCCUPATIONAL DATA (EBB)
* ---------------------------------------------------------------------------- *

	use "${dEBB}/nidio_ebb_occ_2006_2024", replace
	
	// Extract list of sampled year 
	preserve
		drop year
		gen year=year(rin_svydate_EBB)
		keep year rinpersoon
		duplicates drop year rinpersoon, force
		save "${dEBB}/riny", replace
	restore
	
	// Extract list of sampled year-month
	
	preserve
		drop year
		gen year=year(rin_svydate_EBB)
		gen month=month(rin_svydate_EBB)
		keep year month rinpersoon
		duplicates drop year month rinpersoon, force
		sort rinpersoon year month
		save "${dEBB}/rinym", replace
	restore
	
* --------------------------------------------------------------------------- */
* 2. PREPARE SPOLIS DATA (NIDIO SPOLIS YEAR)
* ---------------------------------------------------------------------------- *

	// 1. Load NIDIO SPOLIS YEAR with necessary variables
	use year rinpersoon beid slbaanid baanrugid ikvid job_start_caly job_end_caly ///
		ft_factor mainjob using "\\remoteaccess.cbs.nl\otherdata\Folder00\Extern maatwerk\nidio_spolis_year_2006_2023\nidio_spolis_year_2006_2023.dta", replace
	
	sort year rinpersoon
		
	// 2. Reduce to rinpersoon-year in EBB
	merge m:1 year rinpersoon using "${dEBB}/riny", keep(match) nogen
	
	*Create date variables
	gen y_start = year(job_start_caly)
	gen m_start = month(job_start_caly)
	gen y_end = year(job_end_caly)
	gen m_end = month(job_end_caly)
	
	drop year job_start_caly job_end_caly
	
	save "${dEBB}/spolis_year_ebb", replace
	
	// 3. Create year-month register of jobs 
	
	// Construct long list of exact-day
	foreach year of num 2006/2023 {
		foreach month of num 1/12 {
			use "${dEBB}/spolis_year_ebb", replace
			keep if y_start==`year' & y_end==`year'
			drop if m_start>`month'
			drop if m_end<`month'
			gen year=`year'
			gen month=`month'
			order year month, before(rinpersoon)
			drop y_start m_start y_end m_end
			
			tempfile temp`year'`month'
			save `temp`year'`month''
		}
	}
	
	foreach year of num 2006/2023 {
		foreach month of num 1/12 {
			if `year'==2023 & `month'==12 {
				display ""
			}
			else {
				append using "`temp`year'`month''"
			}
		}
	}
	
	sort year month rinpersoon
	
	// Reduce to rinpersoon-year-month in EBB
	merge m:1 year month rinpersoon using "${dEBB}/rinym", keep(match) nogen
	
	save "${dEBB}/spolis_year_ebb", replace
	
* --------------------------------------------------------------------------- */
* 3. MERGE EBB OCCUPATIONS WITH JOB IDS
* ---------------------------------------------------------------------------- *

	use "${dEBB}/nidio_ebb_occ_2006_2024", replace
	
	* Generate variable holding survey year / month
	drop year
	gen year = year(rin_svydate_EBB)
	gen month = month(rin_svydate_EBB)
	order year month, before(rinpersoon)
	
	* Identify year-month duplicates and mark them
	bys year month rinpersoon: gen n = _n
	
	levelsof n, local(levels)
		
		foreach l of local levels {
			preserve
				keep if n==`l'
			
				merge 1:m year month rinpersoon using "${dEBB}/spolis_year_ebb", ///
					nogen keep(master match)
				
				drop month
				gsort year rinpersoon rin_svydate_EBB
			
				tempfile temp`year'_`l'
				save `temp`year'_`l''
			restore
		}
		
		use "`temp`year'_1'", replace
		foreach l of local levels {
			if `l'!=1 {
				append using "`temp`year'_`l''"
			}
		}
	
	gsort year rinpersoon rin_svydate_EBB
	
	// IDENTIFY ONE UNIQUE JOB ID PER SURVEY OBSERVATION
	* In case of multiple co-existing jobs: Select by largest full-time factor
	bys year rinpersoon rin_svydate_EBB: egen maxft = max(ft_factor)
	keep if maxft==ft_factor
	* Second criterium: Mainjob
	bys year rinpersoon rin_svydate_EBB: egen maxmj = max(mainjob)
	keep if maxmj==mainjob
	* Third criterium: Forced drop very few cases
	duplicates drop year rinpersoon rin_svydate_EBB, force
	
	keep year rinpersoon rin_svydate_EBB rin_svynr_EBB rin_weight_EBB ///
		rin_position_EBB rin_ISCO08 beid slbaanid
	
	save "${dEBB}/nidio_ebb_occ_job_total_2006_2024", replace
	
	
* --------------------------------------------------------------------------- */
* 4. GENERATE FILE WITH UNIQUE YEAR - JOB IDS
* ---------------------------------------------------------------------------- *
	
	* Generate file with unique year-slbaanid
	
	// Collapse by year-slbaanid-occupation code
	collapse (count) n=beid (max) rin_svydate_EBB, ///
		by(year rinpersoon slbaanid rin_ISCO08)
	
	drop if rin_ISCO08==.
		
	// In case of inconsistent codes in the same calendar year, use most frequent
	// code or most recent code
	bys year rinpersoon slbaanid: egen maxn = max(n)
	keep if maxn==n
	
	gen month = month(rin_svydate_EBB)
	bys year rinpersoon slbaanid: egen maxm = max(month)
	keep if maxm==month
	drop n rin_svydate_EBB maxn month maxm
	
	// Drop non-matched survey obs that were matched at a different point within
	// the calendar year
	bys year rinpersoon rin_ISCO08: gen N = _N
	drop if slbaanid=="" & N!=1
	drop N
	
	// Drop unidentified cases
	drop if slbaanid==""
	
	// Force drop a negligble number of duplicates
	duplicates drop year rinpersoon slbaanid, force
	sort year rinpersoon slbaanid
	
	// Order job ID
	order slbaanid, after(rinpersoon)
	
	// Source
	gen occ_source = "EBB"
	lab var occ_source "Data source of occupation code"
	
	// Save
	save "${dEBB}/nidio_ebb_occ_job_unique_2006_2023", replace
	
	// Erase 
	erase "${dEBB}/riny.dta"
	erase "${dEBB}/rinym.dta"
	erase "${dEBB}/spolis_year_ebb.dta"
	erase "${dEBB}/nidio_ebb_occ_2006_2024.dta"
	