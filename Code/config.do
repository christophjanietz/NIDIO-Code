/*=============================================================================* 
* CONFIGURATIONS - FILE DIRECTORY 
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 23-10-2024
* ---------------------------------------------------------------------------- */

* This do-file has the following purpose:
* - Establish the path structure within the NIDIO folder.
* - Identify and locate the source data in the CBS microdata RA environment.
* - Install the user-written NIDIO Stata commands.

*** General settings
	version 16
	set more off, perm 
	cap log close
	set seed 12345
	set scheme plotplain, perm
	set matsize 11000, perm 
	set maxvar 32767, perm
	matrix drop _all

*** Create and set paths to data folders
	// create folders
	capture mkdir "${wd}/Data"
	foreach module in ABR NFO EBB NEA GBAPERSOONTAB HOOGSTEOPLTAB ///
	KINDOUDERTAB PARTNERBUS SPOLISBUS {
		capture mkdir "${wd}/Data/`module'"
	}
	*

	// path to folders 
	global ddir 		"${wd}/Data"				// Data Working Directory
	global dABR			"${ddir}/ABR" 				// Company register (company)
	global dNFO			"${ddir}/NFO"	  			// Financial data (company)
	global dEBB 		"${ddir}/EBB"				// Labor force survey (individual)
	global dNEA			"${ddir}/NEA"				// Employment conditions survey (indivdiual)
	global dGBA			"${ddir}/GBAPERSOONTAB"	  	// Personal Records database (individual)
	global dOPL			"${ddir}/HOOGSTEOPLTAB"  	// Education (individual)
	global dKIND		"${ddir}/KINDOUDERTAB"	  	// Children (individual)
	global dPARTNER		"${ddir}/PARTNERBUS"	  	// Partner (individual)
	global dSPOLIS		"${ddir}/SPOLISBUS"	  		// SPOLIS (job)

*** Set paths to code folders
	// path to folders 	
	global sdir 		"${wd}/Code"				// Code Working Directory
	global sABR			"${sdir}/ABR" 				// Company register (company)
	global sNFO			"${sdir}/NFO"	  			// Financial data (company)
	global sEBB 		"${sdir}/EBB"				// Labor force survey (individual)
	global sNEA			"${sdir}/NEA"				// Employment conditions survey (indivdiual)
	global sGBA			"${sdir}/GBAPERSOONTAB"	  	// Personal Records database (individual)
	global sOPL			"${sdir}/HOOGSTEOPLTAB"  	// Education (individual)
	global sKIND		"${sdir}/KINDOUDERTAB"		// Children (individual)
	global sPARTNER		"${sdir}/PARTNERBUS"	  	// Partner (individual)
	global sSPOLIS		"${sdir}/SPOLISBUS"	  		// SPOLIS (job)
	
	// NIDIO Stata commands
	do "${sdir}/_PROGRAMS/_master"
	
	// CPI data
	do "${sdir}/_AUXILIARY/CPI/CPI"

