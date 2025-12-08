/*=============================================================================* 
* INSTALLATION NIDIO 
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 08-12-2025
* ---------------------------------------------------------------------------- */

*** Run configuration file (from current file path)
	global wd `c(pwd)'
	do "${wd}/Code/config"
	
	source_nidio					// Overview of source data
	
	
*** Customizable Installation
	install_nidio ABR 				// Installs module ABR
	install_nidio BDK 				// Installs module BDK
	install_nidio NFO				// Installs module NFO
	
	install_nidio EBB 				// Installs module EBB
	install_nidio GBA 				// Installs module GBAPERSOONTAB
	install_nidio OPL				// Installs module HOOGSTEOPLTAB
	install_nidio KIND 				// Installs module KINDOUDERTAB
	install_nidio NEA				// Installs module NEA
	install_nidio PARTNER			// Installs module PARTNERBUS
	
	install_nidio SPOLIS_MONTH		// Installs module SPOLIS/MONTH Version
	install_nidio SPOLIS_YEAR		// Installs module SPOLIS/YEAR Version
	
	*--------------------------------------------------------------------------*
	* The command installation_nidio will process CBS source data and generate 
	* NIDIO datasets in the folder "Data".
	* (See the NIDIO manual for a complete overview of available NIDIO datasets)
	*--------------------------------------------------------------------------*
	
	* The user needs to specify one MODULE with the install_nidio command. 
	* NIDIO modules correspond to the data topics of the CBS microdata catalogue 
	* and need to be added to the project environment before installation.
	* The following modules are currently included in NIDIO:
	
	* ORGANIZATION LEVEL:
	* - ABR: Company register (5 datasets; 3.56 GB (total))
	* - BDK: Company demography (2 datasets; 1.90 GB (total))
	* - NFO: Financial data (2 datasets; 728 MB (total))
	
	* PERSON LEVEL:
	* - EBB: Occupational codes via Dutch labor force survey (2 datasets; 573 MB (total))
	* - GBAPERSOONTAB: Demographic characteristics (1 dataset; 1.00 GB)
	* - HOOGSTEOPLTAB: Highest education (1 dataset; 6.43 GB)
	* - KINDOUDERTAB: Registered children of parents (1 dataset; 1.12 GB)
	* - NEA: Occupational codes via NEA (2 datasets; 93.4 MB (total))
	* - PARTNERBUS: Partnership (1 dataset; 660 MB)
	
	* JOB LEVEL:
	* - SPOLIS_MONTH: Jobs existing in September during reference year (1 dataset; 38.7 GB)
	* - SPOLIS_YEAR: All jobs existing during reference year (1 dataset; 50.8 GB)
	
	*--------------------------------------------------------------------------*
	* Dependencies: SPOLIS is required for the installation of module 'ABR'.
	* 			 	ABR is required for the installation of module 'NFO'.
	*				SPOLIS is required for the installation of module 'EBB'.
	*				SPOLIS & ABR are required for the installation of module 'NEA'.
	*			 	GBA is required for the installation of module 'KIND'.
	*--------------------------------------------------------------------------*
	* Important:
	* - NIDIO always processes the current version of available CBS source data.
	*   It is recommended to record the version number of source data for the 
	*   purpose of replicability. The command 'source_nidio' lists all file paths. 
	* - NIDIO defines the population of organizations as 'employers'. Organization 
	*   IDs (BEID) without at least one job-level observation in SPOLIS are 
	*   excluded during data processing.
	*--------------------------------------------------------------------------*
