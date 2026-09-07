
*converting all CSV files to DTA
import delimited "/Users/alex/Documents/Pace/Classes/Junior/Fall/Eco 385/Data Recreation/town_all_years/2023_Town.csv", clear

save "/Users/alex/Documents/Pace/Classes/Junior/Fall/Eco 385/Data Recreation/DTA years/2023.dta", replace

* This was from November of 2025. I converted all of these to .dta files by hand. Looking back in 2026 I know a loop would have made this much much easier. I would do that if I recreated this experiment.

************************************************************************************
cd "/Users/alex/Documents/Pace/Classes/Junior/Fall/Eco 385/Data Recreation/DTA years"
*makes the directory the folder where all of my years are saved as .dta files.

use 2013
append using 2014
append using 2015
append using 2016
append using 2017
append using 2018
append using 2019
append using 2020
append using 2021
append using 2022
append using 2023

save "/Users/alex/Documents/Pace/Classes/Junior/Fall/Eco 385/Data Recreation/DTA years/All_Years.dta", replace
*Saves fully fixed Dataset
************************************************************************************

* Append for multiple years using the same process of import convert to dta, append using XYZ
foreach v of varlist entity_name-object_of_expenditure{
	encode `v', gen(_`v')
} 
*Encodes entity name for our red string variables, same name for the variables but `v' becomes _`v'

codebook _account_code_section, tab (10000)
*Sees how accout code is coded, up to 10000 iterations (it's a lot of tab rows but it never hurts to be safe) I want to look at 1: expenditure and 4: revenue

drop if _account_code_section >1 & _account_code_section <4
*drops if our account code section is 2 or 3, 1 and 4 are expenditure and revenue respectively
*drop if _account_code_section == .
 *Unnecessary line, just to be safe
codebook _level_1_category, tab (10000)
*Sees how level 1 category is coded
drop if _level_1_category == .
*drops if level 1 category is == . this lets us get all of the labels that have actual data in them
foreach v of varlist entity_name-object_of_expenditure{
	drop `v'
}
*drops all of the redundant, red string variables, now we are left with just encoded variables.
drop snapshot_date
*drops an unnecessary column of snapshot_date  

*******************************************************************************

collapse (sum) amount, by(calendar_year _entity_name _level_1_category)
*collapses/sums our amounts by calendar year and entity name
codebook _level_1_category, tab (1000)
*codebook for our _level_1_category
reshape wide amount, i(calendar_year _entity_name) j(_level_1_category)
*reshapes our dataset with year and entity name as our index and level 1 category as our columns
*******************************************************************************
rename amount1 charges_for_servics
rename amount2 charges_to_other_govs
rename amount3 community_servcs
rename amount4 culture_n_rec
rename amount5 debt_service
rename amount6 economic_devlpmnt
rename amount7 education
rename amount8 employee_bnfts
rename amount9 fed_aid
rename amount10 gen_gov
rename amount11 health
rename amount12 other_loc_rev
rename amount13 other_nonprop_tax
rename amount14 other_realprop_tax
rename amount15 other_sources
rename amount16 other_uses
rename amount17 proceeds_of_debt
rename amount18 public_safety
rename amount19 real_prop_tax_n_assmts
rename amount20 sales_n_use_tax
rename amount21 sanitation
rename amount22 social_services
rename amount23 state_aid
rename amount24 transportation
rename amount25 use_n_sale_of_property
rename amount26 utilities
*renames all of the variables based on our codebook's description

gen local_taxes = other_nonprop_tax + other_realprop_tax + real_prop_tax_n_assmts + sales_n_use_tax
*sums any taxes into a new variable named local_taxes

xtset _entity_name calendar_year
*tells stata we are working with panel data, now it goes year(2013-2023) by each entity (2013 Town of Adams, 2014 Town of Adams,...2023 Town of Adams, 2013 Town of Addison)
xtreg gen_gov fed_aid state_aid local_taxes
*runs our random effects model 
eststo random
*stores random effects model called random
xtreg gen_gov fed_aid state_aid local_taxes i.calendar_year, fe 
eststo fixed_no_cluster
*LSDV for time fixed effects, fe for unit fixed effects, without clustered standard errors we can underestimate the standard errors and potentially fail to reject a hypothesis we should reject. 
xtreg gen_gov fed_aid state_aid local_taxes i.calendar_year, fe vce(cluster _entity_name)
eststo fixed_cluster
*for talking about the same fixed effects regression as above just with clustered standard errors, should increase SE and make 
esttab random fixed_no_cluster fixed_cluster using "RE_FE_FEC.doc"
*puts my random effects model, two way FE model without and with clustered SE into a document called RE_FE_FEC

xtreg public_safety fed_aid state_aid local_taxes i.calendar_year, fe vce(cluster _entity_name)
*runs the two way fixed effects model with clustered standard errors with public safety spending as the dependent variable.
eststo public_safety_reg
* eststo is an estimate storage, with the title social_services_reg
xtreg social_services fed_aid state_aid local_taxes i.calendar_year, fe vce(cluster _entity_name)
*runs the two way fixed effects model with clustered standard errors with public safety spending as the dependent variable. 
eststo social_services_reg
*Estimate storage, with the title of social_services_reg
esttab fixed_cluster public_safety_reg social_services_reg using "GenGov_PubServ_SocServ.doc"
*this exports regression stuff to a separate doc named "GenGov_PubServ_SocServ.doc"
***********************************************************************************
*For Graphs
twoway scatter gen_gov calendar_year,  ytitle("General Government Spending") xtitle("Calendar Year") title("General Government Spending Over Time")
*Provides a scatter plot of general government over time
twoway scatter public_safety calendar_year, ytitle("Public Safety Spending") xtitle("Calendar Year")title("Public Safety Spending Over Time")
*Public safety spending over time
twoway scatter social_services calendar_year, ytitle("Social Services") xtitle("Calendar Year") title("Social Services Spending Over Time")
*Social service spending over time

*all of these next chunks follow the same pattern: Save data before collapsing (preserve) -> collapse data by mean for each year ->use collapsed data to more smoothly see average spending trend over the years -> restore pre-collapsed data. Done 3 times to show trends in each of my dependent variables.
preserve
collapse (mean) gen_gov, by(calendar_year)
twoway (scatter gen_gov calendar_year) (lfit gen_gov calendar_year,legend(off) xtitle("Calendar Year") ytitle("Mean General Gov. Spending") title("Mean General Government Spending Over Time"))
restore
*General Government Spending
preserve
collapse (mean) public_safety, by(calendar_year)
twoway (scatter public_safety calendar_year) (lfit public_safety calendar_year, legend(off) xtitle("Calendar Year") ytitle("Mean Public Safety Spending") title("Mean Public Safety Spending Over Time"))
restore
*Public Safety Spending
preserve
collapse (mean) social_services, by(calendar_year)
twoway (scatter social_services calendar_year) (lfit social_services calendar_year, legend(off)xtitle("Calendar Year") ytitle("Mean Social Services Spending") title("Mean Social Services Spending Over Time"))
restore
*Social Services Spending