***	Locating source data
	
	*ABR_OG
	// Register OG
	foreach year of num 2006/2013 {
	   local abr_OG`year': dir "G:/Bedrijven/ABR/`year'/" files "* OG_ABR `year'V*.sav"
	   global abr_OG`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG`year''
	}
	*
	foreach year of num 2014 {
	   local abr_OG`year': dir "G:/Bedrijven/ABR/`year'/" files "OG_ABR `year'V*.sav"
	   global abr_OG`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG`year''
	}
	*
	foreach year of num 2015/2020 {
	   local abr_OG`year': dir "G:/Bedrijven/ABR/`year'/" files "OG_ABR`year'V*.sav"
	   global abr_OG`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_OG`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_OG`year'V*.sav"
	   global abr_OG`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG`year''
	}
	*
	
	*ABR_OG_EVENTBIJDRAGEN
	// OG Events
	foreach year of num 2006/2013 {
	   local abr_OG_event`year': dir "G:/Bedrijven/ABR/`year'/" files "* OG_eventbijdragen_ABR `year'V*.sav"
	   global abr_OG_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_event`year''
	}
	*
	foreach year of num 2014 {
	   local abr_OG_event`year': dir "G:/Bedrijven/ABR/`year'/" files "OG_eventbijdragen_ABR `year'V*.sav"
	   global abr_OG_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_event`year''
	}
	*
	foreach year of num 2015/2020 {
	   local abr_OG_event`year': dir "G:/Bedrijven/ABR/`year'/" files "OG_eventbijdragen_ABR`year'V*.sav"
	   global abr_OG_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_event`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_OG_event`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_OG_evenbijdragen`year'V*.sav"
	   global abr_OG_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_event`year''
	}
	*
	
	*ABR_OG_PERSOON
	// Link OG <-> KERNPERSOON
	foreach year of num 2006/2013 {
	   local abr_OG_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "* OG_persoon_ABR `year'V*.sav"
	   global abr_OG_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_pers`year''
	}
	*
	foreach year of num 2014 {
	   local abr_OG_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "OG_persoon_ABR `year'V*.sav"
	   global abr_OG_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_pers`year''
	}
	*
	foreach year of num 2015/2020 {
	   local abr_OG_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "OG_persoon_ABR`year'V*.sav"
	   global abr_OG_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_pers`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_OG_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_OG_PERSOON`year'V*.sav"
	   global abr_OG_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_pers`year''
	}
	*
	
	*ABR_OG_BE
	// Link OG <-> BE
	foreach year of num 2006/2013 {
	   local abr_OG_BE`year': dir "G:/Bedrijven/ABR/`year'/" files "* BE_OG_ABR `year'V*.sav"
	   global abr_OG_BE`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_BE`year''
	}
	*
	foreach year of num 2014 {
	   local abr_OG_BE`year': dir "G:/Bedrijven/ABR/`year'/" files "BE_OG_ABR `year'V*.sav"
	   global abr_OG_BE`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_BE`year''
	}
	*
	foreach year of num 2015/2020 {
	   local abr_OG_BE`year': dir "G:/Bedrijven/ABR/`year'/" files "BE_OG_ABR`year'V*.sav"
	   global abr_OG_BE`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_BE`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_OG_BE`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_BE_OG`year'V*.sav"
	   global abr_OG_BE`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_OG_BE`year''
	}
	*
	
	*ABR_BE
	// Register BE (including size; legal form; industry)
	foreach year of num 2006/2020 {
	   local abr_BE`year': dir "G:/Bedrijven/ABR/`year'/" files "BE_ABR`year'V*.sav"
	   global abr_BE`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_BE`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_BE`year'V*.sav"
	   global abr_BE`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE`year''
	}
	*
	
	*ABR_BE_EVENTBIJDRAGEN
	// BE Events
	foreach year of num 2006/2013 {
	   local abr_BE_event`year': dir "G:/Bedrijven/ABR/`year'/" files "* BE_eventbijdragen_ABR `year'V*.sav"
	   global abr_BE_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_event`year''
	}
	*
	foreach year of num 2014 {
	   local abr_BE_event`year': dir "G:/Bedrijven/ABR/`year'/" files "BE_eventbijdragen_ABR `year'V*.sav"
	   global abr_BE_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_event`year''
	}
	*
	foreach year of num 2015/2020 {
	   local abr_BE_event`year': dir "G:/Bedrijven/ABR/`year'/" files "BE_eventbijdragen_ABR`year'V*.sav"
	   global abr_BE_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_event`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_BE_event`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_BE_EVENTBIJDRAGEN`year'V*.sav"
	   global abr_BE_event`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_event`year''
	}
	*
	
	*ABR_BE_PERSOON
	// Link BE <-> KERNPERSOON
	foreach year of num 2006/2013 {
	   local abr_BE_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "* BE_persoon_ABR `year'V*.sav"
	   global abr_BE_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_pers`year''
	}
	*
	foreach year of num 2014 {
	   local abr_BE_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "BE_persoon_ABR `year'V*.sav"
	   global abr_BE_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_pers`year''
	}
	*
	foreach year of num 2015/2020 {
	   local abr_BE_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "BE_persoon_ABR`year'V*.sav"
	   global abr_BE_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_pers`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_BE_pers`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_BE_PERSOON`year'V*.sav"
	   global abr_BE_pers`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_BE_pers`year''
	}
	*
	
	*ABR_CBS_PERSOON_KVK
	// Link KERNPERSOON <-> KVK Number
	foreach year of num 2006/2008 {
	   local abr_CBS_KVK`year': dir "G:/Bedrijven/ABR/`year'/" files "CBS_persoon_ABR`year'V*.sav"
	   global abr_CBS_KVK`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_CBS_KVK`year''
	}
	*
	foreach year of num 2009/2020 {
	   local abr_CBS_KVK`year': dir "G:/Bedrijven/ABR/`year'/" files "CBS_persoon_KvK_FIN_ABR`year'V*.sav"
	   global abr_CBS_KVK`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_CBS_KVK`year''
	}
	*
	foreach year of num 2021/2023 {
	   local abr_CBS_KVK`year': dir "G:/Bedrijven/ABR/`year'/" files "ABR_CBS_persoon_KvK_FIN`year'V*.sav"
	   global abr_CBS_KVK`year' =  "G:/Bedrijven/ABR/`year'/" + `abr_CBS_KVK`year''
	}
	*
	
	*NFO
	foreach year of num 2006/2022 {
	   local nfo`year': dir "G:/Bedrijven/NFO/" files "NFO`year'V*.sav"
	   global nfo`year' = "G:/Bedrijven/NFO/" + `nfo`year''
	}
	*
	
	*EBB
	foreach year of num 2006/2023 {
	   local ebbnw`year': dir "G:/Arbeid/EBBnw/" files "EBBnw`year'V*.sav"
	   global ebbnw`year' =  "G:/Arbeid/EBBnw/" + `ebbnw`year''
	}
	*
	
	*NEA
	local nea0513: dir "G:/Arbeid/NEA/" files "NEA2005_2013V*.sav"
	global nea0513 = "G:/Arbeid/NEA/" + `nea0513'
	local nea1422: dir "G:/Arbeid/NEA/" files "NEA2014-2022V*.sav"
	global nea1422 = "G:/Arbeid/NEA/" + `nea1422'
	
	*GBAPERSOONTAB
	local GBAPERSOON2009: dir "G:/Bevolking/GBAPERSOONTAB/2009/" files "GBAPERSOON2009TABV*.sav"
	global GBAPERSOON2009 = "G:/Bevolking/GBAPERSOONTAB/2009/" + `GBAPERSOON2009'
	
	local GBAPERSOON2023: dir "G:/Bevolking/GBAPERSOONTAB/2023/" files "GBAPERSOON2023TABV*.sav"
	global GBAPERSOON2023 = "G:/Bevolking/GBAPERSOONTAB/2023/" + `GBAPERSOON2023'
	
	*HOOGSTEOPLTAB
	// (Use .dta file format)
	foreach year of num 2006/2012 {
	   local opl`year': dir "G:/Onderwijs/HOOGSTEOPLTAB/`year'/geconverteerde data/" ///
			files "* HOOGSTEOPLTAB `year'V*.dta"
	   global opl`year' =  "G:/Onderwijs/HOOGSTEOPLTAB/`year'/geconverteerde data/" + `opl`year''
	}
	*
	foreach year of num 2013/2019 2021 2023 {
	   capture local opl`year': dir "G:/Onderwijs/HOOGSTEOPLTAB/`year'/geconverteerde data/" ///
			files "HOOGSTEOPL`year'TABV*.dta"
	   capture global opl`year' =  "G:/Onderwijs/HOOGSTEOPLTAB/`year'/geconverteerde data/" + `opl`year''
	}
	*
	capture global opl2020 "G:/Onderwijs/HOOGSTEOPLTAB/2020/geconverteerde data/HOOGSTEOPL2020TABV2.dta"
	capture global opl2022 "G:/Onderwijs/HOOGSTEOPLTAB/2022/geconverteerde data/HOOGSTEOPL2022TABV2.dta"
	
	*KINDOUDERTAB
	local kindouder2023: dir "G:/Bevolking/KINDOUDERTAB/" files "KINDOUDER2023TABV*.sav"
	global kindouder2023 = "G:/Bevolking/KINDOUDERTAB/" + `kindouder2023'
	
	*PARTNERBUS
	foreach year of num 2010/2013 {
	   local partner`year': dir "G:/Bevolking/PARTNERBUS/`year'/" files "*PARTNERBUS `year'V*.sav"
	   global partner`year' =  "G:/Bevolking/PARTNERBUS/`year'/" + `partner`year''
	}
	*
	foreach year of num 2014 {
	   local partner`year': dir "G:/Bevolking/PARTNERBUS/`year'/" files "PARTNERBUS `year'V*.sav"
	   global partner`year' =  "G:/Bevolking/PARTNERBUS/`year'/" + `partner`year''
	}
	*
	foreach year of num 2015/2023 {
	   local partner`year': dir "G:/Bevolking/PARTNERBUS/`year'/" files "PARTNER`year'BUSV*.sav"
	   global partner`year' =  "G:/Bevolking/PARTNERBUS/`year'/" + `partner`year''
	}
	*
	
	*(S)POLIS
	// (Use .dta format for (S)POLIS to be able to drop variables while loading 
	// datasets.)
	foreach year of num 2006/2009 {
	   local polis`year': dir "G:/Polis/POLISBUS/`year'/geconverteerde data/" files "POLISBUS`year'V*.dta"
	   global polis`year' =  "G:/Polis/POLISBUS/`year'/geconverteerde data/" + `polis`year''
	}
	*
	foreach year of num 2010/2013 2016/2024 {
	   local spolis`year': dir "G:/Spolis/SPOLISBUS/`year'/geconverteerde data/" files "SPOLISBUS`year'V*.dta"
	   global spolis`year' =  "G:/Spolis/SPOLISBUS/`year'/geconverteerde data/" + `spolis`year''
	}
	*
	foreach year of num 2014/2015 {
	   local spolis`year': dir "G:/Spolis/SPOLISBUS/`year'/geconverteerde data/" files "SPOLISBUS `year'V*.dta"
	   global spolis`year' =  "G:/Spolis/SPOLISBUS/`year'/geconverteerde data/" + `spolis`year''
	}
	*
	
	local polis_long: dir "G:/Polis/POLISLONGBAANTAB/" files "POLISLONGBAANTABV*.sav"
	global polis_long = "G:/Polis/POLISLONGBAANTAB/" + `polis_long'

	local spolis_long: dir "G:/Spolis/SPOLISLONGBAANTAB/" files "SPOLISLONGBAANTABV*.sav"
	global spolis_long = "G:/Spolis/SPOLISLONGBAANTAB/" + `spolis_long'
	
	*(S)POLIS: Mainjob
	foreach year of num 2006/2009 {
	   local mainjob`year': dir "G:/Polis/POLISHOOFDBAANBUS/`year'/" files "POLISHOOFDBAANBUS `year'V*.sav"
	   global mainjob`year' =  "G:/Polis/POLISHOOFDBAANBUS/`year'/" + `mainjob`year''
	}
	*
	foreach year of num 2010/2023 {
	   local mainjob`year': dir "G:/Spolis/SPOLISHOOFDBAANBUS/" files "SPOLISHOOFDBAAN`year'BUSV*.sav"
	   global mainjob`year' =  "G:/Spolis/SPOLISHOOFDBAANBUS/" + `mainjob`year''
	}
	*

	// Auxiliary files
	capture mkdir "${sdir}/_AUXILIARY/EDU"
	local OPLNR: dir "K:/Utilities/Code_Listings/SSBreferentiebestanden/geconverteerde data/" ///
		files "OPLEIDINGSNRREFV*.dta"
	global OPLNR = "K:/Utilities/Code_Listings/SSBreferentiebestanden/geconverteerde data/" + `OPLNR'
	
	local CTO: dir "K:/Utilities/Code_Listings/SSBreferentiebestanden/geconverteerde data/" ///
		files "CTOREFV*.dta"
	global CTO = "K:/Utilities/Code_Listings/SSBreferentiebestanden/geconverteerde data/" + `CTO'
	
	local CNTRY: dir "K:/Utilities/Code_Listings/SSBreferentiebestanden/geconverteerde data/" ///
		files "LANDAKTUEELREFV*.dta"
	global CNTRY = "K:/Utilities/Code_Listings/SSBreferentiebestanden/geconverteerde data/" + `CNTRY'
	
	global cntry_nidio "${sdir}/_AUXILIARY/Country_codes/wrldrgn_nidio.dta"
	global CPI "${sdir}/_AUXILIARY/CPI/CPI.dta"
	global CPI_month "${sdir}/_AUXILIARY/CPI/CPI_month.dta"