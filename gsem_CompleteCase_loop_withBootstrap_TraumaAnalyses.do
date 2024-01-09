*code to run gsem mediation model across exposures and outcomes

program bootprog, rclass
args exp out med
*syntax [if] [in]
gsem (`out' <- `exp' `med' matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc stdPGS_PE_S1 stdPGS_SCZ_S1 stdPGS_MDD_S1 stdPGS_ANX_S1, logit) ///
(`med' <- `exp' matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc stdPGS_PE_S1 stdPGS_SCZ_S1 stdPGS_MDD_S1 stdPGS_ANX_S1) //`if' `in'
return scalar ind = _b[`med':`exp']*_b[`out':`med']
return scalar dir = _b[`out':`exp']
return scalar tot = _b[`med':`exp']*_b[`out':`med'] + _b[`out':`exp']
end

tempname memhold 
postfile `memhold' 	str30 outcome str30 exposure str10 mediator N ///
					ind_obs_coef ind_BSse ind_lci_norm ind_uci_norm ///
					dir_obs_coef dir_BSse dir_lci_norm dir_uci_norm ///
					tot_obs_coef tot_BSse tot_lci_norm tot_uci_norm ///
					using "Trauma_Inflamm_Psych_NOIMP_Mediation_Results.dta", replace	
		
foreach med in crp il_6 {
	foreach exp in at10_minq {
		foreach out in 	pliks24TH_3C_binary negsymp_topdecile_24 mod_depression_24 any_anxiety_disorder_24 {
			use "Lilford_project_imputation_TraumaAnalysis.dta", clear // data used for imputation - NOT IMPUTED
							rename BMI_8 bmi_8
							rename ParentalSoc parentalsoc
							rename IL6_f9 il_6
							rename CRP_f9 crp
							rename AT10_minq at10_minq
							rename PE_18_binary pe_18_binary						    		
			gsem (`out' <- `exp' `med' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc, logit) ///
			(`med' <- `exp' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc)
			nlcom (_b[`med': `exp']*_b[`out':`med'])
			matrix N=e(_N) // sample size with complete data on all variables
			bootstrap r(ind) r(dir) r(tot), reps(1000): bootprog `exp' `out' `med'
			matrix a=e(b) // observed coeffs
			matrix b=e(se) // BS standard errors
			matrix c=e(ci_normal) // normal-approximation CIs

			post `memhold' 	("`out'") ("`exp'") ("`med'") (N[1,1]) ///
							(a[1,1]) (b[1,1]) (c[1,1]) (c[2,1]) /// indirect
							(a[1,2]) (b[1,2]) (c[1,2]) (c[2,2])	/// direct
							(a[1,3]) (b[1,3]) (c[1,3]) (c[2,3]) // total
			matrix drop _all
		}
	}
}
postclose `memhold'	
program drop bootprog

use "Trauma_Inflamm_Psych_NOIMP_Mediation_Results.dta", clear	
foreach n in ind dir tot {
	gen `n'_OR = exp(`n'_obs_coef)
	gen `n'_lci_OR = exp(`n'_lci_norm)
	gen `n'_uci_OR = exp(`n'_uci_norm)
}
save "Trauma_Inflamm_Psych_NOIMP_Mediation_Results.dta", replace	
