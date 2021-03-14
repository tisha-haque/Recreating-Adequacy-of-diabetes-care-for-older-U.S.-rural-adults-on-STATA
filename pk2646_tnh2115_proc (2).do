* We fist downloaded the raw dataset from CDC and then changed the working directory to the folder that contains the dataset. In the next step we import the data into stata.*]
set more on 
import sasxport5 CDBRFS09.XPT, clear
save brfss09, replace

use brfss09, clear

* We made a list of variables used in the study and in the next few steps we clean the data and keep the variables of interest. Some variables need to be re-coded and others need to be computed

*creating variable for table 1 and 2 

*1. Metroopolitan Statistical Area (MSA) - define place of residence and was re-coded into the dichotomous categories of rural and non-rural. 
*    1. Rural residents were defined as people living either within an MSA that had no city center or outside an MSA. Non-rural residents included all respondents living in a center city of an MSA, outside the center city of an MSA but inside the county containing the center city, or inside a suburban county of the MSA. 

recode mscode (1 2 3 = 0) (4 5 = 1), gen(mscode_n)
label define mscodef 1 "Rural" 0 "Non-Rural"
label values mscode_n mscodef

tab mscode_n 

*2. Computed - Adequacy of diabetes care - For our analyses, we created a diabetes care index from the following eleven bifurcated variables: 1) self-glucose test at least daily, 2) self-foot check at least daily, 3) have controlled blood pressure, 4) had cholesterol checked in past 12 months, 5) had flu vaccination in past 12 months, 6) had lifetime pneumonia vaccination, 7) had 2 diabetes checks in past 12 months, 8) health care provider checked A1c twice in past 12 months, 9) health care provider checked feet twice in past 12 months, 10) had dilated eye exam in past 12 months, and 11) have had lifetime diabetes edu- cation. These variables were chosen because they reflected clinical practice recommendations for older adults with diabetes [5,9-11]. Respondents were excluded from the analysis if data were missing on any aspect of the adequacy variable.
*    1. “adequate care” as adults with diabetes who received at least nine of the 11 interventions. 
*    2. Less than adequate care was defined as getting eight or fewer of these 11 care interventions. 

* zero is no and 1 is yes for all 

* self-glucose test at least daily
gen bldsugar_n = .
replace bldsugar_n = 1 if bldsugar >= 101 & bldsugar <=199
replace bldsugar_n = 0 if bldsugar >= 201 & bldsugar <=499
replace bldsugar_n = . if bldsugar == 777| bldsugar == 999

label define bldsugarf 1 "at least daily" 0 "not daily"
label values bldsugar_n bldsugarf
tab bldsugar_n

*self-foot check at least daily,

gen feetchk2_n = .
replace feetchk2_n = 1 if feetchk2 >= 101 & feetchk2 <=199
replace feetchk2_n = 0 if feetchk2 >= 201 & feetchk2 <=499
replace feetchk2_n = . if feetchk2 == 777| feetchk2 == 999
replace feetchk2_n =  . if feetchk2 == 555
label define feetchk2f 1 "at least daily" 0 "not daily"
label values feetchk2_n feetchk2f

tab feetchk2_n

*have controlled blood pressure - will be computed later

*had cholesterol checked in past 12 months

gen cholchk_n = .
replace cholchk_n = 1 if cholchk == 1
replace cholchk_n = 0 if cholchk == 2 | cholchk == 3 |cholchk == 4
replace cholchk_n = . if cholchk == 7| cholchk == 9
label define cholchkf 1 "Yes" 0 "No"
label values cholchk_n cholchkf
tab cholchk_n

*had flu vaccination in past 12 months

gen flushot3_n = .
replace flushot3_n = 1 if flushot3 == 1 
replace flushot3_n = 0 if flushot3 == 2
replace flushot3_n = . if flushot3 == 7 | flushot3 == 9
label define flushot3f 1 "Yes" 0 "No"
label values flushot3_n flushot3f

tab flushot3_n

*had lifetime pneumonia vaccination

gen pneuvac3_n = . 
replace pneuvac3_n = 1 if pneuvac3 == 1 
replace pneuvac3_n = 0 if pneuvac3 == 2
replace pneuvac3_n = . if pneuvac3 == 7 | pneuvac3 == 9
label define pneuvac3f 1 "Yes" 0 "No"
label values pneuvac3_n pneuvac3f
tab pneuvac3_n

*had 2 diabetes checks in past 12 months

gen doctdiab_n = .
replace doctdiab_n = 1 if doctdiab >= 2 & doctdiab <= 76
replace doctdiab_n = 0 if doctdiab == 88 | doctdiab < 2
replace doctdiab_n = . if doctdiab == 77 | doctdiab == 99
label define doctdiabf 1 "Yes" 0 "No"
label values doctdiab_n doctdiabf
tab doctdiab_n

