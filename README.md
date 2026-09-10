# Public Spending in New York Towns Study
An empirical investigation into whether local government spending across New York towns is driven more by local tax revenue or intergovernmental aid, measured across three distinct spending categories.

## Overview
This project examines the determinants of local government spending across 914 New York towns over a ten year period from 2013 to 2023. Using panel data from the New York State Comptroller's Office, I estimate the causal impact of federal aid, state aid, and local tax revenue on three spending outcomes (general government spending, public safety, and social services) while controlling for unobserved town and time level variations through two-way fixed effects. Results suggest that the primary driver of spending varies meaningfully across categories, with intergovernmental aid dominating general government and social services spending while local taxes being the primary driver of public safety expenditures.

## Data
### Source: 
Office of the New York State Comptroller, Local Government Data (Financial Data for Local Governments) [Link to Data](https://wwe1.osc.state.ny.us/localgov/findata/financial-data-for-local-governments.cfm) 
For definitions of certain expenditures I used the corresponding [Glossary](https://wwe2.osc.state.ny.us/transparency/LocalGov/LocalGovGlossary.cfm)
### Time Period: 
2013 to 2023 (11 measured years)
### Sample Size: 
2,967 observations across 914 NY Towns
### Key Variables (refer to presentation for additional descriptive examples): 
#### Town Income:
**fed_aid -** total federal aid received by town (Sanitation, Economic Development, Transportation)

**state_aid -** total state aid received by town (Education, Health, Public Safety)

**local_taxes -** total local tax revenue (Property, Sales, and Non-Property taxes)
#### Town Expenditures:
**gen_gov -** total expenditures on general government needs (Administration, Zoning/Planning, Operations)

**public_safety -** total expenditures on public safety services (Police, Fire, EMS)

**social_services -** total expenditures on public assistance programs (Medicaid, Financial Assistance, Youth Services)

## How to Reproduce
### Requirements:
- Stata version 14 or higher
- "estout" package needed for esttab and eststo functions 
### Getting Data:
I got my data from the Office of the New York State Comptroller's Local Government Bulk Financial Data (linked above and [here](https://wwe1.osc.state.ny.us/localgov/findata/financial-data-for-local-governments.cfm)). In "detailed account-level data" (Scroll down on the link) I selected "Revenue, Expenditure and Balance Sheet Data" then, "Single Class of Government for All Years" and then "Town" in the dropdown menu, after which I downloaded all of the data in a zip file and converted each .csv file to .dta (See methodology step 1). 

## Methodology
### Step 1: Panel Data Construction
To begin I appended annual, cross-sectional files into a single panel dataset in STATA. Panel showed each entity's (town) income and expenditure data over 11 years. Since it was only 11 files I decided to convert each .csv file to .dta files by hand, however I would create a loop if expanding this project again.

<img width="1805" height="611" alt="image" src="https://github.com/user-attachments/assets/b8c6526b-3c1b-4159-8f04-f14f3fbbcc74" />

#### Screenshot 1.1

### Step 2: Encoding Variables
Since the variables were coded as a string, I needed to encode them within STATA. Additionally, I checked how the variables were coded to see which values corresponded with expenditures and revenues, dropped any values that were not expenditures or revenues, saw the coding of the variables once more, dropped any labels that were missing, and then dropped any redundant variables.

<img width="1803" height="647" alt="image" src="https://github.com/user-attachments/assets/81ada03b-4310-4178-ae05-af1396a44d75" />

#### Screenshot 2.1

### Step 3: Collapse/Reshape Data
Initially my data was very long (multiple entries for a given town and year) so I collapsed each revenue and expenditure category into a single item for each entry. Then, I  looked to see how it was coded before reshaping it so that each town and year combination  corresponded to one line full of all of the revenue and expenditure categories. 

<img width="1371" height="200" alt="image" src="https://github.com/user-attachments/assets/6ed1830b-cb06-4878-b7d5-b6c39bf5a7c5" />

#### Screenshot 3.1

### Step 4: Create Necessary Variables & Declare Panel
After reshaping my data, I renamed each of the variables into intuitive names. I then generated a variable to sum all the different streams of local tax revenue (local_taxes) and declared to STATA that panel data was being used (xtset).

<img width="1710" height="896" alt="image" src="https://github.com/user-attachments/assets/ae2f8c11-a985-415c-8df0-35e23d10eebb" />

#### Screenshot 4.1

### Step 5: Random Effects Regression + Fixed Effects Regressions (without and with clustered standard errors) 
The initial random effects regression was done to see the overall average effect that federal/state aid and local taxes had on general government spending. I then ran a two way fixed effects model without clustered standard errors to see how general government spending would be affected while accounting for variations within units (unit fixed effects) and variations that affect all units simultaneously, over time (time fixed effects). I then clustered my standard errors to more accurately estimate the value of them, as clustering accounts for the correlation within general government spending within units: for example one town may consistently spend more than another town, without clustered standard errors this consistent excess spending is treated as multiple entries and ultimately undervalues our standard errors, despite not changing the coefficient of each independent variable. Not clustering may produce inaccurate T-statistics and could ultimately misrepresent the significance of each coefficient. (See screenshot 5.2, red shows the changed standard errors, blue shows changed t-statistics. Regression output on the left is without clustered SE, with clustered SE on the right.) Regressions were then output to a word document using esttab.

<img width="1754" height="356" alt="image" src="https://github.com/user-attachments/assets/3a4de592-bb10-46f7-b1ba-b651129df7f2" />

#### Screenshot 5.1

<img width="686" height="254" alt="image" src="https://github.com/user-attachments/assets/14f26819-71f0-4cb2-aa33-6e7edf1837ed" />

#### Screenshot 5.2

### Step 6: Remaining Regressions
The remaining regressions (where public safety spending and social services spending are the dependent variables respectively) were conducted using the same two-way fixed effects model that was used for general government spending (with clustered standard errors). Regressions were then output onto a word document using esttab.

<img width="1715" height="260" alt="image" src="https://github.com/user-attachments/assets/88ab9ee3-4a61-4727-b9b9-bed11a714b53" />

#### Screenshot 6.1

### Step 7: Graphs
Plotting some graphs helped to see the trend for each of the three dependent variables over time. A scatter plot showed each individual data point, and an lfit line where spending was averaged for each year proved to show the overall trend clearer.

<img width="854" height="257" alt="image" src="https://github.com/user-attachments/assets/50a95764-1556-45b9-b9ba-987120df1cf3" />

#### Screenshot 7.1

<img width="787" height="472" alt="image" src="https://github.com/user-attachments/assets/9d35a129-dfa2-4efd-8546-0fd8e37c7db5" />

#### Screenshot 7.2

## Findings

<img width="332" height="539" alt="image" src="https://github.com/user-attachments/assets/c4ec7d3c-f660-4d33-9345-7f669db2c78c" />

The above table shows estimates from three panel regressions predicting general government spending. Column 1 shows a random effects model, column 2 shows a fixed effects model with conventional standard errors, and column 3 shows a fixed effects model with standard errors clustered by town.
Within the random effects model, all of the sources of revenue are shown to be highly statistically significant (at the 0.1% significance level). Once two way fixed effects are incorporated into the model, local taxes no longer become statistically significant (t statistic is < ~2) but both federal aid and state aid remain significant. Clustering the standard errors by town provided the most scrutinous look at the data, as doing so made both state aid and local taxes statistically insignificant with studying their effect on general government spending. The third column shows how general government spending primarily comes from federal aid, and the probability that state aid and local taxes contributed to general government spending is so small that it could be attributed to random chance. One conflicting data point was the coefficient for general government spending as the interpretation is that a $1 increase in federal aid, causes $23 dollars worth of extra spending. This is a confusing magnitude, but I would conduct a deeper dive into it in my expansion of this project specifically by conducting a Least Squared Dummy Variable regression where each town has a unique dummy variable. This would more clearly show if one town is skewing the regression coefficients or if there is an error somewhere within the data. Additionally, there is a relatively noisy trend in spending over years for general government, as some years are spending much more than 2013 (2014-16,2020) but some are less (2017-2019, 2021-2023). None are statistically significant however, so this variation can be attributed to random chance. 

<img width="332" height="539" alt="image" src="https://github.com/user-attachments/assets/b4f74adc-f91a-4884-a0d3-793a4234da0c" />

Applying the same framework from column 3 to public safety and social service spending, we get the results seen in the above screenshot. For public safety spending, federal aid and local taxes seem to be the main sources of funding, with two results significant at the 0.1% significance level ($1 in federal aid corresponds with ~ 5 cent increase & $1 in local taxes corresponds with ~ 17 cent increase in public safety spending on average) This finding is intuitive (as more money comes in from both the federal government and local taxes, towns are more able to spend on public safety) and is a magnitude that makes sense. For spending in each year relative to 2013, only two years saw less public safety spending (2014 and 2015) while the remaining years had positive coefficients. The only two years that provide real significant difference are 2022 and 2023. 2022 saw $97,063 more spending than 2013 (significant at 5% level); 2023 experienced $231,862 more spending than 2013 (significant at 0.1% level). 
Unfortunately no coefficients were statistically significant in changing social services spending, however I will interpret them like they are. Additionally, not all of the towns measured took track of social services spending so the number of observations for this regression is considerably lower than the other two spending metrics. Federal aid and local taxes had very small impacts on overall social services spending, with a difference of less than 1 cent (0.009 dollars = 0.9 cents) and 3 cents respectively. After 2014, there was a trend of higher spending relative to 2013 (2014 is the only year with a negative coefficient, signifying that there was less spending when compared to the reference year of 2013). 2022 saw the highest spread between the reference category, with $209,250 more in spending on social services than 2013.

## Planned Extensions
For the future I would like to include more geographical entities (towns) in my dataset. Whether that involves adding another state's towns or more years I would certainly expand my data in the future. An interesting expansion is to include all 50 states US town to see how spending patterns vary across states and different geographical regions. Another approach is to control for the following variables, with explanations included:

**Total federal spending:** My hypothesis is that as the federal government spends more, more of this money would be directed on providing aid to towns and would ultimately increase spending on general government, public safety, and social services. 

**Town population:** I hypothesize that for two towns, all else being equal, the town with a higher population will spend more on general government needs, public safety, and social services as a result of higher demand for these facilities resulting from a larger population. An alternative hypothesis could be that larger towns have more economic activity, which can contribute to more jobs, higher income, less wealth inequality and less crime, which may reduce the need for as much spending on public safety and social services (in this case I believe a higher population relates to more administrative work for a town and would result in higher general government spending). 

**Median Income:** My hypothesis is similar to that of the town population's alternative hypothesis. I hypothesize that if median income were higher, general government spending may not be impacted much, however, public safety and social services would see lesser spending than previously as public safety may not be as big of an issue in towns with less economic inequality. 

I would additionally dive deeper into my general government coefficient, as it seems a little higher than I would expect and I would like to know why (see findings section). Additionally, I would improve my code to run more efficiently. After taking more Econometrics and Data Analysis classes I was able to see how inefficient it was to convert and append each of my yearly .csv files by hand. I could certainly expand the scope of my research if I made my code more efficient, but I am happy to use this as a reference for both my growth and ability now!

This project was conducted as a final for Econometrics: Models and Organizations (ECO 385) at Pace University (Dyson College of Arts and Sciences). Data sourced from the Office of the New York State Comptroller Local Government Bulk Data portal.
