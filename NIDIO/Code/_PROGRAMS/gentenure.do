/*=============================================================================* 
* PROGRAM - GENTENURE
*==============================================================================*
 	Project: Beyond Boardroom / NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 23-10-2024
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - GENTENURE computes a variable indicating the number of years a job has been 
*   in existence 
*
* Options:
* - dataformat: Specify data format of SPOLIS file (required).
*	'month'={SPOLIS month format}; 'year'={SPOLIS year format}
*
* - varformat: Unit of tenure variable (only possible with SPOLIS month format).
*	(required)
*	'month'={unit is month}; 'year'={unit is year}
*
* - generate: Specify name of computed variable (required).
*
* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *

program define gentenure
	syntax , DATAformat(string) GENerate(string) VARformat(string)
	
	* Header
		display as txt "GENTENURE"
		display as txt "--------------------------------------------------------"
		
	* Abort program if variable job_tenure or year is missing.
		quietly capture confirm variable year, exact
		if !_rc {
		
		}
		else {
			display as error "Variable year is not defined"
			exit(0)
		}
		*
	* Abort program if variable job_tenure is missing.
		quietly capture confirm variable job_tenure, exact
		if !_rc {
		
		}
		else {
			display as error "Variable job_tenure is not defined"
			exit(0)
		}
		*
		
	* Abort program if variable name specified in generate() is already defined
		quietly capture confirm variable `generate', exact
		if !_rc {
			display as error "Variable `generate' already defined"
			exit(0)
		}
		*
		
	* Compute tenure based on specified format
		if `"`dataformat'"'=="month" {
			if `"`varformat'"'=="month" {
				quietly gen _ty = year(job_tenure)
				quietly gen _tm = month(job_tenure)
				quietly gen _mstart = (_ty*12)+_tm
				quietly gen _mnow = (year*12)+9
				quietly gen `generate' = _mnow-_mstart
				quietly drop _ty _tm _mstart _mnow
				lab var `generate' "Number of elapsed months since job creation"
				display as res "Variable `generate' saved."
				display as txt "Unit = month"
				display as txt "Note: Start dates of jobs starting before 2006 and ending before 2013 are left-censored --> Missing."
			}
			else if `"`varformat'"'=="year" {
				quietly gen _ty = year(job_tenure)
				quietly gen _tm = month(job_tenure)
				gen `generate' = year-_ty
				quietly replace `generate' = `generate'-1 if _tm>=10 & _tm<=12 & _tm!=. & _ty!=.
				quietly drop _ty _tm
				lab var `generate' "Number of elapsed full years since job creation"
				display as res "Variable `generate' saved."
				display as txt "Unit = year"
				display as txt "Note: Start dates of jobs starting before 2006 and ending before 2013 are left-censored --> Missing"
			}
			else {
				display as error "Option varformat must be specified as either 'month' or 'year', if data format 'month' is chosen."
				exit(0)
			}
		}
		*
		
		else if `"`dataformat'"'=="year" {
			if `"`varformat'"'!="year" {
				display as error "Option varformat must be specified as 'year', if data format 'year' is chosen."
			}
			else {
				quietly gen _ty = year(job_tenure)
				quietly gen `generate' = year-_ty
				quietly drop _ty
				lab var `generate' "Number of elapsed calendar years since job creation"
				display as res "Variable `generate' saved."
				display as txt "Note: Start dates of jobs starting before 2006 and ending before 2013 are left-censored --> Missing"
			}
		}
		*

		else {
			display as error "Option dataformat must be specified as either 'month' or 'year'."
			exit(0)
		}

end
		