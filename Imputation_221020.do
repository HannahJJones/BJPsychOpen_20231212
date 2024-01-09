*PRS, inflammation, Psych mediation study - imputation 

***********************************
* Read in data 
***********************************	

*loading data
use "project_variables_clean_imputation.dta", clear

************************************************************************************************************************************************************************************************************************************************************************
***********************************
* Subsetting samples 
***********************************
***********************************
* calculating potential imputation starting sample sizes  
***********************************
** PRS:
* stdPGS_ANX_S1
* stdPGS_MDD_S1
* stdPGS_SCZ_S1
* stdPGS_PE_S1
sum stdPGS_ANX_S1 stdPGS_MDD_S1 stdPGS_SCZ_S1 stdPGS_PE_S1 // 7859 people have data available

* AT10_minq - any reported trauma 5-10 yrs w/ responses in 2+ categories for 0 missing
tab AT10_minq // 8700 people have data available

* Impute up to exposure sample, creating 2 datasets, one for trauma analysis, one for PRS analysis
* PRS
gen PRS_analysis_include = 1 if stdPGS_ANX_S1 <.

* Trauma
gen Trauma_analysis_include = 1 if AT10_minq <.

***********************************
* Creating datasets based on imputation starting sample sizes  
***********************************
* SAVE DATA FOR PRS ANALYSIS
preserve
keep if PRS_analysis_include ==1

*Variables to keep (103 vars):
keep aln qlet ///
pliks24TH_3C_binary negsymp_topdecile_24 mild_depression_24 mod_depression_24 severe_depression_24 any_anxiety_disorder_24 /// * outcomes, main @24
PE_18_binary negsymp_topdecile_16 mild_depression_18 mod_depression_18 severe_depression_18  any_anxiety_disorder_18 /// * outcomes, sensitivity @18
stdPGS_ANX_S1 stdPGS_ANX_S2 stdPGS_ANX_S3 stdPGS_ANX_S4 stdPGS_ANX_S5 stdPGS_ANX_S6 stdPGS_ANX_S7 stdPGS_ANX_S8 stdPGS_ANX_S9 stdPGS_ANX_S10 stdPGS_ANX_S11 stdPGS_ANX_S12 stdPGS_ANX_GWSig /// * ANX PRS exposures - DON'T IMPUTE
stdPGS_MDD_S1 stdPGS_MDD_S2 stdPGS_MDD_S3 stdPGS_MDD_S4 stdPGS_MDD_S5 stdPGS_MDD_S6 stdPGS_MDD_S7 stdPGS_MDD_S8 stdPGS_MDD_S9 stdPGS_MDD_S10 stdPGS_MDD_S11 stdPGS_MDD_S12 stdPGS_MDD_GWSig /// * MDD PRS exposures - DON'T IMPUTE
stdPGS_SCZ_S1 stdPGS_SCZ_S2 stdPGS_SCZ_S3 stdPGS_SCZ_S4 stdPGS_SCZ_S5 stdPGS_SCZ_S6 stdPGS_SCZ_S7 stdPGS_SCZ_S8 stdPGS_SCZ_S9 stdPGS_SCZ_S10 stdPGS_SCZ_S11 stdPGS_SCZ_S12 stdPGS_SCZ_GWSig /// * SCZ PRS exposures - DON'T IMPUTE
stdPGS_PE_S1 stdPGS_PE_S2 stdPGS_PE_S3 stdPGS_PE_S4 stdPGS_PE_S5 stdPGS_PE_S6 stdPGS_PE_S7 stdPGS_PE_S8 stdPGS_PE_S9 stdPGS_PE_S10 stdPGS_PE_S11 stdPGS_PE_S12 stdPGS_PE_GWSig /// * PE PRS exposures - DON'T IMPUTE
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 PC11 PC12 PC13 PC14 PC15 PC16 PC17 PC18 PC19 PC20 /// * PCs - DON'T IMPUTE
IL6_f9 CRP_f9 /// * Mediators
BMI_8 sex matSMKpreg patSMKpreg ParentalSoc AT10_minq /// * covariates
MFQccsScore /// * auxilliary for outcomes
rs2228145_c crp_TF3 /// * auxilliary for mediators
EPDSm_score BMI_7 patFamHistPsych matFamHistPsych matEdu homeOwnership // * auxilliary for outcomes
* AT10_minq /// * Trauma exposure - DON'T IMPUTE

