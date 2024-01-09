********************************************************************************
* Set up environment and read in data
*******************************************************************************
use "Lilford_project_imputation_PRSanalysis_IMPUTED.dta", clear

********************************************************************************
*** Perform logistic regression observational analyses
********************************************************************************
*** PRS -> Psych (X -> Y)
********************************************************************************

* Setting up variable lists
local exposure 		stdPGS_ANX_S1 stdPGS_ANX_S6 stdPGS_ANX_GWSig ///
					stdPGS_MDD_S1 stdPGS_MDD_S6 stdPGS_MDD_GWSig ///
					stdPGS_SCZ_S1 stdPGS_SCZ_S6 stdPGS_SCZ_GWSig ///
					stdPGS_PE_S1 stdPGS_PE_S6 stdPGS_PE_GWSig
local outcome 		pliks24TH_3C_binary mod_depression_24 any_anxiety_disorder_24 negsymp_topdecile_24 ///
				
local mediator		CRP_f9 IL6_f9

********************************************************************************
*** PRS -> psychopathology
tempname memhold 
postfile `memhold' 	str30 outcome str30 exposure str50 label_var coef se t p lci uci r2 N str5 Concept str10 Model ///
					using Analyses/PRS_Inflamm_Psych_IMP_20221101_Results.dta, replace	
*** X->Y
foreach exp of varlist `exposure' {
	foreach out of varlist `outcome' {
		set more off			   
		mi estimate: logistic `out' `exp' PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10
		matrix a=r(table)
		local label_var : variable label `out'
		scalar r2=e(r2_p)
		scalar N=e(N)
		post `memhold' ("`out'") ("`exp'") ("`label_var'") (a[1,1]) (a[2,1]) (a[3,1]) (a[4,1]) (a[5,1]) (a[6,1]) (r2) (N) ("X->Y") ("logistic")
		matrix drop _all
	}
}

postclose `memhold'	