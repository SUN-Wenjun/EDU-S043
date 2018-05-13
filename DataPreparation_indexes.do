cd "D:\abroad\Harvard\18spring courses\EDU S043\S043final"

*insheet using data/PPP.csv, clear names
*saveold data/PPP.dta, replace
use data/PPP.dta, clear
replace countryname = "Bosnia" if countryname == "Bosnia and Herzegovina"
replace countryname = "Czech Rep." if countryname == "Czech Republic"
replace countryname = "Dominican Rep." if countryname == "Dominican Republic"
replace countryname = "Egypt" if countryname == "Egypt, Arab Rep."
replace countryname = "Great Britain" if countryname == "United Kingdom"
replace countryname = "Hong Kong" if countryname == "Hong Kong SAR, China"
replace countryname = "Iran" if countryname == "Iran, Islamic Rep."
replace countryname = "Kyrgyzstan" if countryname == "Kyrgyz Republic"
replace countryname = "Macedonia" if countryname == "Macedonia, FYR"
replace countryname = "Russia" if countryname == "Russian Federation"
replace countryname = "Slovakia" if countryname == "Slovak Republic"
replace countryname = "South Korea" if countryname == "Korea, Rep."
replace countryname = "Venezuela" if countryname == "Venezuela, RB"
replace countryname = "Viet Nam" if countryname == "Vietnam"
replace countryname = "Yemen" if countryname == "Yemen, Rep."
save data/PPP.dta, replace
*"Palestine", "Serbia and Montenegro" and "Taiwan" are not in World Bank's PPP

use data/country.dta, clear
merge 1:1 countryname using data/PPP.dta, keep(match master) nogen
reshape long v, i(countryname) j(year)
rename v ppp
rename countryname country
save data/PPP_cy.dta, replace
outsheet using data/PPPfinal.csv, comma replace

*do the same thing to Life expectancy
*insheet using data/LE.csv, clear names
*rename CountryName countryname
*saveold data/LE.dta, replace
use data/LE.dta, clear
replace countryname = "Bosnia" if countryname == "Bosnia and Herzegovina"
replace countryname = "Czech Rep." if countryname == "Czech Republic"
replace countryname = "Dominican Rep." if countryname == "Dominican Republic"
replace countryname = "Egypt" if countryname == "Egypt, Arab Rep."
replace countryname = "Great Britain" if countryname == "United Kingdom"
replace countryname = "Hong Kong" if countryname == "Hong Kong SAR, China"
replace countryname = "Iran" if countryname == "Iran, Islamic Rep."
replace countryname = "Kyrgyzstan" if countryname == "Kyrgyz Republic"
replace countryname = "Macedonia" if countryname == "Macedonia, FYR"
replace countryname = "Russia" if countryname == "Russian Federation"
replace countryname = "Slovakia" if countryname == "Slovak Republic"
replace countryname = "South Korea" if countryname == "Korea, Rep."
replace countryname = "Venezuela" if countryname == "Venezuela, RB"
replace countryname = "Viet Nam" if countryname == "Vietnam"
replace countryname = "Yemen" if countryname == "Yemen, Rep."
save data/LE.dta, replace
use data/country.dta, clear
merge 1:1 countryname using data/LE.dta, keep(match master) nogen
reshape long v, i(countryname) j(year)
rename v le
rename countryname country
save data/LE_cy.dta, replace
outsheet using data/LEfinal.csv, comma replace

/*the following code is to get a list of countries whose name is different form the country dataset, so I can know hwo to change their name to make their name match. 
use data/country.dta, clear
rename countryname country
merge 1:1 country using data/expsch.dta, keepusing(country) keep(master)*/
insheet using data/expsch.csv, clear names
saveold data/expsch.dta, replace
use data/expsch.dta, clear
replace country = "Bosnia" if country == "Bosnia and Herzegovina"
replace country = "Czech Rep." if country == "Czech Republic"
replace country = "Dominican Rep." if country == "Dominican Republic"
replace country = "Great Britain" if country == "United Kingdom"
replace country = "Hong Kong" if country == " Hong Kong, China (SAR)"
replace country = "Iran" if country == "Iran (Islamic Republic of)"
replace country = "Moldova" if country == "Moldova (Republic of)"
replace country = "Palestine" if country == " Palestine, State of"
replace country = "Russia" if country == "Russian Federation"
replace country = "South Korea" if country == "Korea (Republic of)"
replace country = "Tanzania" if country == "Tanzania (United Republic of)"
replace country = "Venezuela" if country == "Venezuela (Bolivarian Republic of)"
*in the index provided by UNDP, the following countries couldn't be found: "Macedonia", "Puerto Rico", "Serbia and Montenegro", "Taiwan"
save data/expsch.dta, replace
use data/country.dta, clear
rename countryname country
merge 1:1 country using data/expsch.dta, keep(match master) nogen
reshape long v, i(country) j(year)
rename v expsch
save data/expsch_cy.dta, replace
outsheet using data/expschfinal.csv, comma replace
