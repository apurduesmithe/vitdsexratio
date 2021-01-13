libname vd "N:\DiPHRData\eager\_Analyst Files\boy_sensitivity\data";

options nofmterr;

proc genmod data=vd.vitd_imp_fig2 descending;
class study_id;
model boylb=VitDngmL age white count_live_NIH1 count_live_NIH2/dist=binomial link=log;
repeated subject=study_id/type=un;
weight sw_z;
store logbinModel;
output out=out p=pred l=lower u=upper;
ods output  GEEEmpPEst=parm;

by _imputation_;

where lost=1;

run;



proc mianalyze parms=parm;
      modeleffects VitDngmL ;
	  ods output parameterestimates=estimates;
run;


data test;

do VitDngmL=0 to 150;
	age=29;
	white=1;
	study_id=0;
	count_live_NIH1=0;
	count_live_NIH2=0;
	sw_p=1;
	output;
end;

run;

proc plm source=logbinModel;
   score data=test out=testout predicted lclm uclm / ilink ;
run;

proc export data=testout
outfile="N:\DiPHRData\eager\_Analyst Files\boy_sensitivity\result\prob_boy_age29_white_0506.csv"
   dbms=csv
   replace;
run;



