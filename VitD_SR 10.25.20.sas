**********************************************************************************;
* VITAMIN D AND SEX RATIO ANALYSES
* PROGRAMMER: ALEXANDRA PURDUE-SMITHE
* START DATE: JULY 3, 2018
* FINAL RUN: OCTOBER 25, 2020
**********************************************************************************;
libname eager   "O:\EAGeRData\Vit D & Sex Ratio\NatureComm\Resub 2\Final Datasets and Code"; /*my directory*/
options ls=64 ps=80 nofmterr;
%include  '\\NICHD6100E\branch\DIPHRData\EAGeR\OriginalData\EAGeR Documentation\Data\Format.sas'; 



/****************************************************/
/*					TABLE 1 CODE					*/
/****************************************************/

title 'TABLE 1: EAGER BASELINE CHARACTERISTICS ACCORDING TO BASELINE 25(OH)D DEFICIENCY/SUFFICIENCY';
proc sort data=eager.t1; by vd30; run;
proc univariate data=eager.t1;
var vitDngmL;
run;

proc means data=eager.t1 n min max;
var vitDngmL;
by vd30;
run;
proc freq data=eager.t1;
tables (white education rd_season take_vitamins smoke income employed eligibility_cr
time_last_loss1 preg_no_loss loss_num count_live_NIH alcohol_intensity exercise is_treatment site)*vd30/chisq;
run;

proc means data=eager.t1;
var age bmi waist_hip_ratio;
by vd30;
run;

proc means data=eager.t1;
var age bmi waist_hip_ratio;
run;

proc glm data=eager.t1; class vd30; model age=vd30; run; quit;
proc glm data=eager.t1; class vd30; model bmi=vd30; run; quit;
proc glm data=eager.t1; class vd30; model waist_hip_ratio=vd30; run; quit;


*MEAN AND SD OF VITAMIN D;

proc univariate data=eager.t1;
var vitdngml;
run;




/******************************************************/
/*				   END TABLE 1 CODE				      */
/******************************************************/

*CORRELATION COEFFICIENT BETWEEN HSCRP AND VITD - REVIEWER #1 REQUEST;

proc corr spearman fisher(biasadj=no) data=eager.ncomms;
var hscrp vitdngml;
run;


*IMPUTE MISSING COVARIATES;
proc mi data=eager.ncomms nimpute=10 out=vitd_imp seed=12345 simple
min=0;
class white smoke count_live_NIH newhicrp is_treatment loss_num exercise eligibility_cr income site boylb girllb season_base education2 take_vitamins;
transform log(time_try_preg_cyc/c=1);
var time_try_preg_cyc newhicrp vitdngml age bmi hscrp waist_hip_ratio white smoke eligibility_cr count_live_NIH is_treatment 
loss_num exercise income site boylb girllb season_base education2 take_vitamins;
fcs discrim (white smoke count_live_NIH newhicrp is_treatment loss_num exercise income eligibility_cr site boylb girllb season_base education2 take_vitamins /classeffects=include);
run;


*CREATE INDICATOR VARIABLES TO USE IN MODELS;

data vitd_imp;
set vitd_imp;

*NUMBER OF PREVIOUS LOSSES;
if loss_num=1 then loss_num1=1;
else loss_num1=0;
if loss_num=2 then loss_num2=1;
else loss_num2=0;
 
*PHYSICAL ACTIVITY;
if exercise=1 then exercise1=1;else exercise1=0;
if exercise=2 then exercise2=1;else exercise2=0;
if exercise=3 then exercise3=1;else exercise3=0;

*NUMBER OF PREVIOUS LIVE BIRTHS;
if count_live_NIH=0 then count_live_NIH0=1;else count_live_NIH0=0;
if count_live_NIH=1 then count_live_NIH1=1;else count_live_NIH1=0;
if count_live_NIH=2 then count_live_NIH2=1;else count_live_NIH2=0;

*SEASON OF BLOOD DRAW;
if season_base=4 then rd_seasonfall=1;else rd_seasonfall=0;
if season_base=2 then rd_seasonspring=1;else rd_seasonspring=0;
if season_base=3 then rd_seasonsummer=1;else rd_seasonsummer=0;
if season_base=1 then rd_seasonwinter=1;else rd_seasonwinter=0;

*INCOME;
if income=1 then income1=1; else income1=0;
if income=2 then income2=1; else income2=0;
if income=3 then income3=1; else income3=0;
if income=4 then income4=1; else income4=0;
if income=5 then income5=1; else income5=0;

*EDUCATION LEVEL;
if education2='> High School' then edu=1;
else edu=0;

*MULTIVITAMIN USE;
if take_vitamins='No folic - no vitamins' then vit=1;
else if take_vitamins='No folic - take vitamins' then vit=2;
else vit=3;
if vit=1 then vit1=1;else vit1=0;
if vit=2 then vit2=1;else vit2=0;
if vit=3 then vit3=1;else vit3=0;

*25(OH)D SUFFICIENT;
if vitdngml lt 30 then vitd30=0;
else if vitdngml ge 30 then vitd30=1;

*25(OH)D ABOVE/BELOW 40 NGML;
if vitdngml lt 40 then vitd_suf40=0;
else if vitdngml ge 40 then vitd_suf40=1;

*10-NGML INCREMENTS FOR SCALED CONTINUOUS ANALYSES;
vitdngml10=vitdngml/10;

*25(OH)D ABOVE/BELOW 20 NGML;
if vitdngml lt 20 then vitd20=0;
else if vitdngml ge 20 then vitd20=1;

*25(OH) ABOVE/BELOW 50 NGML;
if vitdngml lt 50 then vitd_suf50=0;
else if vitdngml ge 50 then vitd_suf50=1;

*LOG(HSCRP);
loghscrp=log(hscrp);

*HI/LOW CRP;

if loghscrp>0.5 then hicrp=1;
else hicrp=0;


*SET ALL MISSING VALUES OF PREVIOUS LIVE BIRTH TO BOY;
/*if prevboy=. and hadson=. and count_live_NIH>0 then do;
   change=1; prevboy=2;
  end; */

*NULLIPARITY;
 if count_live_NIH=0 then nulliparity=1; else nulliparity=0;

*BINARY AGE;
 if age>=35 then old = 1; else old = 0;

*CONFIRMED_PREGNANCY;
 if confirmed_preg=. then confirmed_preg=0;
 
*ELIGIBILITY STRATA;
original=(eligibility_cr='old');

*POSITIVE PREGNANCY TEST;
if pptnew=1 then pptnew=1;
else pptnew=0;

*LB;
if girllb=1 or boylb=1 then lbaps=1;
else lbaps=0;

*CRP INTERACTION TERMS;
hicrpvitd30=newhicrp*vitd30;

*OBESE;
if bmi gt 30 then obese=0;
if bmi le 30 then obese=1;


*WITHDRAWAL Y/N - 1094;
if statusnew ne "withdrawal" then lost=1; /*retained*/
else lost=0; /*lost*/
if lb_new1=1 and sex_fetus1=. then lost=0; /*2 lbs missing fetal sex*/


if site="1-SCRANTON" then site4=1;
if site="2-BUFFALO" then site4=2;
if site="3-UUHSC" then site4=3;
if site="4-MKD" then site4=3;
if site="5-LDS" then site4=3;
if site="6-UVRMC" then site4=3;
if site="8-DENVER" then site4=4;

if site4=1 then site4_1=1; else site4_1=0;
if site4=2 then site4_2=1; else site4_2=0;
if site4=3 then site4_3=1; else site4_3=0;
if site4=4 then site4_4=1; else site4_4=0;

time_try_preg_cyc2=round(time_try_preg_cyc,1);

run;

proc univariate data=vitd_imp;
var hscrp;
run;

proc freq data=vitd_imp;
tables time_try_preg_cyc2;
run;


proc freq data=vitd_imp;
where lost=1;
tables boylb*(vitd30 site)/chisq;
run;

proc freq data=vitd_imp;
where lost=1;
tables vitd30*site/chisq;
run;

proc freq data=vitd_imp;
tables site4*(site4_1 site4_2 site4_3 site4_4);
run;


*GENERATE IP WEIGHTS FOR WITHDRAWAL;
*DENOMINATOR;
proc logistic data=vitd_imp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lost = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dl (keep=study_id p_conf_preg_1l) p=p_CONF_PREG_1l;
run;

