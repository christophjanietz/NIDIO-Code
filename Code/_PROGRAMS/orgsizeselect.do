/*=============================================================================* 
* PROGRAM - ORGSIZESELECT
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 26-02-2024
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - ORGSIZESELECT restricts the data to a specified selection of organizations
*   based on size (measured by the number of employees).
*
* Options:
* - id: select organization ID (required)
*	{beid} or {ogid}
*
* - min (default: 1): specify minimum organization size.
*
* - max (default: 999999): specify maximum organization size. 
*
* - N_org (default: 0): create variable 'N_org' holding organization size as integer.
*   0={no}; 1={yes}
*
* - select (default: 0): Reduce dataset to selected organizations.
*   0={no}; 1={yes}
*
* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *


program define orgsizeselect
	syntax , id(string) [min(integer 1) max(integer 999999) select(integer 0) ///
		n_org(integer 0)]
	
	* Header
		display as txt "ORGSIZESELECT"
		display as txt "--------------------------------------------------------"
		
	* Abort program if variable N_org is already defined
		quietly capture confirm variable N_org, exact
		if !_rc {
			display as error "Variable N_org already defined"
			exit(0)
		}
		*
		
	* Select data based on specified options
		if `"`id'"'=="ogid" {
		    * Before selection
			quietly gunique ogid
			local N_before = r(J)
			local n_before = r(N)
			* Generate size variable
			quietly bys ogid: gen N_org = _N
			quietly lab var N_org "Number of job observations within organization (ogid)"
			* Display unique cases after selection 
			quietly gunique ogid if N_org>=`min' & N_org<=`max' 
			display as txt "Selected organization size: `min' to `max'."
			display as txt "Resulting number of organizations: " as res ///
				r(J) " of `N_before' OG IDs | " round((r(J)/`N_before')*100,.01) "%"
			display as txt "Resulting number of job observations: " as res ///
				r(N) " of `n_before' | " round((r(N)/`n_before')*100,.01) "%"
			display as txt "--------------------------------------------------------"
		}
		else if `"`id'"'=="beid" {
		    * Before selection
			quietly gunique beid
			local N_before = r(J)
			local n_before = r(N)
			* Generate size variable
			quietly bys beid: gen N_org = _N
			quietly lab var N_org "Number of job observations within organization (beid)"
			* Display unique cases after selection 
			quietly gunique beid if N_org>=`min' & N_org<=`max' 
			display as txt "Selected organization size: `min' to `max'."
			display as txt "Resulting number of organizations: " as res ///
				r(J) " of `N_before' BE IDs | " round((r(J)/`N_before')*100,.01) "%"
			display as txt "Resulting number of job observations: " as res ///
				r(N) " of `n_before' | " round((r(N)/`n_before')*100,.01) "%"
			display as txt "--------------------------------------------------------"
		}
		else {
			display as error "ID must be either 'beid' or 'ogid'."
			exit(0)
		}
		
	* Selection
		if `select'==1 {
			keep if N_org>=`min' & N_org<=`max' 
			display as res "Selection applied."
			display as txt "--------------------------------------------------------"
		}
		else {
			display as txt "Selection not applied."
			display as txt "--------------------------------------------------------"
		}
		
	* Variable N_org
		if `n_org'==1 {
			display as txt "Variable N_org saved."
		}
		else {
		    quietly drop N_org
		}
end
				