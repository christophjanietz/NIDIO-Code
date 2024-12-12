/*=============================================================================* 
* PROGRAM - LABELS_NIDIO
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz (c.janietz@rug.nl)
	Last update: 02-12-2024
* ---------------------------------------------------------------------------- *

	INDEX:  
		1. 	PROGRAM DEFINTION
		
* Short description of program:
*
* - LABELS_NIDIO assigns variable and value labels to NIDIO files.
*
* Options:
* - module: Specify name of module (required).
*   AVAILABLE = ABR; EBB; GBA; KIND; NEA; NFO; OPL; PARTNER; SPOLIS
*
* --------------------------------------------------------------------------- */
* 1. PROGRAM DEFINTION
* ---------------------------------------------------------------------------- *


program define labels_nidio
	syntax , [MODule(string)]
	
	* Header
		display as txt "LABELS_NIDIO"
		display as txt "--------------------------------------------------------"
		display as txt "Selected module: `module'"
		
	* ABR
		if `"`module'"'=="abr" {
			// Variable labels
			capture lab var year "Calendar year"
	
			capture lab var ogid "OG ID"
			capture lab var og_sectorcode "Coordinated sector code of OG"
			capture lab var og_sector "Harmonized and simplified sector code"
			capture lab var og_ownership "OG ownership (non-financial firms & financial institutions)"
			capture lab var og_nrofvep "Number of CBS persoonen attached to OG"
			capture lab var og_employees "Number of employees in calendar year (aggregated from BE level)"
			capture lab var og_start "Start of OG observation (since 01-07-2005)"
			capture lab var og_end "End of OG observation in calendar year (if applicable)"
	
			capture lab var beid "BE ID"
			capture lab var be_start "Start of BE observation (since 01-07-2005)"
			capture lab var be_end "End of BE observation in calendar year (if applicable)"
	
			capture lab var be_SBI93 "Industry classification (SBI93) of BE"
			capture lab var be_SBI08 "Industry classification (SBI08) of BE"
			capture lab var be_industry "Harmonized industry categories (1st digit of SBI08) of BE"
			capture lab var be_gksbs "Organization size of BE"
			capture lab var be_employees "Number of employees"
			capture lab var be_lbe "Number of establishments within BE"
			capture lab var be_municipality_code "Municipality code (based on postcode)"
	
			capture lab var vepid "CBS Persoon ID (Kernpersoon BE)"
			capture lab var vep_rechtsvormcode "Legal form (via CBS kernpersoon) of BE"
			capture lab var vep_legalform "Harmonized and simplified legal form"
			capture lab var vep_postcode_crypt "Postcode encrypted"
	
			capture lab var ogbe_start "Start of OG-BE link (since 01-07-2005)"
			capture lab var ogbe_end "End of OG-BE link in calendar year (if applicable)"
			capture lab var ogbe_start_event "Event associated with start of OG-BE link"
			capture lab var ogbe_end_event "Event associated with end of OG-BE link"
			capture lab var ogbe_interruption "Within-year break of OG-BE link"
	
			capture lab var ogvep_start "Start of OG-VEP link (since 01-07-2005)"
			capture lab var ogvep_end "End of OG-VEP link in calendar year (if applicable)"
			capture lab var ogvep_interruption "Within-year break of OG-VEP link"
	
			capture lab var kvkid "Encrypted KVK dossier number"
			capture lab var finr "Encrypted fiscal ID"
			capture lab var vepkvk_start "Start of VEP-KVK link (since 01-07-2005)"
			capture lab var vepkvk_end "End of VEP-KVK link in calendar year (if applicable)"
	
			// Value labels
			capture lab def og_sector_lbl 11 "Non-financial company" 12 "Financial organization" ///
				13 "Governmental organization" 14 "Households" ///
				15 "Non-governmental non-profit organization", replace
			capture lab val og_sector og_sector_lbl
	
			capture lab def og_ownership_lbl 0 "n.a." 1 "Public" 2 "Private" 3 "Foreign", replace
			capture lab val og_ownership og_ownership_lbl
	
			capture lab def be_industry_lbl 1"Agriculture, forestry, and fishing" 2"Mining and quarrying" ///
					3"Manufacturing" 4"Electricity, gas, steam, and air conditioning supply" ///
					5"Water supply; sewerage, waste management and remidiation activities" ///
					6"Construction" 7"Wholesale and retail trade; repair of motorvehicles and motorcycles" ///
					8"Transportation and storage" 9"Accomodation and food service activities" ///
					10"Information and communication" 11"Financial institutions" ///
					12"Renting, buying, and selling of real estate" ///
					13"Consultancy, research and other specialised business services" ///
					14"Renting and leasing of tangible goods and other business support services" ///
					15"Public administration, public services, and compulsory social security" ///
					16"Education" 17"Human health and social work activities" ///
					18"Culture, sports, and recreation" 19"Other service activities" ///
					20"Activities of households as employers" ///
					21"Extraterritorial organizations and bodies", replace
			capture lab val be_industry be_industry_lbl
	
			capture lab def be_gksbs_lbl 0 "0 employees" 10 "1 employee" 21 "2 employees" ///
				22 "3-4 employees" 30 "5-9 employees" 40 "10-19 employees" 50 "20-49 employees" ///
				60 "50-99 employees" 71 "100-149 employees" 72 "150-199 employees" ///
				81 "200-249 employees" 82 "250-499 employees" 91 "500-999 employees" ///
				92 "1000-1999 employees" 93 "2000+ employees", replace
			capture lab val be_gksbs be_gksbs_lbl 

			capture lab def vep_legalform_lbl 1 "Eenmanszaak" 2 "Eenmanszaak met meerdere eigenaren" ///
				5 "Rederij" 6 "Maatschap" 12 "Vennootschap onder firma" ///
				25 "Commanditaire Vennootschap" 35 "Rechtspersoon in oprichting" ///
				43 "Besloten Vennootschap (bv)" 57 "Naamloze Vennootschap (nv)" ///
				58 "Europese naamloze vennootschap (se)" ///
				59 "Europese coöperatieve vennootschap (sce)" 67 "Coöperatie" ///
				73 "Kerkgenootschap" 74 "Stichting" 77 "Vereniging" ///
				87 "Onderlinge Waarborg Maatschappij" 90 "Buitenlandse rechtsvorm" ///
				93 "Europees economisch samenwerkingsverband" ///
				900 "Verschillende publiekrechtelijke instellingen" ///
				998 "Overige privaatrechtelijke Rechtspersoon", replace
			capture lab val vep_legalform vep_legalform_lbl	
	
			capture lab def event_lbl 4 "BE - Birth" 5 "BE - Death" 6 "BE - Merger" 7 "BE - Takeover" ///
				8 "BE - Restructuring" 9 "BE - Demerger" 10 "BE - Breakup" ///
				12 "BE - Combi Birth/Death" 13 "BE - Various" 14 "OG - Birth" ///
				15 "OG - Death" 16 "OG - Merger" 17 "OG - Takeover" 18 "OG - Restructuring" ///
				19 "OG - Demerger" 20 "OG - Breakup" 21 "OG - Combi Birth/Death", replace
			capture lab val ogbe_start_event-ogbe_end_event event_lbl
		}
		else if `"`module'"'=="ebb" {
			capture lab var year "Calendar year"
	
			capture lab var rinpersoon "Person ID"
			capture lab var rin_svydate_EBB "Survey date EBB (interview)"
			capture lab var rin_svynr_EBB "Number of survey EBB (1-5)"
			capture lab var rin_weight_EBB "Survey weight EBB (jaargewicht)"
			capture lab var rin_ISCO08 "ISCO-08 occupation code"
		}
		else if `"`module'"'=="funct" {
			// Variable labels
			capture lab var year "Calendar year"
	
			capture lab var jobid "Job ID"
			capture lab var ogid "OG ID" 
			capture lab var og_sector "Harmonized and simplified sector code"
			capture lab var og_employees "Number of employees in calendar year (aggregated from BE level)"
			capture lab var kvkid "Encrypted KVK dossier number"
	
			capture lab var rinpersoon "Person ID"
	
			capture lab var func_start "Start of functionary appointment"
			capture lab var func_end "End of funtionary appointment"
			capture lab var functionaristype "Type of functionary appointment"
			capture lab var functietitel "Detailed functionary title (if available)"
			
			**** Functions missing ***
		}	
		else if `"`module'"'=="gba" {	
			capture lab var rinpersoon "Person ID"
			capture lab var rin_cntbirth "Country of birth (respondent)"
			capture lab var rin_sex "Sex of repondent"
			capture lab var rin_cntbirth_m "Country of birth (respondent's mother)"
			capture lab var rin_cntbirth_f "Country of birth (respondent's father)"
			capture lab var rin_nrprntsfrgnbrn "Number of parents born outside The Netherlands"
			capture lab var rin_miggrp "Country of origin (old CBS definition)"
			capture lab var rin_miggen "First or second generation migration background"
			capture lab var rin_birthy "Year of birth (respondent)"
			capture lab var rin_birthm "Month of birth (respondent)"
			capture lab var rin_sex_m "Sex (respondent's mother)"
			capture lab var rin_sex_f "Sex (respondent's father)"
			capture lab var rin_birthy_m "Year of birth (respondent's mother)"
			capture lab var rin_birthm_m "Month of birth (respondent's mother)"
			capture lab var rin_birthy_f "Year of birth (respondent's father)"
			capture lab var rin_birthm_f "Month of birth (respondent's father)"
			capture lab var rin_miggrp_imputed "Imputed country of origin"
			capture lab var rin_miggrp_cbs "Country of origin (new CBS definition)"
			capture lab var rin_wrldrgn "World region (CBS typology)"
			capture lab var rin_wrldrgn_nidio "World region (NIDIO typology)"
			capture lab var rin_wstrn "Western country (CBS typology)"
			capture lab var rin_nlbrn "Born in The Netherlands"

			// Value labels
			* Sex
			capture lab def sex_lbl 1 "Man" 2 "Woman", replace
			capture lab val rin_sex* sex_lbl
	
			* Birth month
			capture lab def month_lbl 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" ///
				6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" ///
				12 "December", replace
			capture lab val rin_birthm* month_lbl 
	
			* Generation
			capture lab def miggen_lbl 0 "Respondent & parents born in NL" ///
				1 "First generation" 2 "Second generation", replace
			capture lab val rin_miggen miggen_lbl
	
			* Born in Netherlands
			capture lab def nlbrn_lbl 0 "Born outside NL" 1 "Born in NL", replace
			capture lab val rin_nlbrn nlbrn_lbl
	
			* Imputation
			capture lab def imputed_lbl 0 "Unchanged" 1 "Imputed" 9 "n.a.", replace
			capture lab val rin_miggrp_imputed imputed_lbl 
	
			* Country codes 
			capture lab def cntcds_lbl 1234 "The Netherlands (azc)" 5001 "Canada" 5002 "France" ///
			5003 "Switzerland" 5004 "Rhodesia" 5005 "Malawi" 5006 "Cuba" 5007 "Suriname" ///
			5008 "Tunesia" 5009 "Austria" 5010 "Belgium" 5011 "Botswana" 5012 "Iran" ///
			5013 "New Zealand" 5014 "South Africa" 5015 "Denmark" 5016 "Yemen Arab Republic" ///
			5017 "Hungary" 5018 "Saudi Arabia" 5019 "Liberia" 5020 "Ethiopia" 5021 "Chile" ///
			5022 "Morocco" 5023 "Togo" 5024 "Ghana" 5025 "Laos" 5026 "Angola" 5027 "Philippines" ///
			5028 "Zambia" 5029 "Mali" 5030 "Ivory Coast" 5031 "Myanmar" 5032 "Monaco" ///
			5033 "Colombia" 5034 "Albania" 5035 "Cameroon" 5036 "South Vietnam" 5037 "Singapore" ///
			5038 "Paraguay" 5039 "Sweden" 5040 "Cyprus" 5041 "Australian New Guinea" 5042 "Brunei" ///
			5043 "Iraq" 5044 "Mauritius" 5045 "Vatican" 5046 "Kashmir" 5047 "Myanmar" 5048 "Yemen" ///
			5049 "Slovenia" 5050 "Zaire" 5051 "Croatia" 5052 "Taiwan" 5053 "Russia" 5054 "Armenia" ///
			5056 "Azores" 5057 "Bahrain" 5058 "Bhutan" 5059 "British Antilles" 5060 "Comoros" ///
			5061 "Falkland Islands" 5062 "French Guiana" 5063 "Frans Somaliland" ///
			5064 "Gilbert and Ellice Islands" 5065 "Greenland" 5066 "Guadeloupe" 5067 "Cape Verde" ///
			5068 "Macau" 5069 "Martinique" 5070 "Mozambique" 5071 "Pitcairn Islands" ///
			5072 "Guinea-Bissau" 5073 "Réunion" 5074 "Saint Pierre and Miquelon" ///
			5075 "Seychelles and Amirante Islands" 5076 "Tonga" 5077 "Wallis and Futuna" ///
			5078 "South West Afrika" 5079 "French India" 5080 "Johnston Atoll" 5081 "Kedah" ///
			5082 "Kelantan" 5083 "Malakka" 5084 "Mayotte" 5085 "Negri Sembilan" 5086 "Pahang" ///
			5087 "Perak" 5089 "Portugese India" 5090 "Selangor" 5092 "Saint Vincent and the Grenadines" ///
			5093 "Spitsbergen" 5094 "Terengganu" 5095 "Aruba" 5096 "Burkina Faso" ///
			5097 "Azerbaijan" 5098 "Belarus" 5099 "Kazakhstan" 5100 "Macedonia" 5101 "East Timor" ///
			5102 "Serbia and Montenegro" 5103 "Serbia" 5104 "Montenegro" 5105 "Kosovo" 5106 "Bonaire" ///
			5107 "Curaçao" 5108 "Saba" 5109 "Sint Eustatius" 5110 "Sint Maarten" 5111 "South Sudan" ///
			5112 "Gaza Strip and West Bank" 5113 "North Macedonia" 6000 "Moldavia" 6001 "Burundi" ///
			6002 "Finland" 6003 "Greece" 6004 "Guatemala" 6005 "Nigeria" 6006 "Libya" ///
			6007 "Ireland" 6008 "Brazil" 6009 "Rwanda" 6010 "Venezuela" 6011 "Iceland" ///
			6012 "Liechtenstein" 6013 "Somalia" 6014 "United States of America" 6015 "Bolivia" ///
			6016 "Australia" 6017 "Jamaica" 6018 "Luxemburg" 6019 "Chad" 6020 "Mauritania" ///
			6021 "Kyrgyzstan" 6022 "China" 6023 "Afghanistan" 6024 "Indonesia" 6025 "Guyana" ///
			6026 "North Vietnam" 6027 "Norway" 6028 "San Marino" 6029 "West Germany" ///
			6030 "Netherlands" 6031 "Cambodia" 6032 "Fiji" 6033 "Bahamas" 6034 "Israel" ///
			6035 "Nepal" 6036 "South Korea" 6037 "Spain" 6038 "Ukraine" 6039 "Great Britain" ///
			6040 "Niger" 6041 "Haiti" 6042 "Jordan" 6043 "Turkey" 6044 "Trinidad and Tobago" ///
			6045 "Yugoslavia" 6046 "Republic of Upper Volta" 6047 "Algeria" 6048 "Gabon" ///
			6049 "North Korea" 6050 "Uzbekistan" 6051 "Sierra Leone" 6052 "British Honduras" ///
			6053 "Canary Islands" 6054 "French Polynesia" 6055 "Gibraltar" 6056 "Portuguese Timor" ///
			6057 "Tajikistan" 6058 "British Solomon Islands" 6059 "São Tomé and Principe" ///
			6060 "Saint Helena" 6061 "Tristan Da Cunha" 6062 "West Samoa" 6063 "Turkmenistan" ///
			6064 "Georgia" 6065 "Bosnia and Herzegovina" 6066 "Czech Republic" 6067 "Slovakia" ///
			6068 "Federal Republic of Yugoslavia" 6069 "Democratic Republic of the Congo" ///
			7001 "Uganda" 7002 "Kenya" 7003 "Malta" 7004 "Barbados" 7005 "Andorra" 7006 "Mexico" ///
			7007 "Costa Rica" 7008 "Gambia" 7009 "Syria" 7011 "Dutch Antilles (old)" ///
			7012 "South Yemen" 7014 "Egypt" 7015 "Argentinia" 7016 "Lesotho" 7017 "Honduras" ///
			7018 "Nicaragua" 7020 "Pakistan" 7021 "Senegal" 7023 "Dahomey" 7024 "Bulgaria" ///
			7026 "Malaysia" 7027 "Dominican Republic" 7028 "Poland" 7029 "Russia (old)" ///
			7030 "British Vigin Islands" 7031 "Tanzania" 7032 "El Salvador" 7033 "Sri Lanka" ///
			7034 "Sudan" 7035 "Japan" 7036 "Hongkong" 7037 "Panama" 7038 "Uruguay" 7039 "Ecuador" ///
			7040 "Guinea" 7041 "Maldives" 7042 "Thailand" 7043 "Lebanon" 7044 "Italy" 7045 "Kuwait" ///
			7046 "India" 7047 "Romania" 7048 "Czechoslovakia" 7049 "Peru" 7050 "Portugal" ///
			7051 "Oman" 7052 "Mongolia" 7053 "Samoa" 7054 "United Arab Emirates" 7055 "Tibet" ///
			7057 "Nauru" 7058 "Dutch New Guinea" 7059 "Tanganyika" 7060 "Palestina" ///
			7062 "Brits West Indies" 7063 "Portuguese Africa" 7064 "Latvia" 7065 "Estonia" ///
			7066 "Lithuania" 7067 "British Africa" 7068 "Belgian Congo" 7070 "British India" ///
			7071 "Northern Rhodesia" 7072 "Southern Rhodesia" 7073 "Saarland" 7074 "French Indochina" ///
			7075 "British Borneo" 7076 "Gold Coast" 7077 "Ras Al Khaimah" 7079 "French Congo" ///
			7080 "Siam" 7082 "East Africa Protectorate" 7083 "North Borneo" 7084 "Bangladesh" ///
			7085 "East Germany" 7087 "Madeira" 7088 "United States Virgin Islands" 7091 "Spanish Sahara" ///
			7092 "Cayman Islands" 7096 "British Territory in the Indian Ocean" 7097 "Cook Islands" ///
			7099 "New Caledonia" 8000 "Hawaii" 8001 "Guam" 8002 "American Samoa" ///
			8005 "Wake Island" 8006 "Pacific Islands" 8008 "Grenada" 8009 "Mariana Islands" ///
			8010 "Cabinda" 8012 "Christmas Island"8014 "Faeroe Ilands" 8015 "Montserrat" ///
			8016 "Norfolk Island" 8017 "Belize" 8018 "Tasmania" 8019 "Turks and Caicos Islands" ///
			8020 "Puerto Rico" 8021 "Papua New Guinea" 8022 "Solomon Islands" 8023 "Benin" ///
			8024 "Vietnam" 8025 "Cape Verde" 8026 "Seychelles" 8027 "Kiribati" 8028 "Tuvalu" ///
			8029 "Saint Lucia" 8030 "Dominica" 8031 "Zimbabwe" 8032 "Dubai" 8033 "New Hebrides" ///
			8034 "Channel Islands" 8035 "Isle of Man" 8036 "Anguilla" 8037 "Saint Kitts and Nevis" ///
			8038 "Antigua" 8039 "Saint Vincent" 8040 "Gilbert Islands" 8041 "Panama Canal Zone" ///
			8042 "Saint Kitts-Nevis-Anguilla" 8043 "Palau" 8044 "Republic of Palau" ///
			8045 "Antigua and Barbuda" 9000 "Newfoundland" 9001 "Nyasaland" 9003 "Eritrea" ///
			9005 "Ifni" 9006 "British Cameroon" 9007 "Kaiser-Wilhelmsland" 9008 "Congo" ///
			9009 "Democratic Republic of the Congo" 9010 "Madagascar" 9013 "Republic of the Congo" ///
			9014 "Leeward Islands" 9015 "Windward Islands" ///
			9016 "French Territory of the Afars and the Issas" ///
			9020 "Portuguese Guinea" 9022 "German South West Africa" 9023 "Namibia" ///
			9027 "British Somaliland" 9028 "Italian Somaliland" 9030 "Dutch India" ///
			9031 "British Guiana" 9036 "Swaziland" 9037 "Qatar" 9041 "Aden Colony" ///
			9042 "Federation of South Arabia" 9043 "Equatorial Guinea" 9044 "Spanish Guinea" ///
			9047 "United Arab Republic" 9048 "Bermuda" 9049 "Soviet Union" 9050 "German East Africa" ///
			9051 "Zanzibar" 9052 "Ceylon" 9053 "Muscat and Oman" 9054 "Trucial Oman" 9055 "Indochina" ///
			9056 "Marshall Islands" 9057 "Sarawak" 9058 "British Borneo" 9060 "Sabah" 9061 "Abu Dhabi" ///
			9062 "Ajman" 9063 "Basutoland" 9064 "Bechuanaland Protectorate" 9065 "Emirate of Fujairah" ///
			9066 "French Cameroon" 9067 "Johor" 9068 "Korea" 9069 "Labuan" 9070 "Umm Al Quwain" ///
			9071 "Austria-Hungary" 9072 "Portugese Mozambique" 9073 "Portugese Angola" ///
			9074 "Sharjah" 9075 "Straits Settlements" 9076 "Ethiopian Empire" 9077 "French West Afrika" ///
			9078 "French Equatorial Afrika" 9081 "Urundi" 9082 "Ruanda-Urundi" 9084 "Goa" ///
			9085 "Danzig" 9086 "Central African Republic" 9087 "Djibouti" 9088 "Transjordan" ///
			9089 "Germany" 9090 "Vanuatu" 9092 "Spanish North Africa" 9093 "Western Sahara" ///
			9094 "Micronesia", replace
			capture lab val rin_cntbirth* rin_miggrp* cntcds_lbl
	
			* World region & Western / Non-Western typologies (CBS)
			capture lab def wrldrgn_lbl 1 "Africa" 2 "America" 3 "Asia" 4 "Europe" 5 "Oceania", replace
			capture lab val rin_wrldrgn wrldrgn_lbl
			capture lab def wrldrgn2_lbl 1 "Western" 2 "Non-Western", replace 
			capture lab val rin_wstrn wrldrgn2_lbl
	
			* World region typology (NIDIO)
			capture lab def wrldrgn_nidio_lbl 1 "West (Europe,US,Canada,AUS,NZ)" 2"Asia and Oceania" ///
				3 "Middle East +" 4 "Sub-Saharan Africa" 5 "Latin America and the Caribbean", replace
			capture lab val rin_wrldrgn_nidio wrldrgn_nidio_lbl
		}
		else if `"`module'"'=="kind" {	
			// Variable labels 
			capture lab var rinpersoon "Person ID"
			capture lab var rin_nrchildren "Total number of registered children until current year"
			capture lab var rin_mfchild "Legal role of parent"
			capture lab var rinchild "Child ID"
			capture lab var child_birthy "Birth year of child"
			capture lab var child_birthm "Birth month of child"
			capture lab var childparent_link "CBS code describing means of established link"
			capture lab var rinalterp "Other Parent ID"
	
			// Value labels 
			* Legal role
			capture lab def mf_lbl 1 "Legal mother" 2 "Legal father", replace
			capture lab val rin_mfchild mf_lbl 
		}
		else if `"`module'"'=="nea" {		
			// Variable labels
			capture lab var year "Calendar year"
	
			capture lab var rinpersoon "Person ID"
			capture lab var rin_weight_NEA "Survey weight NEA (sample weights)"
			capture lab var rin_ISCO08 "ISCO-08 occupation code"
			capture lab var rin_neaocc "Occupation codes NEA (-2010)"
		}
		else if `"`module'"'=="nfo" {	
			// Variable labels
			capture lab var year "Calendar year"
			capture lab var finr "Encrypted fiscal ID"
			capture lab var ogid "OG ID"
			capture lab var source "Source of financial data"
			capture lab var og_oph "Reweighting factor at firm-level due to non-reproting of financial data"
			capture lab var og_assets "Total balance (in 1000 Euros) of OG"
			capture lab var og_revenue "Net revenue (in 1000 Euros) of OG"
			capture lab var og_lcost "Labor cost (in 1000 Euros) of OG"
			capture lab var og_ccost "Capital cost (in 1000 Euros) of OG"
			capture lab var og_cdeprec "Capital depreciation (in 1000 Euros) of OG"
			capture lab var og_profit "Operating profit (in 1000 Euros) of OG"
			capture lab var og_result "Net result (in 1000 Euros) of OG"
			
			capture lab var oph "Reweighting factor at firm-level due to non-reproting of financial data"
			capture lab var assets "Total balance (in 1000 Euros)"
			capture lab var revenue "Net revenue (in 1000 Euros)"
			capture lab var lcost "Labor cost (in 1000 Euros)"
			capture lab var ccost "Capital cost (in 1000 Euros)"
			capture lab var cdeprec "Capital depreciation (in 1000 Euros)"
			capture lab var profit "Operating profit (in 1000 Euros)"
			capture lab var result "Net result (in 1000 Euros)"
		}
		else if `"`module'"'=="opl" {
			// Variable labels
			capture lab var year "Calendar year"
			capture lab var rinpersoon "Person ID"
			capture lab var edu_wgt "CBS education weight (if source=survey)"
			capture lab var rin_edu_soi2016 "Highest attained education SOI2016 (incl. CBS imputation)"
			capture lab var rin_edufield_soi2016 "Field of education SOI2016 (incl. CBS imputation)"
			capture lab var rin_edu_soi2021 "Highest attained education SOI2021 (incl. CBS imputation)"
			capture lab var rin_edufield_soi2021 "Field of education SOI2021 (incl. CBS imputation)"
			capture lab var rin_edu_isced2011 "Highest attained education ISCED2011 (via OPLNR)"
			
			// Value labels
			capture lab def soi_lbl 1111 "[1111] Basisonderwijs gr1-2" ///
				1112 "[1112] Basisonderwijs gr3-8" 1211 "[1211] Praktijkonderwijs" ///
				1212 "[1212] Vmbo-b/k" 1213 "[1213] Mbo1" ///
				1221 "[1221] Vmbo-g/t" 1222 "[1222] Havo-, vwo-onderbouw" ///
				2111 "[2111] Mbo2" 2112 "[2112] Mbo3" 2121 "[2121] Mbo4" ///
				2131 "[2131] Havo-bovenbouw" 2132 "[2132] Vwo-bovenbouw" ///
				3111 "[3111] Hbo-associate degree" 3112 "[3112] Hbo-bachelor" ///
				3113 "[3113] Wo-bachelor" 3211 "[3211] Hbo-master" ///
				3212 "[3212] Wo-master" 3213 "[3213] Doctor", replace
			capture lab val rin_edu_soi* soi_lbl
			
			capture lab def isced_lbl 0 "[0] Early childhood education" ///
				1 "[1] Primary education" 2 "[2] Lower secondary education" ///
				3 "[3] Upper secondary education" 4 "[4] Post-secondary non-tertiary education" ///
				5 "[5] Short-cycle tertiary education" 6 "[6] Bachelor's or equivalent level" ///
				7 "[7] Master's or equivalent level" 8 "[8] Doctoral or equivalent level", replace
			capture lab val rin_edu_isced2011 isced_lbl
		
		}
		else if `"`module'"'=="partner" {	
			capture lab var rinpersoon "Person ID"
			capture lab var rinpersoonp "Partner ID"
			capture lab var partnership_start "Start date partnership"
			capture lab var partnership_end "End date partnership"
		}
		else if `"`module'"'=="spolis" {
			// Variable labels
			capture lab var year "Calendar year"
			capture lab var rinpersoon "Person ID"
			capture lab var beid "BE ID"
			capture lab var baanrugid "Job ID POLIS (2006-2009)"
			capture lab var ikvid "Job ID SPOLIS (2010- )"
			capture lab var slbaanid "Longitudinal Job ID"
			capture lab var scontractsoort "Type of contract"
			capture lab var spolisdienstverband "Full-time / part-time employment" 
			capture lab var swekarbduurklasse "Working time category"
			capture lab var scaosector "CAO sector"
			capture lab var scao_crypt "Encrypted CAO code"
			capture lab var caocode "Decrypted Bedrijstak-CAO code"
			capture lab var cao "CAO status"
			capture lab var ssoortbaan "Job type"
			capture lab var job_start_caly "Starting date of job within calendar year"
			capture lab var job_end_caly "Ending date of job within calendar year"
			capture lab var job_tenure "Overall starting date of job"
			capture lab var sbaandagen_month "Job days (September)"
			capture lab var sbasisloon_month "Base pay (September)"
			capture lab var sbasisuren_month "Base working hours (September)"
			capture lab var sbijzonderebeloning_month "Total extra compensation (September)"
			capture lab var sextrsal_month "End-of-year bonus (September)"
			capture lab var sincidentsal_month "Bonus pay (September)"
			capture lab var slningld_month "Total pay (September)"
			capture lab var slnowrk_month "Overtime compensation (September)"
			capture lab var soverwerkuren_month "Overtime hours (September)"
			capture lab var sreguliereuren_month "Regular working hours (September)"
			capture lab var svakbsl_month "Holiday allowance (September)"
			capture lab var svoltijddagen_month "Full-time days (September)"
			capture lab var ft_factor "Full-time factor"
			capture lab var mainjob "Main job (most total pay)"
	
			capture lab var sbaandagen_year "Job days (Calendar year)"
			capture lab var sbasisloon_year "Base pay (Calendar year)"
			capture lab var sbasisuren_year "Base working hours (Calendar year)"
			capture lab var sbijzonderebeloning_year "Total extra compensation (Calendar year)"
			capture lab var sextrsal_year "End-of-year bonus (Calendar year)"
			capture lab var sincidentsal_year "Bonus pay (Calendar year)"
			capture lab var slningld_year "Total pay (Calendar year)"
			capture lab var slnowrk_year "Overtime compensation (Calendar year)"
			capture lab var soverwerkuren_year "Overtime hours (Calendar year)"
			capture lab var sreguliereuren_year "Regular working hours (Calendar year)"
			capture lab var svakbsl_year "Holiday allowance (Calendar year)"
			capture lab var svoltijddagen_year "Full-time days (Calendar year)"

			// Value labels
			capture lab def scontractsoort_lbl 0 "Permanent employment" 1 "Temporary employment", replace
			capture lab val scontractsoort scontractsoort_lbl

			capture lab def spolisdienstverband_lbl 1 "Full-time" 2 "Part-time", replace
			capture lab val spolisdienstverband spolisdienstverband_lbl

			capture lab def swekarbduurklasse_lbl 1 "<12 hours" 2 "12-<20 hours" 3 "20-<25 hours" ///
				4 "25-<30 hours" 5 "30-<35 hours" 6 "35+ hours", replace
			capture lab val swekarbduurklasse swekarbduurklasse_lbl
	
			capture lab def scaosector_lbl 1 "Private" 2 "Non-profit" 3 "Government", replace
			capture lab val scaosector scaosector_lbl
	
			capture lab def cao_lbl 0 "No collective agreement" ///
				1 "Sectoral agreement" 2 "Firm-level agreement", replace
			capture lab val cao cao_lbl
	
			capture lab def ssoortbaan_lbl 1 "Director / Large shareholder" 2 "Intern" ///
				3 "WSW-er" 4 "Temporary agency worker" 5 "On-call worker" 9 "Standard", replace
			capture lab val ssoortbaan ssoortbaan_lbl
	
			capture lab def mainjob_lbl 0 "No" 1 "Yes", replace
			capture lab val mainjob mainjob_lbl
		}
		else {
			display as txt "--------------------------------------------------------"
			display as err "Unknown module."
		}	

end
