/*=============================================================================* 
* PROGRAM - GENRINPERSOONS
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 08-10-2024
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - GENRINPERSOONS restores the original rinpersoons variable in NIDIO datasets
*
* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *

program define genrinpersoons
	syntax

	* Header
		display as txt "GENRINPERSOONS"
		display as txt "--------------------------------------------------------"
		
	* Abort program if variable named rinpersoons is already defined
		quietly capture confirm variable rinpersoons, exact
		if !_rc {
			display as error "Variable rinpersoons already defined"
			exit(0)
		}
		*
		* Abort program if no rinpersoon identifier is not present
		quietly capture confirm variable rinpersoon, exact
		if _rc {
			display as error "Variable rinpersoon not defined"
			exit(0)
		}
		*
		
	* Compute rinperssons based on specified format
		gen rinpersoons = "R"
		order rinpersoons, before(rinpersoon)
		display as res "Variable rinpersoons saved."

end
		