/*=============================================================================* 
* DATA PREPARATION - PARTNERBUS
*==============================================================================*
 	Project: NIDIO
	Author: Zoltán Lippényi / Christoph Janietz
	Last update: 08-12-2025
* ---------------------------------------------------------------------------- *

	INDEX: 
		0.  SETTINGS 
		1. 	PARTNERSHIP REGISTER
		
* Short description of output:
*
* nidio_partnersbus_rin_allyears:
* - partnership file identifying cohabitating partners and the period of 
*	cohabitation (also including non-romantic partnerships). 
*

	
* --------------------------------------------------------------------------- */
* 0. SETTINGS 
* ---------------------------------------------------------------------------- * 
	
*** Settings - Years to trace relationship. Earliest year: 1995.
	global partner_firstyear = 2006
	global partner_lastyear = 2024
	
* --------------------------------------------------------------------------- */
* 1. PARTNERSHIP REGISTER
* ---------------------------------------------------------------------------- *

	import spss using "${partner2024}", case(lower) clear

	// Convert date variables to Stata date format
	gen partnership_start = date(aanvangpartner,"YMD")
	format partnership_start %d
	gen partnership_end = date(eindepartner,"YMD")
	format partnership_end %d
	

	// Keep necessary variables
	keep rinpersoon rinpersoonp partnership_start partnership_end
	
	// Labeling
	labels_nidio, module(partner)


	// Save relationship file
	save "${dPARTNER}/nidio_partnerbus_rin_allyears.dta", replace
	
	clear
