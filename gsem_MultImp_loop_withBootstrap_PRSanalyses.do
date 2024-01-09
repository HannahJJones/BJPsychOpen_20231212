*code to run gsem mediation model across 50 imputed datasets
* This is code built on Gemma Hammerton's bootstrap script

* NOTE USING DEPRESSION AND ANXIETY PRSs AS EXAMPLE

qui capture program drop bootind
program bootind, rclass
args exp out med
gsem (`out' <- `exp' `med' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc, logit) ///
(`med' <- `exp' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc)
nlcom (_b[`med':`exp']*_b[`out':`med'])
return scalar ind = el(r(b),1,1)
end

qui capture program drop bootdir
program bootdir, rclass
args exp out med
gsem (`out' <- `exp' `med' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc, logit) ///
(`med' <- `exp' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc)
nlcom (_b[`out':`exp'])
return scalar dir = el(r(b),1,1)
end

qui capture program drop boottot
program boottot, rclass
args exp out med
gsem (`out' <- `exp' `med' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc, logit) ///
(`med' <- `exp' at10_minq matSMKpreg patSMKpreg bmi_8 sex i.parentalsoc)
nlcom (_b[`med':`exp']*_b[`out':`med']) + (_b[`out':`exp'])
return scalar tot = el(r(b),1,1)
end


tempname memhold 
postfile `memhold' 	str30 outcome str30 exposure str10 mediator ind_mn ind_totse dir_mn dir_totse tot_mn tot_totse ///
					using "PRS_Inflamm_Psych_IMP_20230908_Mediation_Results_btStrp.dta", replace	
		
local exposure 		stdPGS_MDD_S1 stdPGS_ANX_S1

foreach med in IL6_f9 CRP_f9 {
	use "Lilford_project_imputation_PRSanalysis_IMPUTED.dta", clear
	foreach exp of varlist `exposure' {
		foreach out in 	negsymp_topdecile_24 mod_depression_24 any_anxiety_disorder_24 negsymp_topdecile_16 mod_depression_18 any_anxiety_disorder_18 {
			capture postclose gsem_loop
			postfile gsem_loop str30 outcome str30 exposure str10 mediator impdata ind ind_var dir dir_var tot tot_var ///
			using "gsem_med_imp_temp.dta", replace
			forvalues impdata = 1/50 { 
				use "Lilford_project_imputation_PRSanalysis_IMPUTED.dta", clear
				mi convert flong
				rename BMI_8 bmi_8
				rename ParentalSoc parentalsoc
				rename IL6_f9 il_6
				rename CRP_f9 crp
				rename AT10_minq at10_minq
				rename PE_18_binary pe_18_binary
				di "`impdata'"
				mi extract `impdata', clear

				*Indirect effect *
				set seed 12345
				bootstrap r(ind), reps(1000) nodots: bootind `exp' `out' `med'
				local ind = e(b)[1,1]
				disp `ind'
				local ind_var = e(V)[1,1]
				disp `ind_var'

				* Direct effect *
				set seed 12345
				bootstrap r(dir), reps(1000) nodots: bootdir `exp' `out' `med'
				local dir = e(b)[1,1]
				disp `dir'
				local dir_var = e(V)[1,1]
				disp `dir_var'
				
				* total effect
				set seed 12345
				bootstrap r(tot), reps(1000) nodots: boottot `exp' `out' `med'
				local tot = e(b)[1,1]
				disp `tot'
				local tot_var = e(V)[1,1]
				disp `tot_var'		
					
				post gsem_loop ("`out'") ("`exp'") ("`med'") (`impdata') (`ind') (`ind_var') (`dir') (`dir_var') (`tot') (`tot_var')
				}
			postclose gsem_loop  

			use "gsem_med_imp_temp.dta", clear

			clonevar ind_b = ind
			clonevar dir_b = dir
			clonevar tot_b = tot

			rename ind ind_mn
			rename dir dir_mn
			rename tot tot_mn
			rename ind_var ind_w
			rename dir_var dir_w
			rename tot_var tot_w

			collapse (mean) ind_mn dir_mn tot_mn ind_w dir_w tot_w (sd) ind_b dir_b tot_b
			for var ind_b dir_b tot_b: replace X = X^2
			for any ind_ dir_ tot_: gen Xtotvar = Xw + (1 + 1/50)*Xb

			for any ind_ dir_ tot_: gen Xtotse = Xtotvar^0.5

			list ind_mn ind_totse 
			list dir_mn dir_totse
			list tot_mn tot_totse
			post `memhold' ("`out'") ("`exp'") ("`med'") (ind_mn) (ind_totse) (dir_mn) (dir_totse) (tot_mn) (tot_totse)
		}
	}
}
postclose `memhold'	