save project_imputation_PRSanalysis.dta, replace 
restore

* SAVE DATA FOR TRAUMA ANALYSIS
preserve
keep if Trauma_analysis_include ==1

*Variables to keep (35 vars):
keep aln qlet  ///
pliks24TH_3C_binary negsymp_topdecile_24 mild_depression_24 mod_depression_24 severe_depression_24 any_anxiety_disorder_24 /// * outcomes, main @24
PE_18_binary negsymp_topdecile_16 mild_depression_18 mod_depression_18 severe_depression_18  any_anxiety_disorder_18 /// * outcomes, sensitivity @18
AT10_minq /// * Trauma exposure - DON'T IMPUTE
IL6_f9 CRP_f9 /// * Mediators
BMI_8 sex matSMKpreg patSMKpreg ParentalSoc stdPGS_ANX_S1 stdPGS_MDD_S1 stdPGS_SCZ_S1 stdPGS_PE_S1 /// * covariates
MFQccsScore  /// * aux for outcomes
rs2228145_c crp_TF3 /// * aux for mediators
EPDSm_score BMI_7 patFamHistPsych matFamHistPsych matEdu homeOwnership // * aux for covariates
*stdPGS_ANX_S2 stdPGS_ANX_S3 stdPGS_ANX_S4 stdPGS_ANX_S5 stdPGS_ANX_S6 stdPGS_ANX_S7 stdPGS_ANX_S8 stdPGS_ANX_S9 stdPGS_ANX_S10 stdPGS_ANX_S11 stdPGS_ANX_S12 stdPGS_ANX_GWSig /// * ANX PRS exposures - DON'T IMPUTE
*stdPGS_MDD_S2 stdPGS_MDD_S3 stdPGS_MDD_S4 stdPGS_MDD_S5 stdPGS_MDD_S6 stdPGS_MDD_S7 stdPGS_MDD_S8 stdPGS_MDD_S9 stdPGS_MDD_S10 stdPGS_MDD_S11 stdPGS_MDD_S12 stdPGS_MDD_GWSig /// * MDD PRS exposures - DON'T IMPUTE
*stdPGS_SCZ_S2 stdPGS_SCZ_S3 stdPGS_SCZ_S4 stdPGS_SCZ_S5 stdPGS_SCZ_S6 stdPGS_SCZ_S7 stdPGS_SCZ_S8 stdPGS_SCZ_S9 stdPGS_SCZ_S10 stdPGS_SCZ_S11 stdPGS_SCZ_S12 stdPGS_SCZ_GWSig /// * SCZ PRS exposures - DON'T IMPUTE
*stdPGS_PE_S2 stdPGS_PE_S3 stdPGS_PE_S4 stdPGS_PE_S5 stdPGS_PE_S6 stdPGS_PE_S7 stdPGS_PE_S8 stdPGS_PE_S9 stdPGS_PE_S10 stdPGS_PE_S11 stdPGS_PE_S12 stdPGS_PE_GWSig /// * PE PRS exposures - DON'T IMPUTE
*PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 PC11 PC12 PC13 PC14 PC15 PC16 PC17 PC18 PC19 PC20 /// * PCs - DON'T IMPUTE

save project_imputation_TraumaAnalysis.dta, replace 
restore

************************************************************************************************************************************************************************************************************************************************************************
***********************************
* Create imputed datasets 
***********************************	
***********************************
* PRS analyses
 