*health care provider checked A1c twice in past 12 months, 

gen chkhemo3_n = .
replace chkhemo3_n = 1 if chkhemo3 >= 2 & chkhemo3 <= 76
replace chkhemo3_n = 0 if chkhemo3 == 88 | chkhemo3 < 2 |chkhemo3 == 98
replace chkhemo3_n = . if chkhemo3 == 77 | chkhemo3 == 99
label define chkhemo3f 1 "Yes" 0 "No"
label values chkhemo3_n chkhemo3f

tab chkhemo3_n

*health care provider checked feet twice in past 12 months, 

gen feetchk_n = .
replace feetchk_n = 1 if feetchk >= 2 & feetchk <= 76
replace feetchk_n = 0 if feetchk == 88 | feetchk < 2
replace feetchk_n = . if feetchk == 77 | feetchk == 99
label define feetchkf 1 "Yes" 0 "No"
label values feetchk_n feetchkf
tab feetchk_n

*had dilated eye exam in past 12 months,

gen eyeexam_n = . 
replace eyeexam_n = 1 if eyeexam == 1 | eyeexam == 2
replace eyeexam_n = 0 if eyeexam == 3 | eyeexam == 4 |eyeexam == 8
replace eyeexam_n = . if eyeexam == 7 | eyeexam == 9
label define eyeexamf 1 "Yes" 0 "No"
label values eyeexam_n eyeexamf
tab eyeexam_n

*have had lifetime diabetes education.

gen diabedu_n = . 
replace diabedu_n = 1 if diabedu == 1
replace diabedu_n = 0 if diabedu == 2
replace diabedu_n = . if diabedu == 7 | diabedu == 9
label define diabeduf 1 "Yes" 0 "No"
label values diabedu_n diabeduf
tab diabedu_n

*Race and ethnicity

*First variable - If a person identifies as hispanic or not.

gen hispanc2_n = . 
replace hispanc2_n = 1 if hispanc2 == 1
replace hispanc2_n = 0 if hispanc2 == 2
replace hispanc2_n  = . if hispanc2 == 7 | hispanc2 == 9
label define hispanc2f 1 "Yes" 0 "No"
label values hispanc2_n hispanc2f
tab hispanc2_n

*second variables - The race the person identifies with 

gen orace2_n = orace2 
replace orace2_n = . if orace2 == 7 | orace2 == 9
recode orace2_n (8 = 7)

tab orace2_n

* compute the variable

gen race_eth = .
replace race_eth = 0 if orace2_n ==1
replace race_eth = 1 if orace2_n ==2
replace race_eth = 2 if hispanc2_n == 1 
replace race_eth = 3 if orace2_n == 3 | orace2_n == 4 |orace2_n == 5 | orace2_n == 6 | orace2_n == 8 


label define race_ethf 0 "Caucasian" 1 "African American" 2 "Hispanic" 3 "other/multiracial"
label values race_eth race_ethf
tab race_eth

*We want to note that the explanation provided by the authors for the coding of the race and ethnicity variable is confusing- we are unsure if they intended to code those who identifies as hispanic first and then divide the rest of the population as Caucasian, African American and other/multiracial. Furthermore the code book includes Asian, Alaska/Native American etc, we are unsure if the authors intented to code all of them in these categories as "Other". We had come to a consenses and coded the variable depending on our interpretation of what the author intended.

* Controlled blood pressure

*fist variable - Do you have hyertension ?

gen bphigh4_n = . 
replace bphigh4_n = 1 if bphigh4 == 1 | bphigh4 == 2
replace bphigh4_n = 0 if bphigh4 == 3 | bphigh4 == 4
replace bphigh4_n = . if bphigh4 == 7 | bphigh4 == 9 
label define bphigh4f 1 "Yes" 0 "No"
label values bphigh4_n bphigh4f
tab bphigh4_n

*second variable - Are you taking medication for hypertension ?

gen bpmeds_n = . 
replace bpmeds_n = 1 if bpmeds == 1 
replace bpmeds_n = 0 if bpmeds == 2
label define bpmedsf 1 "Yes" 0 "No"
label values bpmeds_n bpmedsf
tab bpmeds_n 

* compute variable - Combining both the above variable to form the categories. 

gen controlled_bp = 0 
replace controlled_bp = 1 if bphigh4_n == 1 & bpmeds_n == 1 
replace controlled_bp = 0 if bphigh4_n == 0 & bpmeds_n == 0
label define controlled_bpf 1 "Yes" 0 "No"
label values controlled_bp controlled_bpf

tab controlled_bp