*NUMERATOR;
proc logistic data=vitd_imp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lost = ;
output out=est_prob_nl (keep= study_id pn_conf_pregl) p=pn_conf_pregl;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dl; by study_id; run;
proc sort data=est_prob_nl; by study_id; run;
proc sort data=vitd_imp;by study_id;run;
data vitd_imp;
merge est_prob_dl est_prob_nl vitd_imp;
by study_id;
if lost=1 then sw_z= pn_conf_pregl/p_CONF_PREG_1l;
else if lost=0 then sw_z= (1-pn_conf_pregl)/(1-p_CONF_PREG_1l);
run;


*GENERATE IP WEIGHTS FOR PREGNANCY;
*DENOMINATOR;
proc logistic data=vitd_imp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
model pptnew = vitdngml age bmi loss_num2 count_live_NIH1 count_live_NIH2 is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_db (keep=study_id p_conf_preg_1b) p=p_CONF_PREG_1b;
run;

*NUMERATOR;
proc logistic data=vitd_imp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model pptnew = ;
output out=est_prob_nb (keep= study_id pn_conf_pregb) p=pn_conf_pregb;
run;

*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_db; by study_id; run;
proc sort data=est_prob_nb; by study_id; run;
proc sort data=vitd_imp;by study_id;run;
data vitd_imp;
merge est_prob_db est_prob_nb vitd_imp;
by study_id;
if pptnew=1 then sw_b= pn_conf_pregb/p_CONF_PREG_1b;
else if pptnew=0 then sw_b= (1-pn_conf_pregb)/(1-p_CONF_PREG_1b);

sw_p=sw_z*sw_b; *WITHDRAWAL WEIGHT * PREGNANCY WEIGHT;

run;

proc univariate data=vitd_imp;
var sw_p sw_b;
run;


*GENERATE IP WEIGHTS FOR LIVE BIRTH;
*DENOMINATOR;
proc logistic data=vitd_imp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lbaps = vitdngml age bmi loss_num2 count_live_NIH is_treatment original is_treatment*original married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dc (keep=study_id p_conf_preg_1c) p=p_CONF_PREG_1c;
run;

*NUMERATOR;
proc logistic data=vitd_imp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lbaps = ;
output out=est_prob_nc (keep= study_id pn_conf_pregc) p=pn_conf_pregc;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dc; by study_id; run;
proc sort data=est_prob_nc; by study_id; run;
proc sort data=vitd_imp;by study_id;run;
data vitd_imp;
merge est_prob_dc est_prob_nc vitd_imp;
by study_id;
if lbaps=1 then sw_c= pn_conf_pregc/p_CONF_PREG_1c;
else if lbaps=0 then sw_c= (1-pn_conf_pregc)/(1-p_CONF_PREG_1c);

sw_d=sw_z*sw_c*sw_b; *WITHDRAWAL WEIGHT * PREGNANCY WEIGHT * LIVE BIRTH WEIGHT;

/*if sw_d> 6.32 then sw_d=6.32; *TRUNCATE AT 99TH PERCENTILE BC OUTLIERS ARE AFFECTING THE MEAN;*/


run;

*CHECK THAT MEAN OF WEIGHTS IS ~1;
proc univariate data=vitd_imp;
var  sw_z;
run;

proc univariate data=vitd_imp;
var sw_b sw_p; 
run;

proc univariate data=vitd_imp;
var sw_c sw_d;
run;


*CREATE MACROS FOR ANALYSES;

***********************************************************************************************;
*%impunrr macro 
*description: this macro will produce unadjusted RRs(95% CIs) log-binomial 
*models with robust variance estimation accounting for correlated data (due to twin births) 
*among women who followed up
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*wt=weight
***********************************************************************************************;