**using log to save all output of the imputation in a file: 
set linesize 255 
log using "MI_log_261022_prs.log", replace

use project_imputation_PRSanalysis.dta, clear 
drop *S2 *S3 *S4 *S5 *S7 *S8 *S9 *S10 *S11 *S12 PC11 PC12 PC13 PC14 PC15 PC16 PC17 PC18 PC19 PC20

* making sure all missing values are set to .
foreach var of varlist sex rs2228145_c homeOwnership matEdu CRP_f9 IL6_f9 crp_TF3 mild_depression_18 mod_depression_18 ///
severe_depression_18 mild_depression_24 mod_depression_24 severe_depression_24 PE_18_binary pliks24TH_3C_binary stdPGS_ANX_S1 ///
stdPGS_ANX_S6 stdPGS_ANX_GWSig stdPGS_MDD_S1 stdPGS_MDD_S6 stdPGS_MDD_GWSig stdPGS_SCZ_S1 stdPGS_SCZ_S6 stdPGS_SCZ_GWSig stdPGS_PE_S1 ///
stdPGS_PE_S6 stdPGS_PE_GWSig PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 negsymp_topdecile_24 any_anxiety_disorder_24 any_anxiety_disorder_18 ///
negsymp_topdecile_16 BMI_8 matSMKpreg patSMKpreg ParentalSoc EPDSm_score matFamHistPsych patFamHistPsych MFQccsScore BMI_7 AT10_minq {
    replace `var' =. if `var' >.
}

mi set wide // prepares dataset as a multiple imputation dataset in wide format (one column per imputation per variable) + sets all the vars as unregistered. + sets M = 0
mi misstable summarize // to identify missing values. this command reports the variables contaning missing values

mi register imputed 			pliks24TH_3C_binary negsymp_topdecile_24 mild_depression_24 mod_depression_24 severe_depression_24 any_anxiety_disorder_24 /// * outcomes, main @24
					PE_18_binary negsymp_topdecile_16 mild_depression_18 mod_depression_18 severe_depression_18  any_anxiety_disorder_18 /// * outcomes, sensitivity @18
					IL6_f9 CRP_f9 /// * Mediators
					BMI_8 sex matSMKpreg patSMKpreg ParentalSoc AT10_minq /// * covariates
					MFQccsScore  /// * aux for outcomes		
					crp_TF3	/// * aux for mediators	
					EPDSm_score BMI_7 patFamHistPsych matFamHistPsych matEdu homeOwnership /// * aux for outcomes
					rs2228145_c // * aux for mediators
mi register regular 			aln qlet /// *IDs
					stdPGS_ANX_S1 stdPGS_ANX_S6 stdPGS_ANX_GWSig /// * ANX PRS exposures
					stdPGS_MDD_S1 stdPGS_MDD_S6 stdPGS_MDD_GWSig /// * MDD PRS exposures
					stdPGS_SCZ_S1 stdPGS_SCZ_S6 stdPGS_SCZ_GWSig /// * SCZ PRS exposures
					stdPGS_PE_S1 stdPGS_PE_S6 stdPGS_PE_GWSig /// * PE PRS exposures
					PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 // * PCs
					

mi describe, detail // provides a more detailed report on mi data

* run the imputation model, specifying the type of regression used to impute each variable
* from help file: 
*    regress               linear regression for a continuous variable
*    pmm                   predictive mean matching for a continuous variable
*    truncreg              truncated regression for a continuous variable with a restricted range
*    intreg                interval regression for a continuous partially observed (censored) variable
*    logit                 logistic regression for a binary variable
*    ologit                ordered logistic regression for an ordinal variable [ORDINAL = categorical var. with values ordered]
*    mlogit                multinomial logistic regression for a nominal variable [NOMINAL =  categorical var with no intrinsic order of the categories]
*    poisson               Poisson regression for a count variable 
*    nbreg                 negative binomial regression for an overdispersed count variable [overdispersion: the presence of greater variability (statistical dispersion) than would be expected][NOTE THIS IS FOR COUNT VARS.]

