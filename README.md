# Final-Project
final project for quant 1
* use variables from the datasets
use ft_dpc postvote_presvt dem_edugroup_x incgroup_prepost_x dem_agegrp_iwdate_x gender_respondent_x sample_region hhlist_r_age relig_churchoft abort_dpc4 spsrvpr_ssself abortpre_4point using nes2012.dta

* 1. Descriptive statistics about respondents
/* Mean and standard deviation of thermomter ratings(ft_dpc) */
	sum ft_dpc
* edit and clean up data -- exclude -8, -9, -2
	recode ft_dpc (. = .)(-9 = .)(-8 = .) (-2 = .)   

	
/* Percentage of respondents vote in 2012 */
	tab postvote_presvt  // vote for president

	
/* Level of Education */
* exclude values -9 "refused", -2 " missing"
	replace dem_edugroup_x = . if inlist(dem_edugroup_x, -9, -2)
* level of education by group
	tab dem_edugroup_x 
* distribution of education level of the respondents
	hist dem_edugroup_x, discrete percent title("Education level of the respondents") xtitle("education level") 

	
/* Family Income Levels */
* exclude values -9 "refused" -8 "don't know"
	replace incgroup_prepost_x = . if inlist(incgroup_prepost_x, -9, -8)
* level of income by group
	tab incgroup_prepost_x 
* distribution of income level of the respondents
	hist incgroup_prepost_x, discrete percent title("Income level of the respondents") xtitle("income level")
	
	
/* Age */
* exclude values -2 " missing"
	replace dem_agegrp_iwdate_x = . if dem_agegrp_iwdate_x == -2
* descriptive information on age group 
	tab dem_agegrp_iwdate_x
* distribution of age group
	hist dem_agegrp_iwdate_x, discrete percent title("Distribution of Age Group") xtitle("Age Group")



* 2a. Gender gap
/* Two sample t test for the thermometer ratings by gender */

* overview of the two variables
	codebook gender_respondent_x
	codebook ft_dpc
* descriptive analysis for gender
	tab gender_respondent_x
* t test by gender
	ttest ft_dpc, by(gender_respondent_x)  // test significant under 95% CL (female > male)
	ttest ft_dpc, by(gender_respondent_x) level(99)  // test significant under 99% CL(female > male)

	

* 2b. Region gap
/* Two sample t test for the thermometer ratings by region south */

* overview of region variable
	codebook sample_region
* descriptive analysis for region 
	tab sample_region
* create indicator for southern states
	gen south_group = 0
	replace south_group = 1 if sample_region == 3  // 1 for southern states 0 from else where
	label var south_group "People from southern states"  // label variable south_group
* descriptive statistics for south_group
	tab south_group  
* t test by region south
	ttest sample_region, by(south_group)  // test significant under 95% CL (diff = 0.49, south > non-south)
	ttest sample_region, by(south_group) level(99)  // test significant under 99% CL 


	
* 2c. diff between north and south
/* Two sample t test between north and south */
* create binary variable for northeastern and western states
	gen ne_w_states = .
	replace ne_w_states = 1 if sample_region == 1
	replace ne_w_states = 2 if sample_region == 3
	label var ne_w_states "People from northeastern states or western states"
* descriptive statistics for ne_w_states
	tab ne_w_states
* two sample t test in northeastern and western states
	ttest ft_dpc, by(ne_w_states)  // Not significant under 95% CL p value = 0.41

	
	
* 2d. Association between age and rating
* exclude values -9 "refused" -8 "don't know -1 "inapplicable" for age variable
	replace hhlist_r_age = . if inlist(hhlist_r_age, -9,-8,-1)
	tab hhlist_r_age
/* correlation and regression */
	pwcorr ft_dpc hhlist_r_age, sig  // Pearson r = -0.1153 Test Significant
* scatter plot between the two variables
	twoway (lfit ft_dpc hhlist_r_age) (scatter ft_dpc hhlist_r_age, sort), ytitle(Rating) xtitle(Age) title("Rating of President by Age") 

* regression between age and ratings
	 reg ft_dpc hhlist_r_age  // Coefficient = -0.21 Statistic Significant R-squared = 0.013
* residual plot
	rvpplot hhlist_r_age 
** Coefficient is statistic significant but this linear model is not good fit(low R-squared, too many negative residual), No substantive significance




* 2e. Association between religion and opinion of abortion
/* chi-Squared test */
* overview of two variables
	codebook relig_churchoft  // 1 for every week 5 for never(need to recode it to right order)
	codebook abortpre_4point
* change the value order for relig_churchoft into usual way 1 for never 5 for every week
	recode relig_churchoft (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1), gen(relig_service)
	label var relig_service "Frequency of attending religious services"
* clean up non-response missing value
	replace relig_service = . if inlist(relig_churchoft, -9, -1)
	replace abortpre_4point = . if inlist(abortpre_4point, -9, -8, 5)
* Chi Squared test 
	tab relig_service abortpre_4point, chi2  // Pearson chi2 = 386.2625 Statistic Significant

//	Scatter plot
	twoway (lfit abortpre_4point relig_service) (scatter abortpre_4point relig_service, sort), ytitle("opinion of legality on abortion") xtitle("attendance on religious services") title("Opinions on Abortion ") 


	

* 2f. Association between religious services and opinion on whether government should provide service
/* Chi-Sqaured test */
* overview of the two variables
	codebook spsrvpr_ssself
	codebook relig_churchoft
* change the value order of relig_churchoft into usual way just like the above
	recode relig_churchoft (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1), gen(relig_service)
	label var relig_service "Frequency of attending religious services"
* clean up variables
	replace spsrvpr_ssself = . if inlist(spsrvpr_ssself, -9, -8, -2)
	replace relig_service = . if inlist(relig_churchoft, -9, -1)
* crosstab and chi square test between two variables
	tab spsrvpr_ssself relig_service, chi2  // Pearson chi2 = 87.12 Statistic Significant 

// Scatter Plot
	twoway (lfit spsrvpr_ssself relig_service ) (scatter spsrvpr_ssself relig_service  , sort), ytitle(Government providing services) xtitle("attandance on religious services" ) title("Opinions on government providing services") 
	
	
	

	
	 








	

	