* Creating the Adequacy of diabetes care variable - Do you have adequate care ? (Yes/No) - This variable is comuted by combining 11 other variables as follows.

gen ade = bldsugar_n + feetchk2_n + cholchk_n + flushot3_n + pneuvac3_n + doctdiab_n + chkhemo3_n + feetchk_n + eyeexam_n + diabedu_n + controlled_bp

gen ade_diab = ade 
replace ade_diab = 0 if ade >= 9 & ade <= 11
replace ade_diab = 1 if ade < 9 & ade > 0
replace ade_diab = 999 if ade == .
replace ade_diab = . if ade_diab == 999
label define ade_diabf 0 "Yes" 1 "No"
label values ade_diab ade_diabf
tab ade_diab

*Level of physical activity

*fist variable - Do you perform moderate excercise?
gen modpact_n = .
replace modpact_n = 1 if modpact == 1 
replace modpact_n = 0 if modpact == 2 

tab modpact_n

*second variable Do you perform vigorous excercise?
gen vigpact_n = .
replace vigpact_n = 1 if vigpact == 1 
replace vigpact_n = 0 if vigpact == 2 

tab vigpact_n

*computed physical activity variable - by combining the two variables

gen phy_act = . 
replace phy_act = 1 if modpact_n == 0 | vigpact_n == 0
replace phy_act = 0 if modpact_n == 1 | vigpact_n == 1
label define phy_actf 0 "Yes" 1 "No"
label values phy_act phy_actf
tab phy_act

* 5. Re-coded - Education (Did Not Graduate From High School/ Graduated From HS/College Graduate).. -- no education as reference

gen educag_n=. 
replace educag_n=0 if _educag==4
replace educag_n=1 if _educag==1
replace educag_n=2 if _educag==2 | _educag==3

replace educag_n =. if _educag==9

tab educag_n

label define educag_f 0 "College Graduate" 1 "Did Not Graduate From High School" 2 "Graduated From HS" 
label values educag_n educag_f

tab educag_n

* 6. Re-coded-Annual Household Income (< $35,000/> = 35,000) 

gen income2_n =.
replace income2_n=0 if income2 ==1 | income2 ==2| income2 ==3| income2 ==4 | income2 ==5
replace income2_n=1 if income2 ==6 | income2 ==7| income2 ==8
replace income2_n=. if income2_n == 77 | income2_n == 99

tab income2_n 

label define income2_f 0 " > $35,000" 1 "<= $35,000"
label values income2_n income2_f

tab income2_n 

* 7. Re-coded-Marital Status (Married or Living with Partner/ Unmarried and Not Living With a Partner)-- not living with partner as a reference

gen marital_n =.
replace marital_n=1 if marital ==2 | marital ==3 | marital==4 | marital==5 
replace marital_n=0 if marital==1 | marital==6
replace marital_n=. if marital == 9

tab marital_n

label define marital_f 1 "Unmarried and Not Living With a Partner " 0 "Married or Living with Partner"
label values marital_n marital_f

tab marital_n

* 8. Re-coded-Self-Reported Health Status (Fair To Poor Health/ Good To Excellent Health)

gen genhlth_n =.
replace genhlth_n=0 if genhlth ==1 | genhlth ==2 | genhlth ==3
replace genhlth_n=1 if genhlth ==4 | genhlth ==5
replace genhlth_n=. if genhlth == 7 | genhlth == 9

tab genhlth_n

label define genhlth_f 0 "Good To Excellent Health " 1 "Fair To Poor Health"
label values genhlth_n genhlth_f

tab genhlth_n

* 9. Re-coded-Have Own Health Care Provider (Yes/No)--yes as reference

gen persdoc2_n =.
replace persdoc2_n=0 if persdoc2 ==1 | persdoc2 ==2
replace persdoc2_n=1 if persdoc2 ==3
replace persdoc2_n= . if persdoc2 ==7 | persdoc2 ==9

tab persdoc2_n

label define persdoc2_f 0 "Yes" 1 "No"
label values persdoc2_n persdoc2_f

tab persdoc2_n

* 10. Re-coded-BMI (BMI < 25/BMI 25- < 30/BMI > = 30)-- Body Mass Index (BMI)

gen bmi4_n = _bmi4/100
replace bmi4_n=1 if 25<= _bmi4/100 <=29
replace bmi4_n=0 if  _bmi4/100 <=24
replace bmi4_n=2 if _bmi4/100 >=30 
replace bmi4_n=. if _bmi4 == 9999

tab bmi4_n

label define bmi4_f 0 "BMI < 25" 1 "BMI 25- < 30" 2 "BMI > = 30"
label values bmi4_n bmi4_f

tab bmi4_n

* 11. Re-coded-Smoking Status (Yes/No)--- assuming former is no-- using no as reference

