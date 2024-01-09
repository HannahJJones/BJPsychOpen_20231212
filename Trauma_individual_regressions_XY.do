********************************************************************************
* Set up environment and read in data
*******************************************************************************
use "Lilford_project_imputation_TraumaAnalysis_IMPUTED.dta", clear

********************************************************************************
*** Perform linear regression observational analyses
********************************************************************************
*** PRS -> Psych (X -> Y)
********************************************************************************

* Setting up variable lists
local exposure 		AT10_minq
local outcome 		pliks24TH_3C_binary mild_depression_24 mod_depression_24 severe_depression_24 any_anxiety_disorder_24 negsymp_topdecile_24 ///
					PE_18_binary mild_depression_18 mod_depression_18 severe_depression_18 any_anxiety_disorder_18 negsymp_topdecile_16
					
local mediator		CRP_f9 IL6_f9

********************************************************************************
*** Trauma -> psychopathology
tempname memhold 
postfile `memhold' 	str30 outcome str30 exposure str50 label_var coef se t p lci uci r2 N str10 Adjust str5 Concept str10 Model ///
					using Analyses/Trauma_Inflamm_Psych_IMP_20221101_Results.dta, replace	
*** X->Y
foreach exp of varlist `exposure' {
	foreach out of varlist `outcome' {
		set more off			   
		mi estimate: logistic `out' `exp'
		matrix a=r(table)
		local label_var : variable label `out'
		scalar r2=e(r2_p)
		scalar N=e(N)
		post `memhold' ("`out'") ("`exp'") ("`label_var'") (a[1,1]) (a[2,1]) (a[3,1]) (a[4,1]) (a[5,1]) (a[6,1]) (r2) (N) ("Unadjusted") ("X->Y") ("logistic")
		matrix drop _all
		   
		mi estimate: logistic `out' `exp' sex BMI_8 i.ParentalSoc 
		matrix a=r(table)
		local label_var : variable label `out'
		scalar r2=e(r2_p)
		scalar N=e(N)
		post `memhold' ("`out'") ("`exp'") ("`label_var'") (a[1,1]) (a[2,1]) (a[3,1]) (a[4,1]) (a[5,1]) (a[6,1]) (r2) (N) ("Adjusted") ("X->Y") ("logistic")
		matrix drop _all
	}
}

postclose `memhold'	
