/*=============================================================================* 
* PROGRAM - INSTALL_NIDIO
*==============================================================================*
 	Project: Beyond Boardroom / NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 08-12-2025
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - INSTALL_NIDIO installs the NIDIO according to user-specified NIDIO modules.
*


* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *
capture program drop install_nidio
program define install_nidio
	syntax namelist(min=1 max=1)
	
	* Loading time warning
		display as txt "NIDIO INSTALLATION"
		display as txt "Caution: Long installation times due to heavy data processing."
		display as txt "--------------------------------------------------------------"
		
	* Install specified module
		if "`namelist'"=="ABR" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sSPOLIS}/dataprep_spolis_beid"
			quietly do "${sABR}/dataprep_ABR"
			display as txt "Installation of module '`namelist'' completed."
		}
		else if "`namelist'"=="BDK" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sBDK}/dataprep_BDK"
			quietly do "${sBDK}/dataprep_BDK_lbeid"
			display as txt "Installation of module '`namelist'' completed."
		}
		else if "`namelist'"=="NFO" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sNFO}/dataprep_NFO"
			display as txt "Installation of module '`namelist'' completed."
		}
		else if "`namelist'"=="SPOLIS_MONTH" {
			display as txt "Module '`namelist'' requested for installation."
			display as txt "Warning: ~36 hours installation time."
			quietly do "${sSPOLIS}/dataprep_spolis_month"
			display as txt "Installation of module '`namelist'' completed."
		}
		else if "`namelist'"=="SPOLIS_YEAR" {
			display as txt "Module '`namelist'' requested for installation."
			display as txt "Warning: ~4 days installation time."
			quietly do "${sSPOLIS}/dataprep_spolis_year"
			display as txt "Installation of module '`namelist'' completed." 
		}
		else if "`namelist'"=="GBA" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sGBA}/dataprep_GBAPERSOONTAB"
			display as txt "Installation of module '`namelist'' completed." 
		}
		else if "`namelist'"=="OPL" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sOPL}/dataprep_HOOGSTEOPLTAB"
			display as txt "Installation of module '`namelist'' completed." 
		}
		else if "`namelist'"=="KIND" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sKIND}/dataprep_KINDOUDERTAB"
			display as txt "Installation of module '`namelist'' completed." 
		}
		else if "`namelist'"=="PARTNER" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sPARTNER}/dataprep_PARTNERBUS"
			display as txt "Installation of module '`namelist'' completed." 
		}
		else if "`namelist'"=="EBB" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sEBB}/dataprep_EBB"
			quietly do "${sEBB}/dataprep_EBB_occ"
			display as txt "Installation of module '`namelist'' completed." 
		}
		else if "`namelist'"=="NEA" {
			display as txt "Module '`namelist'' requested for installation."
			quietly do "${sNEA}/dataprep_NEA"
			quietly do "${sNEA}/dataprep_NEA_occ"
			display as txt "Installation of module '`namelist'' completed." 
		}
		else {
			display as error "Module '`namelist'' unknown."
			display as error "See installation_NIDIO.do for list of available modules."
			exit(0)
		}
		*
		
end
