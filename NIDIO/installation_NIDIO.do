/*=============================================================================* 
* INSTALLATION NIDIO 
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 02-12-2024
* ---------------------------------------------------------------------------- */

*** Run configuration file (from current file path)
	global wd `c(pwd)'
	do "${wd}/Code/config"
	
	source_nidio					// Overview of source data
	
	
*** Customizable Installation
	install_nidio ABR 				// Installs module ABR
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
	* (See NIDIO_datasets.xlsx for a complete overview of available NIDIO datasets)
	*--------------------------------------------------------------------------*
	
	* The user needs to specify one MODULE with the install_nidio command. 
	* NIDIO modules correspond to the data topics of the CBS microdata catalogue 
	* and need to be added to the project environment before installation.
	* The following modules are currently included in NIDIO:
	
	* ORGANIZATION LEVEL:
	* - ABR: Company register (4 datasets; 2.12 GB (total))
	* - NFO: Financial data (2 datasets; 668 MB (total))
	
	* PERSON LEVEL:
	* - EBB: Occupational codes via Dutch labor force survey (1 dataset; 144 MB)
	* - GBAPERSOONTAB: Demographic characteristics (1 dataset; 0.98 GB)
	* - HOOGSTEOPLTAB: Highest education (1 dataset; 5.61 GB)
	* - KINDOUDERTAB: Registered children of parents (1 dataset; 1.1 GB)
	* - NEA: Occupational codes via NEA (1 dataset; 15.3 MB)
	* - PARTNERBUS: Partnership (1 dataset; 644 MB)
	
	* JOB LEVEL:
	* - SPOLIS_MONTH: Jobs existing in September during reference year (1 dataset; 37.1 GB)
	* - SPOLIS_YEAR: All jobs existing during reference year (1 dataset;)
	
	*--------------------------------------------------------------------------*
	* Dependencies: SPOLIS is required for the installation of module 'ABR'.
	* 			 	ABR is required for the installation of module 'NFO'.
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
	
