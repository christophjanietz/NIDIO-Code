*program 'PARTNERBUSMATCH' 
	*Purpose: match partnerbus to person - year and person - month file and create an indicator whether the person was partnered 
	*Use: open a master file with rinpersoon year (and month) variables, define partnerbus file as using file for the match ("${dPARTNER}/partnerbus_rin_allyears.dta"), define unit of matching (either "year" or "month"), starting year (startyear) -and month (startmonth as integer)- and final year (finishyear) -and month(finishmonth as integer)- as optional arguments. Default years: 2006-2022, months: 1-12
	*author: Zoltan Lippenyi
	*date: 8/2/2024

program define partnerbusmatch
	syntax using [, unit(string) startyear(integer 2006) finishyear(integer 2022) startmonth(integer 1) finishmonth(integer 12)]

		tempfile wfile
		save `wfile'
		clear
		use `using'
		drop rinpersoonp
		
		// Extract years
		gen start_year = year(partnership_start)
		gen finish_year = year(partnership_end)
		if `"`unit'"'=="year" {
			gsort rinpersoon start_year finish_year 
		}
		
		// Extract months
		if `"`unit'"'=="month" {
			gen start_month = month(partnership_start)
			gen finish_month = month(partnership_end)
			gsort rinpersoon start_year start_month finish_year finish_month
		
		}
	
			
		// Limit period to start/end arguments
		if `"`unit'"'=="year" {
			drop if finish_year<`startyear'
			drop if start_year>`finishyear' 
		}
	
		if `"`unit'"'=="month" {
			drop if finish_year<`startyear' & finish_month<`startmonth'
			drop if start_year>`finishyear' & start_month>`finishmonth'
		}
		
		// prepare for merge, parse 
		drop partnership_start partnership_end
		
		
		if `"`unit'"'=="year" {
				
			//limit durations to observation window
			gen long n = _n
			rename (start_year finish_year) (year1 year2)
			replace year1 = `startyear' if year1<`startyear'
			replace year2 = `finishyear' if year2>`finishyear'
			
			replace year2= . if year1==year2
			
			// long format
			greshape long year, i(n) j(j) dropmiss
			drop j
			
			// create panel and fill gaps
			xtset n year, yearly
			tsfill
			
			bysort n : replace rinpersoon = rinpersoon[1] 
			
			// aggregate up to person-year level
			drop n
			gduplicates drop rinpersoon year, force
			
			//merge to working file
			tempfile partnerbus
			save `partnerbus'
			clear
			use `wfile'
			merge n:1 rinpersoon year using `partnerbus', keep(master match)
			rename _merge partnered
			recode partnered (3=1) (1=0)
			
		}
			
end