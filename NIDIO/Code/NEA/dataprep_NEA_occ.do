/*=============================================================================* 
* DATA PREPARATION - OCCUPATION CODES (NEA)
*==============================================================================*
 	Project: Beyond Boardroom / NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 05-12-2025
* ---------------------------------------------------------------------------- *

	INDEX: 
		0. SETTINGS 
		1. PREPARE OCCUPATIONAL DATA (NEA)
		2. PREPARE SPOLIS DATA (NIDIO SPOLIS YEAR)
		3. MERGE NEA OCCUPATIONS WITH JOB IDS
		4. GENERATE FILE WITH UNIQUE YEAR - JOB IDS
		
		
* Short description of output:
*
* Link NEA occupation codes to jobs in SPOLIS.
*
* nea_occ_job_total_2006_2023:
* Complete list of NEA observations including occupation codes matched with
* most plausible job ID from SPOLIS.
*
* nea_occ_job_unique_2006_2023:
* Unique year-slbaanid combinations and matched occupation code based on NEA.
	
* --------------------------------------------------------------------------- */
* 1. PREPARE OCCUPATIONAL DATA (NEA)
* ---------------------------------------------------------------------------- *

	use "${dNEA}/nidio_nea_occ_2006_2023", replace
	
	// Extract list of sampled year 
	preserve
		keep if year>=2011
		keep year rinpersoon
		duplicates drop year rinpersoon, force
		save "${dNEA}/riny", replace
	restore
	
* --------------------------------------------------------------------------- */
* 2. PREPARE SPOLIS DATA (NIDIO SPOLIS YEAR)
* ---------------------------------------------------------------------------- *

	// 1. Load NIDIO SPOLIS YEAR with necessary variables
	use year rinpersoon beid slbaanid baanrugid ikvid job_start_caly job_end_caly ///
		ft_factor mainjob using "\\remoteaccess.cbs.nl\otherdata\Folder00\Extern maatwerk\nidio_spolis_year_2006_2023\nidio_spolis_year_2006_2023.dta", replace
		
	keep if year>=2011
	
	sort year rinpersoon
		
	// 2. Reduce to rinpersoon-year in NEA
	merge m:1 year rinpersoon using "${dNEA}/riny", keep(match) nogen
	
	*Create date variables
	gen y_start = year(job_start_caly)
	gen m_start = month(job_start_caly)
	gen y_end = year(job_end_caly)
	gen m_end = month(job_end_caly)
	
	drop job_start_caly job_end_caly baanrugid
	
	* Keep only jobs existing in the fourth quarter of the calendar year
	* (NEA survey is caaried out between October and December)
	keep if m_end>=10
	
	* Merge SBI from ABR
	merge m:1 year beid using "${dABR}/nidio_abr_ogbe_register_2006_2023", ///
		keep(master match) keepusing(be_SBI08) nogen
	
	save "${dNEA}/spolis_year_nea", replace
	
* --------------------------------------------------------------------------- */
* 3. MERGE NEA OCCUPATIONS WITH JOB IDS
* ---------------------------------------------------------------------------- *

	use "${dNEA}/nidio_nea_occ_2006_2023", replace
	
	// Merge 
	merge 1:m year rinpersoon using "${dNEA}/spolis_year_nea", nogen ///
		keepusing(beid slbaanid ft_factor mainjob be_SBI08)
		
	drop afl_sbi_2008
	
	sort year rinpersoon
	
	// Add trailing 0s to be_SBI08 & nea_SBI08 that are smaller than 5 digits
	local len = 5
	gen xdiff = 10 ^ (`len' - length(be_SBI08))
	
	gen be_sbi = real(be_SBI08) * xdiff
	drop xdiff
	
	local len = 5
	gen xdiff = 10 ^ (`len' - length(nea_SBI08))
	
	gen nea_sbi = real(nea_SBI08) * xdiff
	drop xdiff
	
	// IDENTIFY ONE UNIQUE JOB ID PER SURVEY OBSERVATION
	// Matching based on same SBI code in SPOLIS/ABR & NEA
	* Prepare data
	bys year rinpersoon: gen N = _N // Number of identified job IDs (within year-pers)
	gen x = 1 if (nea_sbi==be_sbi)
	bys year rinpersoon: egen y = count(x) // Number of matching SBI (within year-pers)
	bys year rinpersoon: egen maxft = max(ft_factor) // Largest FT factor (within year-pers)
	
	* Selection
	drop if (nea_sbi!=be_sbi) & N!=1 & y!=0 // 1. Remove all non-matching SBI (if at least 1 match & multijob)
	drop if maxf!=ft_factor & N!=1 & y==0 // 2. Remove all non-max FT factor (if no match & multijob)
	
	drop maxft
	bys year rinpersoon: egen maxft = max(ft_factor) // Largest FT factor (within remaining year-pers)
	drop if maxf!=ft_factor & N!=1 & y!=0 // 3. Remove all non-max FT factor (if at least one match & multijob)
	
	drop maxft y x N
	bys year rinpersoon: gen N = _N // Number of identified job IDs
	bys year rinpersoon: egen maxmj = max(mainjob) // Still includes mainjob
	
	drop if mainjob==0 & N!=1 & maxmj==1 // 4. Remove all non-main job (if mainjob in set & multijob)
	
	duplicates drop year rinpersoon, force // 5. Force drop remaining duplicates
	
	// Keep small set of variables
	keep year rinpersoon rin_weight_NEA rin_ISCO08 rin_neaocc beid slbaanid
	sort year rinpersoon
	
	// Save
	save "${dNEA}/nidio_nea_occ_job_total_2006_2023", replace
	
* --------------------------------------------------------------------------- */
* 4. GENERATE FILE WITH UNIQUE YEAR - JOB IDS
* ---------------------------------------------------------------------------- *

	* Generate file with unique year-slbaanid

	// Keep years with ISCO08 codes
	keep if year>=2011
	
	// Remove non-identified job cases
	drop if slbaanid==""
	
	// Keep reduced list of variables
	keep year rinpersoon rin_ISCO08 slbaanid
	
	// Drop value label of NEA ISCO08
	lab drop labels718
	
	// Order job ID
	order slbaanid, after(rinpersoon)
	
	// Source
	gen occ_source = "NEA"
	lab var occ_source "Data source of occupation code"
	
	// Save
	save "${dNEA}/nidio_nea_occ_job_unique_2006_2023", replace
	
	// Erase 
	erase "${dNEA}/riny.dta"
	erase "${dNEA}/spolis_year_nea.dta"
	erase "${dNEA}/nidio_nea_occ_2006_2023.dta"
	