
libname vd "N:\DiPHRData\eager\_Analyst Files\boy_sensitivity\data";


proc freq data=vd.ncomms;
table boylb boy/missing;
run;


proc mi data=vd.ncomms nimpute=200 out=vitd_imp seed=12345 simple
min=0;
class white smoke count_live_NIH newhicrp is_treatment loss_num exercise income site boylb girllb season_base education2 take_vitamins;
transform log(time_try_preg_cyc/c=1);
var time_try_preg_cyc newhicrp vitdngml age bmi hscrp waist_hip_ratio white smoke count_live_NIH is_treatment 
loss_num exercise income site boylb girllb season_base education2 take_vitamins;
fcs discrim (white smoke count_live_NIH newhicrp is_treatment loss_num exercise income site boylb girllb season_base education2 take_vitamins /classeffects=include);
run;


/* get boym with missing values */

proc import datafile="N:\DiPHRData\eager\_Analyst Files\boy_sensitivity\data\firstfull.csv"
        out=firstfull
        dbms=csv
        replace;
run;

data boym;
set firstfull;
keep study_id boym statusNew;
run;

proc freq data=boym;
tables boym/missing;
run;

data vitd_imp2;
merge vitd_imp boym;
by study_id;
run;

proc sort data=vitd_imp2;
by _imputation_ study_id;
run;

data vd.vitd_imp;
set vitd_imp2;
run;

proc export data=vitd_imp2
   outfile="N:\DiPHRData\eager\_Analyst Files\boy_sensitivity\data\vitd_imp.csv"
   dbms=csv replace;
 run;

 /***********************************************************/
 /* only the first fetus */


 proc sort data=vitd_imp;
 by _imputation_ study_id;
 run;

 data vitd_imp_first;
 set vitd_imp;
 by _imputation_ study_id;
 if first.study_id;
 run;

 proc sort data=vitd_imp_first;
 by  study_id;
 run;

 data vitd_imp_first2;
 merge vitd_imp_first boym;
 by study_id;
 run;

proc sort data=vitd_imp_first2;
by _imputation_ study_id;
run;

data vd.vitd_imp_first;
set vitd_imp_first2;
run;


proc export data=vitd_imp_first2
   outfile="N:\DiPHRData\eager\_Analyst Files\boy_sensitivity\data\vitd_imp_first.csv"
   dbms=csv replace;
 run;

 