gen smoker3_n =.
replace smoker3_n=0 if _smoker3 ==3 | _smoker3 ==4
replace smoker3_n=1 if _smoker3 ==1 | _smoker3 ==2
replace smoker3_n= . if _smoker3 ==9 

tab smoker3_n

label define smoker3_f 0 "Non-smoker" 1 "smoker" 
label values smoker3_n smoker3_f

tab smoker3_n

* 12. Re-coded-Timing of Last Routine Medical Check-up (Within the Past 12 Months/More than 12 Months Ago)---About how long has it been since you last visited a doctor for a routine checkup?-- within past year - reference-- put never removed???

gen checkup1_n =.
replace  checkup1_n =0 if checkup1 ==1
replace checkup1_n=1 if checkup1 ==2 | checkup1 ==3 | checkup1 ==4
replace checkup1_n= . if checkup1 ==7 | checkup1 == 8 | checkup1 ==9

tab checkup1_n

label define checkup1_f 0 "Within the Past 12 Months" 1 "More than 12 Months Ago" 
label values checkup1_n checkup1_f

tab checkup1_n

* 13. Re-coded-Diabetes (Yes/No)--Have you ever been told by a doctor that you have diabetes (If "Yes" and respondent is female, ask "Was this only when you were pregnant?". If Respondent says pre-diabetes or borderline diabetes, use response code 4.) -- no as reference

gen diabete2_n =.
replace  diabete2_n =0 if diabete2 ==3 | diabete2 ==4
replace diabete2_n=1 if diabete2 ==1 | diabete2 ==2
replace diabete2_n= . if diabete2 ==7 | diabete2 == 9

tab diabete2_n

label define diabete2_f 0 "No" 1 "Yes" 
label values diabete2_n diabete2_f

tab diabete2_n

* 14. Re-coded-Insulin Use (Yes/No)--Are you now taking insulin? -- no as reference

gen insulin_n =.
replace  insulin_n =0 if insulin ==2
replace insulin_n=1 if insulin == 1
replace insulin_n= . if insulin == 9

tab insulin_n

label define insulin_f 0 "No" 1 "Yes" 
label values insulin_n insulin_f

tab insulin_n

* 15. Re-coded-Diabetes Has Affected Eyes (Yes/No) ---Has a doctor ever told you that diabetes has affected your eyes or that you had retinopathy?-- no as reference 

gen diabeye_n =.
replace diabeye_n=0 if diabeye == 2
replace diabeye_n=1 if diabeye == 1
replace diabeye_n= . if diabeye == 7 | diabeye == 9

tab diabeye_n

label define diabeye_f 0 "No" 1 "Yes" 
label values diabeye_n diabeye_f

tab diabeye_n

* 16. Re-code- Age at onset of diabetes (continuous) - was recoded into a categorical variable with three levels: < 45 years, 45-64 years, and ≥ 65 years. ---How old were you when you were told you have diabetes?

gen diabage2_n =.
replace diabage2_n=0 if diabage2 >= 0 & diabage2 <=44
replace diabage2_n=1 if diabage2 >=45 & diabage2 <=64
replace diabage2_n=2 if diabage2 >=65 & diabage2 <=97
replace diabage2_n=. if diabage2 == 98 | diabage2== 99

tab diabage2_n

label define diabage2_f 0 "< 45 years" 1 "45-64 years" 2 "≥ 65 years"
label values diabage2_n diabage2_f
tab diabage2_n

* 17. Indicate sex of respondent.-- male as reference

gen sex_n =.
replace sex_n=1 if sex == 1
replace sex_n=0 if sex == 2

tab sex_n

label define sex_f 1 "Male" 0 "Female" 
label values sex_n sex_f

tab sex_n

* 18. Do you have any kind of health care coverage, including health insurance, prepaid plans such as HMOs, or government plans such as Medicare?-- yes as reference 

gen hlthplan_n =.
replace hlthplan_n=0 if hlthplan == 1
replace hlthplan_n=1 if hlthplan ==2
replace hlthplan_n =. if hlthplan == 7 | hlthplan ==9

tab hlthplan_n

label define hlthplan_f 0 "Yes" 1 "No" 
label values hlthplan_n hlthplan_f

tab hlthplan_n

* question 19: Was there a time in the past 12 months when you needed to see a doctor but could not because of cost?  yes as reference

gen medcost_n =.
replace medcost_n=0 if medcost == 2
replace medcost_n=1 if medcost == 1
replace medcost_n =. if medcost == 7 | medcost ==9

tab medcost_n

label define medcost_f 0 "No" 1 "Yes" 
label values medcost_n medcost_f

tab medcost_n

save brfss_final, replace