%macro impunrr(dataset,o,e,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
where lost=1;
class study_id ;
model &o=&e /dist=binomial link=log covb;
weight &wt;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;

*EMPIRICAL ESTIMATES WITH STABILIZED ROBUST STANDARD ERRORS;
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend impunrr;

***********************************************************************************************;
*%impadjrr macro 
*description: this macro will produce multivariable-adjusted RRs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impadjrr(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id ;
where lost=1;
model &o=&e &c/dist=binomial link=log covb;
weight &wt;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;


/*Analyzing empirical(ROBUST) results*/
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend impadjrr;

***********************************************************************************************;
*%impunrd macro 
*description: this macro will produce unadjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impunrd(dataset,o,e,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1;
model &o=&e /dist=binomial link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend impunrd;


***********************************************************************************************;
*%impadjrd macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impadjrd(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1;
model &o=&e &c /dist=binomial link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend impadjrd;


***********************************************************************************************;
*%impadjrdic macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impadjrdic(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1;
model &o=&e &c /dist=binomial lrci link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend impadjrdic;

***********************************************************************************************;
*%pwtimpunrr macro 
*description: this macro will produce unadjusted RRs(95% CIs) from missing-imputed 
*inverse-probability weighted (for pregnancy) log-binomial 
*models with robust variance estimation accounting for correlated data (due to twin births) 
*among pregnancies only.
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*varlist=covariates
***********************************************************************************************;

%macro pwtimpunrr(dataset,o,e,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
where lost=1 and pptnew=1;
class study_id ;
weight &wt;
model &o=&e /dist=binomial link=log covb;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;

*EMPIRICAL ESTIMATES WITH ROBUST STANDARD ERRORS;
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend pwtimpunrr;

***********************************************************************************************;
*%pwtimpadjrr macro 
*description: this macro will produce multivariable-adjusted RRs(95% CIs) from missing-imputed 
*inverse-probability weighted (for pregnancy) log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among pregnancies only.
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*varlist=covariates
***********************************************************************************************;

%macro pwtimpadjrr(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id ;
where lost=1 and pptnew=1;
weight &wt;
model &o=&e &c/dist=binomial link=log covb;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;


/*Analyzing empirical(ROBUST) results*/
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend pwtimpadjrr;



***********************************************************************************************;
*%pwtimpunrd macro 
*description: this macro will produce unadjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up and became pregnant
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro pwtimpunrd(dataset,o,e,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1;
model &o=&e /dist=binomial link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend pwtimpunrd;


***********************************************************************************************;
*%pwtimpadjrd macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up and became pregnant
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro pwtimpadjrd(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1;
model &o=&e &c /dist=binomial link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend pwtimpadjrd;



***********************************************************************************************;
*%pwtimpadjic macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up and became pregnant
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro pwtimpadjic(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1;
model &o=&e &c /dist=binomial lrci link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend pwtimpadjic;

***********************************************************************************************;
*%lbwtimpunrr macro 
*description: this macro will produce unadjusted RRs(95% CIs) from missing-imputed 
*inverse-probability weighted (for live birth) log-binomial 
*models with robust variance estimation accounting for correlated data (due to twin births) 
*among live births
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
***********************************************************************************************;

%macro lbwtimpunrr(dataset,o,e,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
where lost=1 and pptnew=1 and lbaps=1;
class study_id;
weight &wt;
model &o=&e /dist=binomial link=log covb;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;

*EMPIRICAL ESTIMATES WITH STABILIZED ROBUST VARIANCE ESTIMATION;
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend lbwtimpunrr;


***********************************************************************************************;
*%lbwtimpadjrr macro 
*description: this macro will produce multivariable-adjusted RRs(95% CIs) from missing-imputed 
*inverse-probability weighted (for live birth) log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among live births only
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
***********************************************************************************************;

%macro lbwtimpadjrr(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id ;
where lost=1 and pptnew=1 and lbaps=1;
weight &wt;
model &o=&e &c/dist=binomial link=log covb;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;


/*Analyzing empirical(ROBUST) results*/
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend lbwtimpadjrr;




***********************************************************************************************;
*%lbwtimpadjrr2 macro 
*description: this macro will produce multivariable-adjusted RRs(95% CIs) from missing-imputed 
*inverse-probability weighted (for live birth) poisson models with robust variance estimation accounting for 
*correlated data (due to twin births) among live births only
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
***********************************************************************************************;

%macro lbwtimpadjrr2(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id ;
where lost=1 and pptnew=1 and lbaps=1;
weight &wt;
model &o=&e &c/dist=poisson link=log covb;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;


/*Analyzing empirical(ROBUST) results*/
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend lbwtimpadjrr2;


***********************************************************************************************;
*%lbwtimpunrd macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*inverse-probability weighted (for live birth) log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among live births only
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
***********************************************************************************************;

%macro lbwtimpunrd(dataset,o,e,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1 and lbaps=1;
model &o=&e /dist=binomial link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend lbwtimpunrd;


***********************************************************************************************;
*%lbwtimpadjrd macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who had live birth
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro lbwtimpadjrd(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1 and lbaps=1;
model &o=&e &c /dist=binomial link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend lbwtimpadjrd;


***********************************************************************************************;
*%lbwtimpadjic macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who had live birth
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro lbwtimpadjic(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1 and lbaps=1;
model &o=&e &c /dist=binomial lrci link=identity;
repeated subject=study_id;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend lbwtimpadjic;



********************************************;
* MACRO FOR EXPOSURE X OUTCOME FREQUENCIES  ;
********************************************;

*all participants who followed up;
%macro freqall(dataset,e,o);

proc freq data=&dataset;
where lost=1;
tables &e*(&o);
title 'EXPOSURE OUTCOME FREQUENCIES AMONG ALL WOMEN WHO FOLLOWED UP';
run;

%mend freqall;

*among women who became pregnant;
%macro freqpreg(dataset,e,o);

proc freq data=&dataset;
where lost=1 and pptnew=1;
tables &e*(&o);
title 'EXPOSURE OUTCOME FREQUENCIES AMONG ALL PREGNANCIES';
run;

%mend freqpreg;

*among live births;
%macro freqlb(dataset,e,o);

proc freq data=&dataset;
where lost=1 and pptnew=1 and lbaps=1;
tables &e*(&o);
title 'EXPOSURE OUTCOME FREQUENCIES AMONG ALL LIVEBIRTHS';
run;

%mend freqlb;

proc freq data=vitd_imp;
tables vitd30*(white loss_num is_treatment exercise vit count_live_NIH season_base)/or chisq;
run;

proc freq data=vitd_imp;
tables boylb*(white loss_num is_treatment exercise vit count_live_NIH season_base)/or chisq;
run;

proc univariate data=vitd_imp;
where _imputation_=1;
var vitdngml;
histogram;
run;



/*********************************************************************/
/*						MAIN TABLES CODE	         			     */
/*********************************************************************/

*FREQUENCIES - NOTE THAT THESE ARE ACROSS 10 IMPUTED DATASETS, MUST DIVIDE BY 10 AND ROUND FOR CASE COUNT PER EXPOSURE CATEGORY;
%freqall(vitd_imp,vitd30,boylb girllb);
%freqall(vitd_imp,vitd_suf50,boylb girllb);
%freqpreg(vitd_imp,vitd30,boylb girllb);
%freqlb(vitd_imp,vitd30,boylb girllb);

/*************************************************************************************/

*MODEL 1 - UNADJUSTED RRs;
*BOY LIVE BIRTH;
%impunrr(vitd_imp,boylb,vitd30,sw_z);
%pwtimpunrr(vitd_imp,boylb,vitd30,sw_p);
%lbwtimpunrr(vitd_imp,boylb,vitd30,sw_d);

%impunrr(vitd_imp,boylb,vitdngml10,sw_z);
%pwtimpunrr(vitd_imp,boylb,vitdngml10,sw_p);
%lbwtimpunrr(vitd_imp,boylb,vitdngml10,sw_d);

*GIRL LIVE BIRTH;
%impunrr(vitd_imp,girllb,vitd30,sw_z);
%pwtimpunrr(vitd_imp,girllb,vitd30,sw_p);
%lbwtimpunrr(vitd_imp,girllb,vitd30,sw_d);

%impunrr(vitd_imp,girllb,vitdngml10,sw_z);
%pwtimpunrr(vitd_imp,girllb,vitdngml10,sw_p);
%lbwtimpunrr(vitd_imp,girllb,vitdngml10,sw_d);

*MODEL 1 - UNADJUSTED RDs;
*BOY LIVE BIRTH;
%impunrd(vitd_imp,boylb,vitd30,sw_z);
%pwtimpunrd(vitd_imp,boylb,vitd30,sw_p);
%lbwtimpunrd(vitd_imp,boylb,vitd30,sw_d);

*GIRL LIVE BIRTH;
%impunrd(vitd_imp,girllb,vitd30,sw_z);
%pwtimpunrd(vitd_imp,girllb,vitd30,sw_p);
%lbwtimpunrd(vitd_imp,girllb,vitd30,sw_d);

/**************************************************************************************/
%let mv2 = age waist_hip_ratio white count_live_NIH1 count_live_NIH2 vit2 vit3;

*MODEL 2 - RRs ADJUSTED FOR AGE, WAIST/HIP, RACE, # PREVIOUS LIVE BIRTHS, MV USE;
*BOY LIVE BIRTH;
%impadjrr(vitd_imp,boylb,vitd30,&mv2,sw_z);
%pwtimpadjrr(vitd_imp,boylb,vitd30,&mv2,sw_p);
%lbwtimpadjrr(vitd_imp,boylb,vitd30,&mv2,sw_d);

%impadjrr(vitd_imp,boylb,vitdngml10,&mv2,sw_z);
%pwtimpadjrr(vitd_imp,boylb,vitdngml10,&mv2,sw_p);
%lbwtimpadjrr(vitd_imp,boylb,vitdngml10,&mv2,sw_d);

*GIRL LIVE BIRTH;
%impadjrr(vitd_imp,girllb,vitd30,&mv2,sw_z);
%pwtimpadjrr(vitd_imp,girllb,vitd30,&mv2,sw_p);
%lbwtimpadjrr(vitd_imp,girllb,vitd30,&mv2,sw_d);

%impadjrr(vitd_imp,girllb,vitdngml10,&mv2,sw_z);
%pwtimpadjrr(vitd_imp,girllb,vitdngml10,&mv2,sw_p);
%lbwtimpadjrr(vitd_imp,girllb,vitdngml10,&mv2,sw_d);


*MODEL 2 - RDs ADJUSTED FOR AGE, WAIST/HIP, RACE, # PREVIOUS LIVE BIRTHS, MV USE;
*BOY LIVE BIRTH;
%impadjrd(vitd_imp,boylb,vitd30,&mv2,sw_z);
%pwtimpadjrd(vitd_imp,boylb,vitd30,&mv2,sw_p);
%lbwtimpadjrd(vitd_imp,boylb,vitd30,&mv2,sw_d);

*GIRL LIVE BIRTH;
%impadjrd(vitd_imp,girllb,vitd30,&mv2,sw_z);
%pwtimpadjrd(vitd_imp,girllb,vitd30,&mv2,sw_p);
%lbwtimpadjrd(vitd_imp,girllb,vitd30,&mv2,sw_d);

/**************************************************************************************/
%let mv3 = age white count_live_NIH1 count_live_NIH2;
%let mv4 = age waist_hip_ratio white count_live_NIH1 count_live_NIH2 vit2 vit3
site4_2 site4_3 site4_4 rd_seasonspring rd_seasonwinter rd_seasonsummer;		*TO ADDRESS REVIEWER #1 COMMENT;

*MODEL 3 - RRs ADJUSTED FOR AGE, RACE, # PREVIOUS LIVE BIRTHS;
*BOY LIVE BIRTH;
%impadjrr(vitd_imp,boylb,vitd30,&mv3,sw_z);
%pwtimpadjrr(vitd_imp,boylb,vitd30,&mv3,sw_p);
%lbwtimpadjrr(vitd_imp,boylb,vitd30,&mv3,sw_d);

%impadjrr(vitd_imp,boylb,vitd_suf50,&mv3,sw_z);
%pwtimpadjrr(vitd_imp,boylb,vitd_suf50,&mv3,sw_p);
%lbwtimpadjrr(vitd_imp,boylb,vitd_suf50,&mv3,sw_d);

%impadjrr(vitd_imp,boylb,vitdngml10,&mv3,sw_z);
%pwtimpadjrr(vitd_imp,boylb,vitdngml10,&mv3,sw_p);
%lbwtimpadjrr(vitd_imp,boylb,vitdngml10,&mv3,sw_d);

*GIRL LIVE BIRTH;
%impadjrr(vitd_imp,girllb,vitd30,&mv3,sw_z);
%pwtimpadjrr(vitd_imp,girllb,vitd30,&mv3,sw_p);
%lbwtimpadjrr(vitd_imp,girllb,vitd30,&mv3,sw_d);

%impadjrr(vitd_imp,girllb,vitdngml10,&mv3,sw_z);
%pwtimpadjrr(vitd_imp,girllb,vitdngml10,&mv3,sw_p);
%lbwtimpadjrr(vitd_imp,girllb,vitdngml10,&mv3,sw_d);

*MODEL 3 - RDs ADJUSTED FOR AGE, RACE, # PREVIOUS LIVE BIRTHS;
*BOY LIVE BIRTH;
%impadjrd(vitd_imp,boylb,vitd30,&mv3,sw_z);
%pwtimpadjrd(vitd_imp,boylb,vitd30,&mv3,sw_p);
%lbwtimpadjrd(vitd_imp,boylb,vitd30,&mv3,sw_d);

%impadjrd(vitd_imp,boylb,vitd_suf50,&mv3,sw_z);

*GIRL LIVE BIRTH;
%impadjrr(vitd_imp,girllb,vitd30,&mv3,sw_z);
%pwtimpadjrr(vitd_imp,girllb,vitd30,&mv3,sw_p);
%lbwtimpadjrr(vitd_imp,girllb,vitd30,&mv3,sw_d);

%impadjrd(vitd_imp,girllb,vitd30,&mv3,sw_z);

*TRY MODELING HSCRP AS COVARIATE;
%impadjrr(vitd_imp,boylb,vitd30,&mv3 hscrp,sw_z);

*TRY DIFFERENT VITD CUTPOINTS;
%impunrr(vitd_imp,boylb,vitd_suf50,sw_z);
%impadjrr(vitd_imp,boylb,vitd_suf50,&mv2,sw_z);
%impadjrr(vitd_imp,boylb,vitd_suf50,&mv3,sw_z);

%impunrr(vitd_imp,boylb,vitd_suf40,sw_z);
%impadjrr(vitd_imp,boylb,vitd_suf40,&mv2,sw_z);
%impadjrr(vitd_imp,boylb,vitd_suf40,&mv3,sw_z);

%pwtimpadjrr(vitd_imp,boylb,vitd_suf50,&mv3,sw_p);
%lbwtimpadjrr(vitd_imp,boylb,vitd_suf50,&mv3,sw_d);

/***********************************************************/
/*					EXTRA REVIEWER REQUESTS				   */
/***********************************************************/

*STRATIFIED ANALYSES FOR REVIEWER 2;

*STRATIFIED BY PREG CYCLE;
%let mv5 = age;

data pregcycle;
set vitd_imp;
where time_try_preg_cyc2 IN(0,1);
run;

%freqpreg(pregcycle,vitd30,boylb girllb);
%freqpreg(pregcycle2,vitd30,boylb girllb);

%pwtimpunrr(pregcycle,boylb,vitd30,sw_p);
%lbwtimpunrr(pregcycle,boylb,vitd30,sw_d);

%pwtimpadjrr(pregcycle,boylb,vitd30,&mv5,sw_p);
%lbwtimpadjrr(pregcycle,boylb,vitd30,&mv5,sw_d);

data originalstr;
set vitd_imp;
if original=1;
run;

*RE-WEIGHT WITHIN ELIG STRATA;
*GENERATE IP WEIGHTS FOR WITHDRAWAL;
*DENOMINATOR;
proc logistic data=originalstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lost = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_do (keep=study_id p_conf_preg_1o) p=p_CONF_PREG_1o;
run;

*NUMERATOR;
proc logistic data=originalstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lost = ;
output out=est_prob_no (keep= study_id pn_conf_prego) p=pn_conf_prego;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_do; by study_id; run;
proc sort data=est_prob_no; by study_id; run;
proc sort data=originalstr;by study_id;run;
data originalstr;
merge est_prob_do est_prob_no originalstr;
by study_id;
if lost=1 then sw_o= pn_conf_prego/p_CONF_PREG_1o;
else if lost=0 then sw_o= (1-pn_conf_prego)/(1-p_CONF_PREG_1o);
run;


*GENERATE IP WEIGHTS FOR PREGNANCY;
*DENOMINATOR;
proc logistic data=originalstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
model pptnew = vitdngml age bmi loss_num2 count_live_NIH1 count_live_NIH2 is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_do1 (keep=study_id p_conf_preg_1o1) p=p_CONF_PREG_1o1;
run;

*NUMERATOR;
proc logistic data=originalstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model pptnew = ;
output out=est_prob_no1 (keep= study_id pn_conf_prego1) p=pn_conf_prego1;
run;

*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_do1; by study_id; run;
proc sort data=est_prob_no1; by study_id; run;
proc sort data=originalstr;by study_id;run;
data originalstr;
merge est_prob_do1 est_prob_no1 originalstr;
by study_id;
if pptnew=1 then sw_o1= pn_conf_prego1/p_CONF_PREG_1o1;
else if pptnew=0 then sw_o1= (1-pn_conf_prego1)/(1-p_CONF_PREG_1o1);

sw_o2=sw_o*sw_o1; *WITHDRAWAL WEIGHT * PREGNANCY WEIGHT;

run;

proc univariate data=originalstr;
var sw_o1 sw_o2;
run;


*GENERATE IP WEIGHTS FOR LIVE BIRTH;
*DENOMINATOR;
proc logistic data=originalstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lbaps = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_do2 (keep=study_id p_conf_preg_1o2) p=p_CONF_PREG_1o2;
run;

*NUMERATOR;
proc logistic data=originalstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lbaps = ;
output out=est_prob_no2 (keep= study_id pn_conf_prego2) p=pn_conf_prego2;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_do2; by study_id; run;
proc sort data=est_prob_no2; by study_id; run;
proc sort data=originalstr;by study_id;run;
data originalstr;
merge est_prob_do2 est_prob_no2 originalstr;
by study_id;
if lbaps=1 then sw_o3= pn_conf_prego2/p_CONF_PREG_1o2;
else if lbaps=0 then sw_o3= (1-pn_conf_prego2)/(1-p_CONF_PREG_1o2);

sw_o4=sw_o3*sw_o1*sw_o; *WITHDRAWAL WEIGHT * PREGNANCY WEIGHT * LIVE BIRTH WEIGHT;

if sw_o4>4.03 then sw_o4=4.02; *TRUNCATE AT 99TH PERCENTILE BC OUTLIERS ARE AFFECTING THE MEAN;

run;

proc univariate data=originalstr;
var sw_o4;
run;

data expandedstr;
set vitd_imp;
if original=0;
run;


*RE-WEIGHT WITHIN ELIG STRATA;
*GENERATE IP WEIGHTS FOR WITHDRAWAL;
*DENOMINATOR;
proc logistic data=expandedstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lost = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_de (keep=study_id p_conf_preg_1e) p=p_CONF_PREG_1e;
run;

*NUMERATOR;
proc logistic data=expandedstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lost = ;
output out=est_prob_ne (keep= study_id pn_conf_prege) p=pn_conf_prege;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_de; by study_id; run;
proc sort data=est_prob_ne; by study_id; run;
proc sort data=expandedstr;by study_id;run;
data expandedstr;
merge est_prob_de est_prob_ne expandedstr;
by study_id;
if lost=1 then sw_e= pn_conf_prege/p_CONF_PREG_1e;
else if lost=0 then sw_e= (1-pn_conf_prege)/(1-p_CONF_PREG_1e);
run;


*GENERATE IP WEIGHTS FOR PREGNANCY;
*DENOMINATOR;
proc logistic data=expandedstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
model pptnew = vitdngml age bmi loss_num2 count_live_NIH1 count_live_NIH2 is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_de1 (keep=study_id p_conf_preg_1e1) p=p_CONF_PREG_1e1;
run;

*NUMERATOR;
proc logistic data=expandedstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model pptnew = ;
output out=est_prob_ne1 (keep= study_id pn_conf_prege1) p=pn_conf_prege1;
run;

*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_de1; by study_id; run;
proc sort data=est_prob_ne1; by study_id; run;
proc sort data=expandedstr;by study_id;run;
data expandedstr;
merge est_prob_de1 est_prob_ne1 expandedstr;
by study_id;
if pptnew=1 then sw_e1= pn_conf_prege1/p_CONF_PREG_1e1;
else if pptnew=0 then sw_e1= (1-pn_conf_prege1)/(1-p_CONF_PREG_1e1);

sw_e2=sw_e*sw_e1; *WITHDRAWAL WEIGHT * PREGNANCY WEIGHT;

run;

proc univariate data=expandedstr;
var sw_e1 sw_e2;
run;


*GENERATE IP WEIGHTS FOR LIVE BIRTH;
*DENOMINATOR;
proc logistic data=expandedstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lbaps = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_de2 (keep=study_id p_conf_preg_1e2) p=p_CONF_PREG_1e2;
run;

*NUMERATOR;
proc logistic data=expandedstr descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lbaps = ;
output out=est_prob_ne2 (keep= study_id pn_conf_prege2) p=pn_conf_prege2;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_de2; by study_id; run;
proc sort data=est_prob_ne2; by study_id; run;
proc sort data=expandedstr;by study_id;run;
data expandedstr;
merge est_prob_de2 est_prob_ne2 expandedstr;
by study_id;
if lbaps=1 then sw_e3= pn_conf_prege2/p_CONF_PREG_1e2;
else if lbaps=0 then sw_e3= (1-pn_conf_prege2)/(1-p_CONF_PREG_1e2);

sw_e4=sw_e3*sw_e1*sw_e; *WITHDRAWAL WEIGHT * PREGNANCY WEIGHT * LIVE BIRTH WEIGHT;

if sw_e4>6.93 then sw_e4=6.93;

run;


proc univariate data=expandedstr;
var sw_e4;
run;


*MODEL 3 - RRs ADJUSTED FOR AGE, RACE, # PREVIOUS LIVE BIRTHS;
*BOY LIVE BIRTH;
*STRATIFED BY ELIGIBILITY CRITERIA;
%freqpreg(originalstr,vitd30,boylb girllb);
%freqpreg(expandedstr,vitd30,boylb girllb);

%impadjrr(originalstr,boylb,vitd30,&mv3,sw_o);
%pwtimpadjrr(originalstr,boylb,vitd30,&mv3,sw_o2);
%lbwtimpadjrr(originalstr,boylb,vitd30,&mv3,sw_o4);

%impadjrr(expandedstr,boylb,vitd30,&mv3,sw_e);
%pwtimpadjrr(expandedstr,boylb,vitd30,&mv3,sw_e2);
%lbwtimpadjrr(expandedstr,boylb,vitd30,&mv3,sw_e4);

*STRATIFIED BY LOSS NUMBER;
%freqpreg(oneloss,vitd30,boylb girllb);
%freqpreg(twoloss,vitd30,boylb girllb);

%impadjrr(oneloss,boylb,vitd30,&mv3,sw_z);
%pwtimpadjrr(oneloss,boylb,vitd30,&mv3,sw_p);
%lbwtimpadjrr(oneloss,boylb,vitd30,&mv3,sw_d);

%impadjrr(twoloss,boylb,vitd30,&mv3,sw_z);
%pwtimpadjrr(twoloss,boylb,vitd30,&mv3,sw_p);
%lbwtimpadjrr(twoloss,boylb,vitd30,&mv3,sw_d);



/***********************************************************/
/*					EXTRA REVIEWER REQUESTS				   */
/***********************************************************/

*SPLINES - SUPPORT LINEAR FIT, SO FIGURE 2 SHOWS THE LINEAR FIT;

data vitd_imp1;
set vitd_imp;
where _imputation_=1;
run;
/*
*3 KNOTS;
%glmcurv9(data=vitd_imp1, exposure=vitdngml, outcome=boylb, where= lost eq 1, subject=study_id, 
dist=binomial, link=log, weightvar=sw_z, nk=3, usegee=t, reptype=ind, sle=0.99, 
outplot=pdf, plotor=T, adj=age white count_live_nih1 count_live_nih2, pictname=vitd_imp1.vitdngml.boylb.pdf, color4=lib, 
graphtit=Vitamin D Concentrations and RRs of Male Live Birth, font=arial, pwhich=linear, BWM=2,
vlabel=RR of Male Live Birth,
hlabel=%quote(Vitamin D Concentrations), axordh=0 to 120 by 10); 

*4 KNOTS;
%glmcurv9(data=vitd_imp1, exposure=vitdngml, outcome=boylb, where= lost eq 1, subject=study_id, 
dist=binomial, link=log, weightvar=sw_z, nk=4, usegee=t, reptype=ind, sle=0.99, 
outplot=pdf, plotor=T, adj=age white count_live_nih1 count_live_nih2, pictname=vitd_imp1.vitdngml.boylb.pdf, color4=lib, 
graphtit=Vitamin D Concentrations and RRs of Male Live Birth, font=arial, pwhich=linear,
vlabel=RR of Male Live Birth,
hlabel=%quote(Vitamin D Concentrations), axordh=0 to 120 by 10); 

*5 KNOTS;
%glmcurv9(data=vitd_imp1, exposure=vitdngml, outcome=boylb, where= lost eq 1, subject=study_id, 
dist=binomial, link=log, weightvar=sw_z, nk=5, usegee=t, reptype=ind, sle=0.99, 
outplot=pdf, plotor=T, adj=age white count_live_nih1 count_live_nih2, pictname=vitd_imp1.vitdngml.boylb.pdf, color4=lib, 
graphtit=Vitamin D Concentrations and RRs of Male Live Birth, font=arial, pwhich=linear,
vlabel=RR of Male Live Birth,
hlabel=%quote(Vitamin D Concentrations), axordh=0 to 120 by 10); 
*/

*EXCLUDING TWINS;

proc genmod data=vitd_imp descending;
by _imputation_;
class study_id ;
where lost=1 and twinpreg=0; /*RESTRICT TO SINGLETONS*/
model boylb=vitd30 &mv3/dist=binomial link=log covb; 
weight sw_z;
estimate 'vitd30' vitd30 1/exp;
    ods output ParameterEstimates=gmparms
               ParmInfo=gmpinfo
               CovB=gmcovb;
 run;


 proc mianalyze parms=gmparms covb=gmcovb parminfo=gmpinfo;
   modeleffects vitd30;
run;

proc freq data=vitd_imp;
where lost=1;
tables site4*boylb /chisq;
run;


*FURTHER ADJUSTED FOR STUDY SITE AND SEASON - REQUESTED BY REVIEWER 1 AND CITED IN TEXT;

%impadjrr(vitd_imp,boylb,vitd30,&mv4,sw_z);
%impadjrr(vitd_imp,boylb,vitdngml10,&mv4,sw_z);


*EXCLUDING NON-WHITES - REQUESTED BY REVIEWER 1;

***********************************************************************************************;
*%impadjrrace macro 
*description: this macro will produce multivariable-adjusted RRs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up,EXCLUDING NONWHITES
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impadjrrrace(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id ;
where lost=1 and white=1; /*whites only*/
model &o=&e &c/dist=binomial link=log covb;
weight &wt;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;


/*Analyzing empirical(ROBUST) results*/
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend impadjrrrace;

%impadjrrrace(vitd_imp,boylb,vitd30,age count_live_NIH1 count_live_NIH2,sw_z);


*STRATIFIED BY ELIGIBILITY CRITERIA - REQUEST FROM REVIEWER 2;

***********************************************************************************************;
*%impadjrrold macro 
*description: this macro will produce multivariable-adjusted RRs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up, OLD ELIG CRITERIA
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impadjrrold(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id ;
where lost=1 and eligibility_cr="old";
model &o=&e &c/dist=binomial link=log covb;
weight &wt;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;


/*Analyzing empirical(ROBUST) results*/
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend impadjrrold;


%impadjrrold(vitd_imp,boylb,vitd30,age white count_live_NIH1 count_live_NIH2,sw_z);



***********************************************************************************************;
*%impadjrrnew macro 
*description: this macro will produce multivariable-adjusted RRs(95% CIs) from missing-imputed 
*log-binomial models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who followed up, NEW ELIG CRITERIA
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impadjrrnew(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id ;
where lost=1 and eligibility_cr="new";
model &o=&e &c/dist=binomial link=log covb;
weight &wt;
estimate '&e' &e 1/exp;
repeated subject=study_id /MODELSE PRINTMLE MCOVB ECOVB;
 title1 "Unadjusted Risk Ratio for &o according to &e";
 title2 "Among &dataset";

 ods output
    ParameterEstimates=norep_est_&e
    /*the empirical(ROBUST) estimates from a repeated model*/
    GEEEmpPEst=emp_est_&e
    /*the empirical(ROBUST) covariance from a repeated model*/ 
    GEERCov= emp_covb_&e
	/*the indices of the parameters*/
    ParmInfo=parminfo_&e;

run;


/*Analyzing empirical(ROBUST) results*/
PROC MIANALYZE parms = emp_est_&e covb = emp_covb_&e parminfo=parminfo_&e;
modeleffects &e;
title3 'Empirical (robust) results';
ods output ParameterEstimates=impun_e_&e;
run;

data impun_e_&e;
set impun_e_&e;
est=round(exp(Estimate),0.01);
lo=round(exp(LCLMean),0.01);
up=round(exp(UCLMean),0.01);
if Probt>0.05 then rr=cat(est," (",lo,",",up,")");
else rr=cat(est," (",lo,",",up,")*");
run;
 
proc print data=impun_e_&e;
var Parm rr Probt;
run;
quit;

%mend impadjrrnew;


%impadjrrnew(vitd_imp,boylb,vitd30,age white count_live_NIH1 count_live_NIH2,sw_z);


/***********************************************************/
/*					STRATIFIED BY CRP					   */
/***********************************************************/


***********************************************************************************************;
*%impadjrd2 macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*poisson models with robust variance estimation among women who followed up
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro impadjrd2(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1;
model &o=&e &c /dist=poisson link=identity;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend impadjrd2;



***********************************************************************************************;
*%pwtimpadjrd2 macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*poisson models with robust variance estimation among women who followed up and became pregnant
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro pwtimpadjrd2(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1;
model &o=&e &c /dist=poisson link=identity;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend pwtimpadjrd2;


***********************************************************************************************;
*%lbwtimpadjrd2 macro 
*description: this macro will produce multivariable-adjusted RDs(95% CIs) from missing-imputed 
*poisson models with robust variance estimation accounting for 
*correlated data (due to twin births) among women who had live birth
*macro parameters:
*dataset=dataset for analysis
*o=outcome
*e=exposure
*c=covariates
*wt=weight
***********************************************************************************************;

%macro lbwtimpadjrd2(dataset,o,e,c,wt);
proc sort data=&dataset;
by _imputation_;
proc genmod data=&dataset descending;
by _imputation_;
class study_id &e;
where lost=1 and pptnew=1 and lbaps=1;
model &o=&e &c /dist=poisson link=identity;
lsmeans &e / diff cl;
title1 "Adjusted Risk Difference for &o according to &e";
title2 "Among &dataset";
ods output diffs=diff;
run;

data diff2;
set diff;
 comparison=left(_trt)||' vs '||trt;
      run;
   
   proc sort data=diff2;
      by comparison _imputation_;
      run;
   
   proc mianalyze data=diff2;
      by comparison;
      modeleffects estimate;
      stderr stderr;
	  ods output parameterestimates=estimates_&e;
      run;

%mend lbwtimpadjrd2;


*hscrp>1.95;
data hicrp;
set vitd_imp;
where NEWhiCRP=1;
run;

*GENERATE IP WEIGHTS FOR WITHDRAWAL;
*DENOMINATOR;
proc logistic data=hicrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lost = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dlh (keep=study_id p_conf_preg_1lh) p=p_CONF_PREG_1lh;
run;

*NUMERATOR;
proc logistic data=hicrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lost = ;
output out=est_prob_nlh (keep= study_id pn_conf_preglh) p=pn_conf_preglh;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dlh; by study_id; run;
proc sort data=est_prob_nlh; by study_id; run;
proc sort data=hicrp;by study_id;run;
data hicrp;
merge est_prob_dlh est_prob_nlh hicrp;
by study_id;
if lost=1 then sw_lh= pn_conf_preglh/p_CONF_PREG_1lh;
else if lost=0 then sw_lh= (1-pn_conf_preglh)/(1-p_CONF_PREG_1lh);
run;


*GENERATE IP WEIGHTS FOR PREGNANCY AMONG HICRP;
*DENOMINATOR;
proc logistic data=hicrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model pptnew = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dph (keep=study_id p_conf_preg_1ph) p=p_CONF_PREG_1ph;
run;

*NUMERATOR;
proc logistic data=hicrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model pptnew = ;
output out=est_prob_nph (keep= study_id pn_conf_pregph) p=pn_conf_pregph;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dph; by study_id; run;
proc sort data=est_prob_nph; by study_id; run;
proc sort data=hicrp;by study_id;run;
data hicrp;
merge est_prob_dph est_prob_nph hicrp;
by study_id;
if pptnew=1 then sw_ph= pn_conf_pregph/p_CONF_PREG_1ph;
else if pptnew=0 then sw_ph= (1-pn_conf_pregph)/(1-p_CONF_PREG_1ph);

sw_pph=sw_ph*sw_lh; *WEIGHT FOR NON-WITHDRAWAL AND PREGNANCY;
run;


*GENERATE IP WEIGHTS FOR LIVE BIRTH AMONG HICRP;
*DENOMINATOR;
proc logistic data=hicrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lbaps = vitdngml age bmi loss_num2 count_live_NIH is_treatment original is_treatment*original married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dbh (keep=study_id p_conf_preg_1bh) p=p_CONF_PREG_1bh;
run;

*NUMERATOR;
proc logistic data=hicrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lbaps = ;
output out=est_prob_nbh (keep= study_id pn_conf_pregbh) p=pn_conf_pregbh;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dbh; by study_id; run;
proc sort data=est_prob_nbh; by study_id; run;
proc sort data=hicrp;by study_id;run;
data hicrp;
merge est_prob_dbh est_prob_nbh hicrp;
by study_id;
if lbaps=1 then sw_bh= pn_conf_pregbh/p_CONF_PREG_1bh;
else if lbaps=0 then sw_bh= (1-pn_conf_pregbh)/(1-p_CONF_PREG_1bh);

*CREATE WEIGHT TO ACCOUNT FOR PROBABILITY OF NON-WITHDRAWAL, PREGNANCY AND LIVE BIRTH IN HICRP;
sw_bbh=sw_bh*sw_ph*sw_lh;
if sw_bbh>5.12 then sw_bbh=5.12; *TRIM AT 98TH PERCENTILE;
run;


*hscrp le 1.95;
data locrp;
set vitd_imp;
where NEWhiCRP=0;
run;

*GENERATE IP WEIGHTS FOR WITHDRAWAL;
*DENOMINATOR;
proc logistic data=locrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lost = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dll (keep=study_id p_conf_preg_1ll) p=p_CONF_PREG_1ll;
run;

*NUMERATOR;
proc logistic data=locrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lost = ;
output out=est_prob_nll (keep= study_id pn_conf_pregll) p=pn_conf_pregll;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dll; by study_id; run;
proc sort data=est_prob_nll; by study_id; run;
proc sort data=locrp;by study_id;run;
data locrp;
merge est_prob_dll est_prob_nll locrp;
by study_id;
if lost=1 then sw_ll= pn_conf_pregll/p_CONF_PREG_1ll;
else if lost=0 then sw_ll= (1-pn_conf_pregll)/(1-p_CONF_PREG_1ll);
run;


*GENERATE IP WEIGHTS FOR PREGNANCY AMONG LOCRP;
*DENOMINATOR;
proc logistic data=locrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model pptnew = vitdngml age bmi loss_num2 count_live_NIH original is_treatment*original married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dpl (keep=study_id p_conf_preg_1pl) p=p_CONF_PREG_1pl;
run;

*NUMERATOR;
proc logistic data=locrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model pptnew = ;
output out=est_prob_npl (keep= study_id pn_conf_pregpl) p=pn_conf_pregpl;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dpl; by study_id; run;
proc sort data=est_prob_npl; by study_id; run;
proc sort data=locrp;by study_id;run;
data locrp;
merge est_prob_dpl est_prob_npl locrp;
by study_id;
if pptnew=1 then sw_pl= pn_conf_pregpl/p_CONF_PREG_1pl;
else if pptnew=0 then sw_pl= (1-pn_conf_pregpl)/(1-p_CONF_PREG_1pl);

sw_ppl=sw_pl*sw_ll; *WEIGHT FOR NON-WITHDRAWAL AND PREGNANCY;
run;


*GENERATE IP WEIGHTS FOR LIVE BIRTH AMONG LOCRP;
*DENOMINATOR;
proc logistic data=locrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests;
class is_treatment count_live_NIH;
model lbaps = vitdngml age bmi loss_num2 count_live_NIH is_treatment married rd_seasonfall rd_seasonspring rd_seasonsummer; 
output out=est_prob_dbl (keep=study_id p_conf_preg_1bl) p=p_CONF_PREG_1bl;
run;

*NUMERATOR;
proc logistic data=locrp descending;
ods exclude ClassLevelInfo Type3 Association FitStatistics GlobalTests Oddsratios;
model lbaps = ;
output out=est_prob_nbl (keep= study_id pn_conf_pregbl) p=pn_conf_pregbl;
run;
 
*RATIO OF NUMERATOR AND DENOMINATOR;
proc sort data=est_prob_dbl; by study_id; run;
proc sort data=est_prob_nbl; by study_id; run;
proc sort data=locrp;by study_id;run;
data locrp;
merge est_prob_dbl est_prob_nbl locrp;
by study_id;
if lbaps=1 then sw_bl= pn_conf_pregbl/p_CONF_PREG_1bl;
else if lbaps=0 then sw_bl= (1-pn_conf_pregbl)/(1-p_CONF_PREG_1bl);

*CREATE WEIGHT TO ACCOUNT FOR PROBABILITY OF NON-WITHDRAWAL, PREGNANCY AND LIVE BIRTH IN LOCRP;
sw_bbl=sw_bl*sw_pl*sw_ll;
run;

proc univariate data=locrp;
var sw_bbl sw_bl;
run;

proc univariate data=hicrp noprint;
var sw_bbh;
  output pctlpre=P_ pctlpts= 98;
run;
proc print data=data1;
run;

proc univariate data=hicrp;
var sw_bbh;
run;


*FREQUENCIES;
%freqall(hicrp,vitd30,boylb girllb);
%freqpreg(hicrp,vitd30,boylb girllb);
%freqlb(hicrp,vitd30,boylb girllb);

%freqall(locrp,vitd30,boylb girllb);
%freqpreg(locrp,vitd30,boylb girllb);
%freqlb(locrp,vitd30,boylb girllb);


/*****************************************************************************************************************/
*MODEL 1- UNADJUSTED;
*BOY LIVE BIRTH AMONG HICLINCRP;
%impunrr(hicrp,boylb,vitd30,sw_lh);
%pwtimpunrr(hicrp,boylb,vitd30,sw_pph);
%lbwtimpunrr(hicrp,boylb,vitd30,sw_bbh);

%impunrr(hicrp,boylb,vitd_suf50,sw_lh);

%impunrd(hicrp,boylb,vitd30,sw_lh);
%pwtimpunrd(hicrp,boylb,vitd30,sw_pph);
%lbwtimpunrd(hicrp,boylb,vitd30,sw_bbh);

*BOY LIVE BIRTH AMONG LOCLINCRP;
%impunrr(locrp,boylb,vitd30,sw_ll);
%pwtimpunrr(locrp,boylb,vitd30,sw_ppl);
%lbwtimpunrr(locrp,boylb,vitd30,sw_bbl);

%impunrd(locrp,boylb,vitd30,sw_ll);
%pwtimpunrd(locrp,boylb,vitd30,sw_ppl);
%lbwtimpunrd(locrp,boylb,vitd30,sw_bbl);

*GIRL LIVE BIRTH AMONG HICLINCRP;
/*%impunrr(hicrp,girllb,vitd30);
%pwtimpunrr(hicrp,girllb,vitd30,sw_hcrp);
%lbwtimpunrr(hicrp,girllb,vitd30,sw_hcrpb); NO LONGER IN TABLES

*GIRL LIVE BIRTH AMONG LOCLINCRP;
%impunrr(locrp,girllb,vitd30);
%pwtimpunrr(locrp,girllb,vitd30,sw_locrp);
%lbwtimpunrr(locrp,girllb,vitd30,sw_locrpb); 
/*

/****************************************************************************************************************/
%let mv2 = age waist_hip_ratio white count_live_NIH1 count_live_NIH2 vit2 vit3; *MV2 NO LONGER APPEARS IN PAPER;

*MODEL 2 - ADJUSTED FOR AGE, WAIST/HIP, RACE, # PREVIOUS LIVE BIRTHS, MV USE;
*BOY LIVE BIRTH AMONG HICLINCRP;
%impadjrr(hicrp,boylb,vitd30,&mv2,sw_lh);
%pwtimpadjrr(hicrp,boylb,vitd30,&mv2,sw_pph);
/*%lbwtimpadjrr(hicrp,boylb,vitd30,&mv2,sw_bbh); */

/*%impadjrd(hicrp,boylb,vitd30,&mv2,sw_lh);	*/ *USE NON-GEE POISSON MODELS TO FIX MODEL NON-CONVERGENCE;
%pwtimpadjrd(hicrp,boylb,vitd30,&mv2,sw_pph);
%lbwtimpadjrd(hicrp,boylb,vitd30,&mv2,sw_bbh);

*BOY LIVE BIRTH AMONG LOCLINCRP;
%impadjrr(locrp,boylb,vitd30,&mv2,sw_ll);
%pwtimpadjrr(locrp,boylb,vitd30,&mv2,sw_ppl);
%lbwtimpadjrr(locrp,boylb,vitd30,&mv2,sw_bbl);
 /*
*GIRL LIVE BIRTH AMONG HICLINCRP;
%impadjrr(hicrp,girllb,vitd30,&mv2);
%pwtimpadjrr(hicrp,girllb,vitd30,&mv2,sw_hcrp);
%lbwtimpadjrr(hicrp,girllb,vitd30,&mv2,sw_hcrpb);

*GIRL LIVE BIRTH AMONG LOCLINCRP;
%impadjrr(locrp,girllb,vitd30,&mv2);
%pwtimpadjrr(locrp,girllb,vitd30,&mv2,sw_locrp);
%lbwtimpadjrr(locrp,girllb,vitd30,&mv2,sw_locrpb); */

/***************************************************************************************************************/
%let mv3 = age white count_live_NIH1 count_live_NIH2;

*MODEL 3 - ADJUSTED FOR AGE, RACE, # PREVIOUS LIVE BIRTHS;
*BOY LIVE BIRTH AMONG HICLINCRP;
%impadjrr(hicrp,boylb,vitd30,&mv3,sw_lh);
%pwtimpadjrr(hicrp,boylb,vitd30,&mv3,sw_pph);
%lbwtimpadjrr(hicrp,boylb,vitd30,&mv3,sw_bbh);


%impadjrd(hicrp,boylb,vitd30,&mv3,sw_lh);
%pwtimpadjrd2(hicrp,boylb,vitd30,&mv3,sw_pph); *USE NON-GEE POISSON MODELS TO FIX MODEL NON-CONVERGENCE;
%lbwtimpadjrd2(hicrp,boylb,vitd30,&mv3,sw_bbh);

%impadjrr(hicrp,boylb,vitd30,&mv4,sw_lh);

*BOY LIVE BIRTH AMONG LOCLINCRP;
%impadjrr(locrp,boylb,vitd30,&mv3,sw_ll);
%pwtimpadjrr(locrp,boylb,vitd30,&mv3,sw_ppl);
%lbwtimpadjrr(locrp,boylb,vitd30,&mv3,sw_bbl);

%impadjrd(locrp,boylb,vitd30,&mv3,sw_ll);
%pwtimpadjrd(locrp,boylb,vitd30,&mv3,sw_ppl);
%lbwtimpadjrd(locrp,boylb,vitd30,&mv3,sw_bbl);

%impadjrr(locrp,boylb,vitd30,&mv4,sw_ll);

*GIRL LIVE BIRTH AMONG HICLINCRP;
%impadjrr(hicrp,girllb,vitd30,&mv3,sw_lh);
%pwtimpadjrr(hicrp,girllb,vitd30,&mv3,sw_pph);
%lbwtimpadjrr2(hicrp,girllb,vitd30,&mv3,sw_bbh); *POISSON MODEL TO FIX MODEL NON-CONVERGENCE;

*GIRL LIVE BIRTH AMONG LOCLINCRP;
%impadjrr(locrp,girllb,vitd30,&mv3,sw_ll);
%pwtimpadjrr(locrp,girllb,vitd30,&mv3,sw_ppl);
%lbwtimpadjrr2(locrp,girllb,vitd30,&mv3,sw_bbl);

%impadjrr(hicrp,boylb,vitd30,&mv4,sw_lh);
%impadjrr(locrp,boylb,vitd30,&mv4,sw_ll);

/***************************************************************************************************************/


*EXCLUDE HI CRP VALUES - REVIEWER COMMENT;
data hicrpexcl;
set hicrp;
if hscrp>20 then delete;
run;

%impadjrr(hicrpexcl,boylb,vitd30,&mv3,sw_lh);


/************************************************/
/*			SR AT IMPLANTATION CODE				*/
/************************************************/

*CREATE DATA SET FOR ANALYSES OF PREGNANCY WITH MALE AMONG WOMEN WITH KNOWN FETAL SEX OR COMPLETION
OF FOLLOW-UP WITHOUT PREGNANCY;

data vitd_imppreg;
set vitd_imp;
if lost=0 then delete;
if clinically_confirmed_loss=1 and losssex=. then delete;
if chem_loss_compnew IN(1,2) then delete;
run;


*AMONG 797 PREGS;

data vitd_imppreg2;
set vitd_imp;
if pptnew=0 then delete;
if lost=0 then delete;
if clinically_confirmed_loss=1 and losssex=. then delete;
if chem_loss_compnew IN(1,2) then delete;


*FREQUENCIES;
%freqall(vitd_imppreg,vitd30,boy girl);
%freqall(vitd_imppreg,vitd30,boylb);

/*************************************************************************************/

/**************************************************************************************/
%let mv3 = age white count_live_NIH1 count_live_NIH2;

*MODEL 3 - ADJUSTED FOR AGE, RACE, # PREVIOUS LIVE BIRTHS;
*BOY PREGNANCY;
%impadjrr(vitd_imppreg,boy,vitd30,&mv3,sw_z);
%pwtimpadjrr(vitd_imppreg2,boy,vitd30,&mv3,sw_b);

%impunrr(vitd_imppreg,boy,vitd_suf50,sw_z);
%impadjrd(vitd_imppreg,boy,vitd30,&mv3,sw_z);

%impadjrr(vitd_imppreg,boy,vitdngml10,&mv3,sw_z);

*GIRL PREGNANCY;
%impadjrr(vitd_imppreg,girl,vitd30,&mv3,sw_z);
%impadjrd(vitd_imppreg,girl,vitd30,&mv3,sw_z);

%impadjrr(vitd_imppreg,girl,vitdngml10,&mv3,sw_z);


/****************************/
/*	  STRATIFIED BY CRP		*/
/****************************/

data HICRPpreg;
set hicrp;
if lost=0 then delete;
if clinically_confirmed_loss=1 and losssex=. then delete;
if chem_loss_compnew IN(1,2) then delete;
run;


data locrppreg;
set locrp;
if lost=0 then delete;
if clinically_confirmed_loss=1 and losssex=. then delete;
if chem_loss_compnew IN(1,2) then delete;
run;


*FREQUENCIES;
%freqall(hicrppreg,vitd30,boy girl);

%freqall(locrppreg,vitd30,boy girl);


/***************************************************************************************************************/
%let mv3 = age white count_live_NIH1 count_live_NIH2;

*MODEL 3 - ADJUSTED FOR AGE, RACE, # PREVIOUS LIVE BIRTHS;
*BOY PREGNANCY AMONG HICLINCRP;
%impadjrr(hicrppreg,boy,vitd30,&mv3,sw_lh);

*BOY PREGNANCY AMONG LOCLINCRP;
%impadjrr(locrppreg,boy,vitd30,&mv3,sw_ll);

*HIGH CRP;
%impadjrd(hicrppreg,boy,vitd30,&mv3,sw_lh);

*BOY PREGNANCY AMONG LOCLINCRP;
%impadjrd(locrppreg,boy,vitd30,&mv3,sw_ll);

*GIRL PREGNANCY AMONG HICLINCRP;
%impadjrr(hicrppreg,girl,vitd30,&mv3,sw_lh);

*GIRL PREGNANCY AMONG LOCLINCRP;
%impadjrr(locrppreg,girl,vitd30,&mv3,sw_ll);

*GIRL PREGNANCY AMONG HICLINCRP;
%impadjrd(hicrppreg,girl,vitd30,&mv3,sw_lh);


*GIRL PREGNANCY AMONG LOCLINCRP;
%impadjrd(locrppreg,girl,vitd30,&mv3,sw_ll);




/************************************************************************/
/*						SENSITIVITY ANALYSES							*/
/************************************************************************/

*ORIGINAL AND REVISED FETAL SEX OF LOSSES - CORRECTED FOR MCC;
*SEE NOTES FOR DERIVATION OF CORRECTED COUNTS;

proc freq data=vitd_imp;
where losssex ne .;
tables vitd30*losssex;
run;



*ORIGINALS;

data all;
 input boy D wt;
 cards;
 1 1 10
 1 0 11
 0 1 15
 0 0 20
 ;

 run;

proc freq data=all;
weight wt;
tables boy*D/chisq relrisk riskdiff;
title1 'original overall table'; title2 '56 pregs';
 run;

data origeups;
input boy D wt;
cards;
 1 1 6
 1 0 3
 0 1 9
 0 0 8
 ;

 run;

proc freq data=origeups;
weight wt;
tables boy*D/fisher relrisk riskdiff;
title1 'original euploid table'; title2 '56 pregs';
 run;

data origaneups;
input boy D wt;
cards;
 1 1 4
 1 0 7
 0 1 6
 0 0 12
 ;

 run;

proc freq data=origaneups;
weight wt;
tables boy*D/fisher relrisk riskdiff;
title1 'original aneuploid table'; title2 '56 pregs';
 run;

*REVISED;
data revall;
 input boy D wt;
 cards;
 1 1 12
 1 0 14
 0 1 13
 0 0 17
 ;

 run;

proc freq data=revall;
weight wt;
tables boy*D/chisq relrisk riskdiff;
title1 'revised overall table'; title2 '56 pregs';
 run;

data eups;
input boy D wt;
cards;
 1 1 7
 1 0 4
 0 1 6
 0 0 9
 ;

 run;

proc freq data=eups;
weight wt;
tables boy*D/fisher relrisk riskdiff;
title1 'revised euploid table'; title2 '56 pregs';
 run;

data aneups;
input boy D wt;
cards;
 1 1 5
 1 0 9
 0 1 7
 0 0 8
 ;

 run;

proc freq data=aneups;
weight wt;
tables boy*D/fisher relrisk riskdiff;
title1 'revised aneuploid table'; title2 '56 pregs';
 run;
 


*DATA FOR AIJUN FOR FIGURE;
proc sort data=vitd_imp;
by study_id;

data vitd_imp_sa;
set vitd_imp;
by study_id;
if first.study_id;
if pptnew=1;
if statusnew="withdrawal" then boy=.;
if clinically_confirmed_loss=1 and losssex=. then boy=.;
if chem_loss_compnew IN(1,2)then boy=.;
if lb_new1=1 and sex_fetus1=. then boy=.;
run;

data eager.vitd_imp_sa (keep=study_id _imputation_ sw_p age white count_live_NIH1 count_live_NIH2 boy vitd30 vitdngml);
set vitd_imp_sa;
run;

data eager.vitd_imp_FIG (keep=study_id _imputation_ sw_z age white count_live_NIH1 count_live_NIH2 boylb vitdngml lost);
set vitd_imp;
where _imputation_=1;
run;

data eager.vitd_imp_FIG2 (keep=study_id _imputation_ sw_z age white count_live_NIH1 count_live_NIH2 boylb vitdngml lost);
set vitd_imp;
run;


