set more on 

use brfss_final, clear

*apply sample weights 
svyset [pw = _finalwt], clear
svyset [pw = _finalwt], strata(_ststr) psu(_psu)

*Code for the first paragraph in results - (An overview of the data)
 
svy:tab diabete2_n if _age65yr == 2
*Prevalance 20.53
*numbers from below - 136,270 total 65> pop and  26,454 with diab
tab diabete2_n if  _age65yr == 2
*numbers from below - 16,327 - diab and non-rural and 9,365 for diab and rural.
tab diabete2_n mscode_n if  _age65yr == 2

*Table 1 
*Demographic and Health Service Characteristics of Older U.S. Adults with Diabetes by Geographic Locale (Rural or Non-Rural)

*Demographic Variables
svy:tab mscode_n sex_n if _age65yr == 2 & diabete2_n == 1, row  
svy:tab mscode_n race_eth if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n educag_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n marital_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n income2_n if _age65yr == 2 & diabete2_n == 1, row  
*Health services variable
svy:tab mscode_n hlthplan_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n medcost_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n persdoc2_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n checkup1_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n genhlth_n if _age65yr == 2 & diabete2_n == 1, row 

*Table 2 
*Diabetes Health Care Characteristics of Older U.S. Adults with Diabetes by Geographic Locale (Rural or Non-Rural)
svy:tab mscode_n diabage2_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n insulin_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n bmi4_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n phy_act if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n smoker3_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n diabeye_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n bldsugar_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n feetchk2_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n bphigh4_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n controlled_bp if _age65yr == 2 & diabete2_n == 1, row
svy:tab mscode_n cholchk_n if _age65yr == 2 & diabete2_n == 1, row
svy:tab mscode_n flushot3_n if _age65yr == 2 & diabete2_n == 1, row
svy:tab mscode_n pneuvac3_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n diabedu_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n doctdiab_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n chkhemo3_n if _age65yr == 2 & diabete2_n == 1, row
svy:tab mscode_n feetchk_n if _age65yr == 2 & diabete2_n == 1, row 
svy:tab mscode_n eyeexam_n if _age65yr == 2 & diabete2_n == 1, row
svy:tab mscode_n ade_diab if _age65yr == 2 & diabete2_n == 1, row 

*Table 3 


* First regression model - for all older adults with diabetes 

logistic ade_diab sex_n i.race_eth i.educag_n marital_n income2_n mscode_n genhlth_n i.diabage2_n insulin_n i.bmi4_n phy_act smoker3_n hlthplan_n medcost_n persdoc2_n checkup1_n [pw = _finalwt] if _age65yr == 2 & diabete2_n == 1

*second regression model for all older adults with diabetes in the rural region 

logistic ade_diab sex_n i.race_eth i.educag_n marital_n income2_n genhlth_n i.diabage2_n insulin_n i.bmi4_n phy_act smoker3_n hlthplan_n medcost_n persdoc2_n checkup1_n [pw = _finalwt] if _age65yr == 2 & diabete2_n == 1 & mscode_n == 1

*************imputation**************

reg ade_diab sex_n i.race_eth i.educag_n marital_n income2_n mscode_n genhlth_n i.diabage2_n insulin_n i.bmi4_n phy_act smoker3_n hlthplan_n medcost_n persdoc2_n checkup1_n if _age65yr == 2 & diabete2_n == 1

***test for pattern in missingness***
gen ade_diab_miss = 1 if ade_diab == .
replace ade_diab_miss = 0 if ade_diab ~= .

***Check to see correlation to the missing values ***
reg ade_diab_miss sex_n i.race_eth i.educag_n marital_n income2_n mscode_n genhlth_n i.diabage2_n insulin_n i.bmi4_n phy_act smoker3_n hlthplan_n medcost_n persdoc2_n checkup1_n if _age65yr == 2 & diabete2_n == 1

* We can see that the data is not entirely missing at random - the following variables have their pvalue < 0.05, which is significant. 

***We check to see again if the pattern in missingness is corelated to the following variable***
reg ade_diab_miss sex_n
reg ade_diab_miss educag_n 
reg ade_diab_miss i.bmi4_n
reg ade_diab_miss phy_act
reg ade_diab_miss hlthplan_n

*We find that they are significant and we decided to not go ahead with imputing the missing variables using simple linear regression to guide imputation because the data is biased and co-linear/co-related to ade_diab variable. (Which is the variable we want to impute). Similarly the other two variables that were computed was race_eth and phy_act and we had initially wanted to impute these variables too. However, it does not add any value to impute those variables without being able impute the dependant variable. 
***begin imputation***
*logistic ade_diab income2_n insulin_n medcost_n checkup1_n if _age65yr == 2 & diabete2_n == 1
*predict ade_diab_hat

********************************************************************************************************

*Additional Steps - 

* After trying to replicate the model we realise that many variables are not significant in the multivariate logistic model even if they are significant in the bivariate model, we think this is because the final logistic model is not parsimonious with 16 covariates. Hence, for our additional step we decided to conduct a step-wise model building process. From the previous regression models we eliminate all the variables that are not significant at the 95% level of significance (backward elimination) and conduct another logistic regression. 

*Additionally we also want to check if the level of care is the same among other conditions that an older individual would face, in this case we checked to see if an older individual with adequate care would also have less cardiovascular diseases (because of better care) in the rural region.

logistic ade_diab income2_n insulin_n medcost_n checkup1_n [pw = _finalwt] if _age65yr == 2 & diabete2_n == 1

*Stratified with cardiovascular 
*you had a heart attack, also called a myocardial infarction?

gen cvdinfr4_n = . 
replace cvdinfr4_n = 1 if cvdinfr4 == 1
replace cvdinfr4_n = 0 if cvdinfr4 == 2 
replace cvdinfr4_n = . if cvdinfr4 == 7 | cvdinfr4 == 9

* Cross Tabulate with geographic region 
svy:tab mscode_n ade_diab if _age65yr == 2 & cvdinfr4_n == 1, row

* Multivariable regression model 
logistic ade_diab mscode_n income2_n insulin_n medcost_n checkup1_n [pw = _finalwt] if _age65yr == 2 & cvdinfr4_n == 1

* All Results and findings are explained in the presentation. The end.

 
