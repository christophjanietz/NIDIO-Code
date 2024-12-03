/*=============================================================================* 
* PROGRAM - MASTER 
*==============================================================================*
 	Project: NIDIO
	Last update: 23-10-2024
* ---------------------------------------------------------------------------- */

*** Run NIDIO Stata command files

	// Installation NIDIO
	capture do "${sdir}/_PROGRAMS/install_nidio" // CJ
	capture do "${sdir}/_PROGRAMS/labels_nidio" // CJ
	capture do "${sdir}/_PROGRAMS/source_nidio" // CJ
	
	// Merging and combining NIDIO files
	capture do "${sdir}/_PROGRAMS/partnerbusmatch" // ZL 
	
	// Selecting observations in NIDIO files
	capture do "${sdir}/_PROGRAMS/spolisselect" // CJ
	capture do "${sdir}/_PROGRAMS/orgsizeselect" // CJ
	
	// Generating variables in NIDIO files
	capture do "${sdir}/_PROGRAMS/gentenure" // CJ
	capture do "${sdir}/_PROGRAMS/genhwage" // CJ
	capture do "${sdir}/_PROGRAMS/genrinpersoons" // CJ
	