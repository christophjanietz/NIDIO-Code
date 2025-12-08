/*=============================================================================* 
* PROGRAM - SPOLISSELECT
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl) / Zoltán Lippényi
	Last update: 08-12-2025
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - SPOLISSELECT loads a specified selection of the SPOLIS dataset
*
* Options:
* - dataformat: Specify data format of used SPOLIS file (required)
*	'month'={SPOLIS month format}; 'year'={SPOLIS year format}
*
* - start (default: 2006): specify starting year.
*
* - end (default: 2024): specify ending year. 
*
* - jobtype (default: 1): select specific types of jobs.
*	1={all jobs}; 2={temp, oncall, standard jobs}; 3={only standard jobs}
*
* - mainjob(default: 0): select mainjobs, if requested.
*	0={all jobs}; 1={only mainjobs}
*

*26-2: added option to define varlist. The syntax requires year and ///
		sortbaan/mainjob if these options are specified


* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *
capture program drop spolisselect
program define spolisselect
	syntax [namelist], DATAformat(string) [start(integer 2006) end(integer 2024) ///
		jobtype(integer 1) mainjob(integer 0)]
	
	* Loading time warning
		display as txt "SPOLISSELECT"
		display as txt "Caution: Long loading time due to large file size."
		display as txt "Waiting time is reduced by requesting shorter year range."
		display as txt "Otherwise, sit back and enjoy a cup of tea."
		display as txt "--------------------------------------------------------"
		
	* Load specified dataset form with specified year range
	* (options: DATAformat (required); start; end)
		if `"`dataformat'"'=="month" {
			quietly use `namelist' if year>=`start' & year<=`end' using ///
				"${dSPOLIS}/nidio_spolis_month_2006_2024", replace
			quietly count
			local n_tot = r(N)
			display as txt "Month data format (jobs in September) selected."
			display as txt "Selected time period: `start' to `end'."
			display as txt "Number of initial observations: " as res r(N)
			display as txt "--------------------------------------------------------"
		}
		else if `"`dataformat'"'=="year" {
			quietly use `namelist' if year>=`start' & year<=`end' using ///
				"${dSPOLIS}/nidio_spolis_year_2006_2024", replace
			quietly count
			local n_tot = r(N)
			display as txt "Year data format selected."
			display as txt "Selected time period: `start' to `end'."
			display as txt "Number of initial observations: " as res r(N)
			display as txt "--------------------------------------------------------"
		}
		else {
			display as error "Data format must be specified as either 'month' or 'year'."
			exit(0)
		}
	
	* Select jobtype if specified (option: jobtype)
		if `jobtype'==1 {
			quietly count
			display as txt "All job types selected."
			display as txt "Number of observations: " as res r(N) " of `n_tot' | 100%"
			display as txt "--------------------------------------------------------"
		}
		else if `jobtype'==2 {
			quietly keep if ssoortbaan>=4 & ssoortbaan!=.
		    quietly count
			display as txt "Temp agency, on-call, and standard jobs selected."
			display as txt "Number of observations: " as res r(N) " of `n_tot' | " ///
				round((r(N)/`n_tot')*100,.01) "%"
			display as txt "--------------------------------------------------------"
		}
		else if `jobtype'==3 {
			quietly keep if ssoortbaan==9
		    quietly count
			display as txt "Standard jobs selected."
			display as txt "Number of observations: " as res r(N) " of `n_tot' | " ///
				round((r(N)/`n_tot')*100,.01) "%"
			display as txt "--------------------------------------------------------"
		}
		else {
			quietly count
			display as txt "All job types selected."
			display as txt "Number of observations: " as res r(N) " of `n_tot' | 100%"
			display as txt "--------------------------------------------------------"
		}
		*

	* Select mainjobs if specified (option: mainjob)
		if `mainjob'!=0 {
			quietly keep if mainjob==1
			quietly count
			display as txt "Mainjobs selected."
			display as txt "Number of observations: " as res r(N) " of `n_tot' | " ///
				round((r(N)/`n_tot')*100,.01) "%"
			display as txt "--------------------------------------------------------"
		}
		else {
			quietly count
		    display as txt "All jobs (main jobs & other jobs) selected."
			display as txt "Number of observations: " as res r(N) " of `n_tot' | 100%"
			display as txt "--------------------------------------------------------"
		}
	* End notification
		display as txt "SPOLIS data successfully loaded!"
end

