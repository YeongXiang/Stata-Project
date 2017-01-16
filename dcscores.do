* Set working directory
cd "~/Documents/Data

* Load Truesdell14&15 data
clear all
insheet using Trusdell14&15.csv

* Describe the data
desc *

** Data cleaning and recode
* recode ethnic
egen race = group(ethnic)
recode race (1 =.)(5 = 1)

* label the race
label define raceLabel 1 "Hispanic" 2 "Black" 3 "Indian" 4 "Asian"
label values race raceLabel
label variable race "Race"

* recode gender 
encode gender, gen(sex) 


* Set Variale list(save typings when building models)
global xlist membership_days unexcused excused isarate suspensions days_suspended 

* Recode term for 2016 (for panel use)
recode term(1=5)(2=6)(3=7)(4=8) if year == 2015


** Summary for gender and race for unique individuals
* Save the current status
preserve 
* remove repeated measures
sort id
quietly by id: gen dup = cond(_N==1,0,_n)
drop if dup > 1
tab sex,m
tab race, m
* return to the stauts before removing the repeated measures
restore


** Summary of Dependent Variables 
* Attendance
sum isarate
hist isarate, discrete frequency

tab unexcused,m
hist unexcused, discrete frequency
sum unexcused

tab excused,m
hist excused, discrete frequency
sum excused

* Suspension
tab days_suspended,m
hist days_suspended, discrete frequency

 
 
** Summary of Contorl Variables
tab grade,m
tab term, m
hist grade, discrete frequency


** Summary of Independent Variables
tab membership_days,m
sum membership_days
hist membership_days, discrete frequency


** Check for variation in independent variable
* summarize memberships days  by year and term
tab term year, summarize(membership_days) mean standard

*summarize membership days by gender and year
tab sex year, summarize(membership_days) mean // male increase participation 

*summarize membership days by race and year
tab race year, summarize(membership_days) mean // male increase participation 

** 2x2 for term and participation level(0,1)

* create participation level dummy 
sum membership_days, detail 
gen membershipHigh = .
replace membershipHigh = 0 if membership_days < r(p25)
replace membershipHigh = 1 if membership_days > r(p75) 

* label participation level
label define membershipHighLabel 0 "Low" 1 "High" 
label values membershipHigh membershipHighlLabel
label variable membershipHigh "Participation Level"



// I didn't come out the result for 2x2 table
 keep if term == 1 | term == 3
summarize membership_days,detail
gen membershipHighT1 = 0
replace membershipHigh = 1 if membership_days < r(p25) & term == 1
replace membershipHigh = 2 if membership_days > r(p75) & term == 1


summarize membership_days, detail
gen membershipHighT3 = 0
replace membershipHighT3 = 1 if membership_days < r(p25) & term == 3
replace membershipHighT3 = 2 if membership_days > r(p75) & term == 3

tab membershipHighT1 membershipHighT3  




*** term and participation level(High, Medium, Low)(0,1,2)
sum membership_days, detail 
gen membershipLevel = 1
replace membershipLevel = 0 if membership_days < r(p25)
replace membershipLevel = 2 if membership_days > r(p75)

* label participation level
label define membershipLevelLabel 0 "Low" 1 "Medium" 2 "High"
label values membershipLevel membershipLevelLabel
label variable membershipLevel "Participation Level"

tab term membershipLevel

** gender & participation level
tab sex membershipLevel

** race & participation level
tab race membershipLevel











* Load TrusdellSP_14 data  Only for 2014
clear all
insheet using TrusdellSP_14.csv

* Set Variale list(save typings when building models)
global xlist1 grade gender membership_days unexcused excused days_suspended elalevel_n mathlevel_n

* Describe the data
desc *

* String to Numeric
gen elascores_n = real(elascores)
gen elalevel_n = real(elalevel)
gen mathscores_n = real(mathscores)
gen mathlevel_n = real(mathlevel)
 
desc elascores_n elalevel_n mathscores_n mathlevel_n

* Summary of variables
foreach var in $xlist1 {
	tab `var'
}
/*tab grade,m 
tab gender,m
tab membership_days,m
tab unexcused,m
tab excused,m
tab days_suspended,m */

sum elascores_n elalevel_n mathscores_n mathlevel_n

/* hist grade, discrete frequency
hist membership_days, discrete frequency
hist isarate, discrete frequency
hist unexcused, discrete frequency
hist excused, discrete frequency
hist days_suspended, discrete frequency */
hist elascores_n
hist mathscores_n
hist elalevel_n, discrete
hist mathlevel_n, discrete 

sum elascores_n mathscores_n
tab elalevel_n
tab mathlevel_n


* Load TrusdellFRLethnic_15 data  Only for 2015
clear all
insheet using TruesdellSPFRLEthnic_15.csv

* Describe the data
desc *

* Summary of FRL and Ethnic
tab frl
tab ethnic


