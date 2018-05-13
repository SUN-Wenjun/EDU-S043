cd "D:\abroad\Harvard\18spring courses\EDU S043\S043final"
use data\WVS_Long.dta , clear
drop if A008 < 0
keep A008 S020 S002 X001 X003 X007 X025 X028 A006 X011 X047 S003 

rename A008 happy
lab drop A008
replace happy = 5-happy

rename S020 year
rename S002 wave
lab drop S002

gen female=. 
replace female=1 if X001 == 2
replace female=0 if X001 == 1
drop X001

rename X003 age
replace age=. if age<0

gen married=. 
replace married=1 if X007==1
replace married=0 if X007>1 & X007<=8
drop X007

gen high=. 
replace high=1 if X025==4|X025>=6
replace high=0 if X025==1|X025==2|X025==3|X025==5
drop X025

gen employed=.
replace employed=1 if X028==1
replace employed=0 if X028>1 & X028<=8
drop X028

rename A006 religious
replace religious=. if religious<0
replace religious = 5-religious
lab drop A006

rename X011 child
replace child=. if child<0
lab drop X011

rename X047 income
replace income=. if income<0
lab drop X047

rename S003 country
decode country, gen(test)
drop country
rename test country

sum religious - employed

outsheet using data/final43.csv, replace comma




