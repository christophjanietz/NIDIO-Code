/*=============================================================================* 
* PROGRAM - SOURCE_NIDIO
*==============================================================================*
 	Project: Beyond Boardroom / NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 09-04-2025
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - SOURCE_NIDIO gives an overview of all filepaths of current NIDIO source data.
*


* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *
capture program drop source_nidio
program define source_nidio
	syntax 
	
	* Header
		display as result "Overview of SOURCE DATA"
		display as txt "--------------------------------------------------------------"
	* ABR 
		display as result "ABR-OG:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_OG`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
		display as result "*ABR-OG-EVENTS:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_OG_event`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
		display as result "*ABR-OG-PERSON:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_OG_pers`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
		display as result "*ABR-OG-BE:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_OG_BE`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
		display as result "*ABR-BE:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_BE`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
		display as result "*ABR-BE-EVENTS:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_BE_event`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
		display as result "*ABR-BE-PERSON:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_BE_pers`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
		display as result "*ABR-CBS-PERSON-KVK:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${abr_CBS_KVK`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
	* BDK
		display as result "BDK:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2007/2023 {
				display as txt "`year': ${bdk`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
	* NFO
		display as result "NFO:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${nfo`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
	* EBB
		display as result "EBBnw:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${ebbnw`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
	* GBA
		display as result "GBAPERSOONTAB:"
		display as txt "--------------------------------------------------------------"
		display as txt "2023: ${GBAPERSOON2023}"
		display as txt "--------------------------------------------------------------"
	* OPL
		display as result "HOOGSTEOPLTAB:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2023 {
				display as txt "`year': ${opl`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
	*KIND
		display as result "KINDOUDERTAB:"
		display as txt "--------------------------------------------------------------"
		display as txt "2023: ${kindouder2023}"
		display as txt "--------------------------------------------------------------"
	* NEA 
		display as result "NEA:"
		display as txt "--------------------------------------------------------------"
		display as txt "2005-2013: ${nea0513}"
		display as txt "2014-2023: ${nea1423}"
		display as txt "--------------------------------------------------------------"
	* PARTNER
		display as result "PARTNERBUS:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2010/2023 {
				display as txt "`year': ${partner`year'}"
				display as txt "---"
			}
		display as txt "--------------------------------------------------------------"
	* POLIS
		display as result "POLIS:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2006/2009 {
				display as txt "`year': ${polis`year'}"
				display as txt "`year': ${mainjob`year'}"
				display as txt "---"
			}
		display as txt "polis_long: ${polis_long}"
		display as txt "--------------------------------------------------------------"
	* SPOLIS
		display as result "SPOLIS:"
		display as txt "--------------------------------------------------------------"
			foreach year of num 2010/2023 {
				display as txt "`year': ${spolis`year'}"
				display as txt "`year': ${mainjob`year'}"
				display as txt "---"
			}
		display as txt "spolis_long: ${spolis_long}"
		display as txt "--------------------------------------------------------------"
		
	
		
end