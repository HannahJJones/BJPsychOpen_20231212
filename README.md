### Analysis script to accompany: 
## Examining whether inflammation mediates effects of genetic risk and trauma on psychopathology
</br>

> _Imputation_LilfordP_221020.do_

Stata .do file used to impute data for analyses where PRSs were exposures (up to n= 7859) and analyses where trauma was the exposure (up to n= 8700)
</br>
</br>
> _PRS_individual_regressions_XY.do_  
> _Trauma_individual_regressions_XY.do_

Stata .do file used to run logistic regressions between PRSs and psychopathology and trauma and psychopathology and save results as .dta datasets
</br>
</br>
> _gsem_CompleteCase_loop_withBootstrap_PRSanalyses.do_    
> _gsem_CompleteCase_loop_withBootstrap_TraumaAnalyses.do_  

Stata .do file used to run mediation analyses between _PRSs -> inflammatory markers -> and psychopathology_ and _trauma -> inflammatory markers -> and psychopathology_ using **complete case data**
</br>
</br>
> _gsem_MultImp_loop_withBootstrap_PRSanalyses.do_
> _gsem_MultImp_loop_withBootstrap_TraumaAnalyses.do_

Stata .do file used to run mediation analyses between _PRSs -> inflammatory markers -> and psychopathology_ and _trauma -> inflammatory markers -> and psychopathology_ pooling results over **50 imputed datasets**