***********************************	
*** PRS ANALYSIS DATA:
mi impute chained			(regress) 		BMI_8 BMI_7 /// 
					(pmm, knn(10)) 		IL6_f9 CRP_f9 MFQccsScore crp_TF3 EPDSm_score ///
					(logit) 		pliks24TH_3C_binary negsymp_topdecile_24 any_anxiety_disorder_24 ///
									PE_18_binary negsymp_topdecile_16 any_anxiety_disorder_18 matEdu ///
									sex matSMKpreg patSMKpreg patFamHistPsych matFamHistPsych AT10_minq /// 
					(logit, 		omit(i.mod_depression_24 i.severe_depression_24)) mild_depression_24 ///
					(logit, 		omit(i.mild_depression_24 i.severe_depression_24)) mod_depression_24 ///					
					(logit, 		omit(i.mod_depression_24 i.mild_depression_24)) severe_depression_24 ///				
					(logit, 		omit(i.mod_depression_18 i.severe_depression_18)) mild_depression_18 ///
					(logit, 		omit(i.mild_depression_18 i.severe_depression_18)) mod_depression_18 ///					
					(logit,		 	omit(i.mod_depression_18 i.mild_depression_18)) severe_depression_18 ///					
					(ologit) 		ParentalSoc rs2228145_c /// 
					(mlogit)  		homeOwnership /// 
					= 				stdPGS_ANX_S1 stdPGS_ANX_S6 stdPGS_ANX_GWSig ///
									stdPGS_MDD_S1 stdPGS_MDD_S6 stdPGS_MDD_GWSig ///
									stdPGS_SCZ_S1 stdPGS_SCZ_S6 stdPGS_SCZ_GWSig ///
									stdPGS_PE_S1 stdPGS_PE_S6 stdPGS_PE_GWSig ///
									PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 /// 
					, add(50) rseed(484286) dots /// * to check before running: dryrun. add: # of imputations. dots: display dots as imputations are performed OR noisily to get full imputation output
					savetrace(Summaries_Run1_prs,replace) // savetrace saves means and standard deviations of imputed values from each iteration to a dataset named “trace1”.
				  	*remember, to change # imputations as needed. note options: dryrun report  to see predictions models without running					
				 
log close

save "project_imputation_PRSanalysis_IMPUTED.dta"	  



***********************************
***********************************
***********************************
* Trauma analyses
 
**using log to save all output of the imputation in a file: 
set linesize 255 
log using "MI_log_261022_trauma.log", replace

use project_imputation_TraumaAnalysis.dta, clear 

* making sure all missing values are set to .
foreach var of varlist aln pliks24TH_3C_binary negsymp_topdecile_24 mild_depression_24 mod_depression_24 severe_depression_24 any_anxiety_disorder_24 ///
PE_18_binary negsymp_topdecile_16 mild_depression_18 mod_depression_18 severe_depression_18  any_anxiety_disorder_18 AT10_minq IL6_f9 CRP_f9 BMI_8 sex ///
matSMKpreg patSMKpreg ParentalSoc MFQccsScore rs2228145_c crp_TF3 EPDSm_score BMI_7 patFamHistPsych matFamHistPsych matEdu homeOwnership ///
stdPGS_ANX_S1 stdPGS_MDD_S1 stdPGS_SCZ_S1 stdPGS_PE_S1 {
    replace `var' =. if `var' >.
}

mi set wide // prepares dataset as a multiple imputation dataset in wide format (one column per imputation per variable) + sets all the vars as unregistered. + sets M = 0
mi misstable summarize // to identify missing values. this command reports the variables contaning missing values

mi register imputed 			pliks24TH_3C_binary negsymp_topdecile_24 mild_depression_24 mod_depression_24 severe_depression_24 any_anxiety_disorder_24 /// * outcomes, main @24
					PE_18_binary negsymp_topdecile_16 mild_depression_18 mod_depression_18 severe_depression_18  any_anxiety_disorder_18 /// * outcomes, sensitivity @18
					IL6_f9 CRP_f9 /// * Mediators
					BMI_8 sex matSMKpreg patSMKpreg ParentalSoc stdPGS_ANX_S1 stdPGS_MDD_S1 stdPGS_SCZ_S1 stdPGS_PE_S1 /// * covariates
					MFQccsScore  /// * aux for outcomes		
					crp_TF3	/// * aux for mediators	
					EPDSm_score BMI_7 patFamHistPsych matFamHistPsych matEdu homeOwnership /// * aux for outcomes
					rs2228145_c // * aux for mediators
mi register regular 			aln qlet /// *IDs
					AT10_minq // * ANX PRS exposures

mi describe, detail // provides a more detailed report on mi data

* run the imputation model, specifying the type of regression used to impute each variable
* from help file: 
*    regress               linear regression for a continuous variable
*    pmm                   predictive mean matching for a continuous variable
*    truncreg              truncated regression for a continuous variable with a restricted range
*    intreg                interval regression for a continuous partially observed (censored) variable
*    logit                 logistic regression for a binary variable
*    ologit                ordered logistic regression for an ordinal variable [ORDINAL = categorical var. with values ordered]
*    mlogit                multinomial logistic regression for a nominal variable [NOMINAL =  categorical var with no intrinsic order of the categories]
*    poisson               Poisson regression for a count variable 
*    nbreg                 negative binomial regression for an overdispersed count variable [overdispersion: the presence of greater variability (statistical dispersion) than would be expected][NOTE THIS IS FOR COUNT VARS.]

***********************************	
*** TO RUN ON BLUE PEBBLE - TRAUMA ANALYSIS DATA:
mi impute chained			(regress) 		BMI_8 BMI_7 stdPGS_ANX_S1 stdPGS_MDD_S1 stdPGS_SCZ_S1 stdPGS_PE_S1 /// 
					(pmm, knn(10)) 		IL6_f9 CRP_f9 MFQccsScore crp_TF3 EPDSm_score ///
					(logit) 		pliks24TH_3C_binary negsymp_topdecile_24 any_anxiety_disorder_24 ///
									PE_18_binary negsymp_topdecile_16 any_anxiety_disorder_18 matEdu ///
									sex matSMKpreg patSMKpreg patFamHistPsych matFamHistPsych /// 
					(logit,			 omit(i.mod_depression_24 i.severe_depression_24)) mild_depression_24 ///
					(logit, 		omit(i.mild_depression_24 i.severe_depression_24)) mod_depression_24 ///					
					(logit, 		omit(i.mod_depression_24 i.mild_depression_24)) severe_depression_24 ///				
					(logit, 		omit(i.mod_depression_18 i.severe_depression_18)) mild_depression_18 ///
					(logit, 		omit(i.mild_depression_18 i.severe_depression_18)) mod_depression_18 ///					
					(logit, 		omit(i.mod_depression_18 i.mild_depression_18)) severe_depression_18 ///					
					(ologit) 		ParentalSoc rs2228145_c /// 
					(mlogit)  		homeOwnership /// 
					= 				AT10_minq /// 
					, add(50) rseed(484286) dots /// * to check before running: dryrun. add: # of imputations. dots: display dots as imputations are performed OR noisily to get full imputation output
					savetrace(Summaries_Run1_trauma,replace) // savetrace saves means and standard deviations of imputed values from each iteration to a dataset named “trace1”.
				  	*remember, to change # imputations as needed. note options: dryrun report  to see predictions models without running					
				 
log close

save "project_imputation_TraumaAnalysis_IMPUTED.dta"	  
