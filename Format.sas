proc format;
            /**** questionnaire ****/
            value STATUS  0='BLANK' 1='DRAFT' 2='FINAL';
            /**** decision questions ****/
            value YN      0='.' 1='YES' 2='NO' 98='...';
            value NY      0='.' 1='NO' 2='YES' 98='...';
            value NOTTM   0='NONE' 1='ONE' 2='TWO' 3='THREE OR MORE' 98='...';
            value NOTM    0='NONE' 1='ONE' 2='TWO' 3='=&gt;TWO' 98='.';
            value OTM     1='ONE'  2='TWO' 3='MORE';
            value NM      1='NONE' 2='ONE' 3='MORE THAN 1';
            value NOTTF   0='NONE' 1='ONE' 2='TWO' 3='THREE' 4='FOUR OR MORE' 98='...';
            value LM      0='.' 1='LESS THAN 20' 2='21 to 42' 3='More than 42';
            value YNK     1='YES' 2='NO' 3='DONT KNOW';
            value LMT     1='YES' 2='DO NOT REMEMBER' 3='DID NOT YET MENSTRUATE SINCE THE MISCARRIAGE'; 
            Value EI      1='EARLY PREGNANCY LOSS' 
                          2='ANEMBRYONIC LOSS' 
                          3='EMBRYONIC LOSS' 
                          4='FETAL DEATH' 
                          5='INSUFFICIENT DOCUMENTATION';
            value EIN     1='Early pregnancy loss'
                                      2='Anembryonic loss'
                          3='Embryonic loss'
                          4='Fetal death…'
                          5='Still birth'
                          6='Insufficient documentation';  
            value DWM     1='Day' 2='Week' 3='Month' 98='...';
            value SMOKE   1='Never' 
                          2='Rarely (once a month or less)' 
                          3='Occasionally (two to four times a month)' 
                          4='Sometimes (two to three times per week)' 
                          5='Often (four to six times per week)'
                          6='Daily'
                          98='...';
            value YPN     1='YES PAST' 2='YES PRESENT' 3='NO' 98='...';
            value ALC     1='Rarely (once a month or less)' 
                          2='Occasionally (two to four times  month)' 
                          3='Sometimes (two to three times per week)' 
                          4='(four to six times per week)' 
                          5='Daily'
                          98='...';
            value ALCO    1='One drink' 
                          2='Two drinks' 
                          3='Three drinks' 
                          4='Four drinks' 
                          5='Five or more drinks'
                          98='...';
			value alcoI   0='never'      /*Alcohol_Intensity*/
					      1='sometimes'
					      2='often';
            value AP      1='Am' 2='Pm';
            /**** eligibility ****/
            value ELGQ    0='NOT COMPLETED' 1='ELIGIBLE' 2='UNCERTAIN OF ELIGIBILITY' 3='NOT ELIGIBLE';
            value ELGN    0='.' 1='PENDING' 2='OLD ELIGIBLE' 3='NOT ELIGIBLE' 4='NEW ELIGIBLE';
            value GYNN    0='.' 1='CONFIRMED' 2='NOT CONFIRMED';
            value QCL     1='DATA=Y,NURSE=Y' 
                          2='DATA=N,NURSE=Y' 
                          3='DATA=Y,NURSE=N' 
                          4='DATA=N,NURSE=N' 
                          5='DATA=Y,NURSE=P' 
                          6='DATA=N,NURSE=P'; 
            value ELGD    1='ELIGIBLE' 
                          2='NOT ELIGIBLE' 
                          3='ELIGIBLE-ERRORS'
                          4='NOT ELIGIBLE-ERRORS'
                          5='MISSING INFORMATION TO DECIDE';
            /**** proceeding ****/
            value NP      0='.' 1='NEGATIVE' 2='POSITIVE';
            value DONE    0='.' 1='DONE';
            /**** else ****/
            value SITE    2='BUFFALO' 3='UUHSC' 4='MKD' 5='LDS' 6='UVRMC' 7='DCC';
            value RAND    0='supposed to schedule randomization but did not'
                                                  1='not supposed to schedule randomization but did';
            value GENERAL .='NO' 1='YES';
            /**** ADVERSE EVENT + CRF ****/
            value AEDC    1='Drug Adverse Effect' 
                          2='Pill Overdose' 
                          3='Accident during visit'
                          4='Accident on the way to or from visit'  
                          5='Hospitalization'
                          6='Abnormal physical finding' 
                          7='Abnormal Laboratory finding'
                          8='Maternal prenatal Complication' 
                          9='Fetal Complication'
                          10='Participant Death' 
                          11='Other Adverse Event' 
                          98='...';
            value AEDM    1='Study Medication (Aspirin/Placebo)' 
                          2='Folic Acid'
                          3='Unknown'
                          98='...';
            value AEDMF   1='Mother' 2='Fetus' 98='...';
            value SEVER   1='Fatal'  
						  2='Life threatening' 
						  3='Serious' 
						  4='Moderate' 
						  5='Mild'
                          98='...';
            value NATURE  1='Expected' 2='Unexpected' 98='...';
            value RELAT   1='Not likely' 
                          2='Unlikely'
                          3='Possibly' 
                          4='Probably' 
                          5='Definitely' 
                          6='Not assessable'
                          98='...';
            value DISCON 1='Patient'
                          2='Physician' 
                          3='Investigator'
                          4='Due to delivery'
                          98='...';
            value REPORTF 1='participant' 2='staff' 3='physician' 4='other' 98='...'; 
            /**** Physical measurements ****/
            value WEIGHT  1='measured' 2='self';
            value SIDE    1='LEFT' 2='RIGHT' 98='...';
            value Cuff    1='Small' 2='Adult' 3='Large' 4='Thigh' 98='...';
            /**** Protocol violation ****/
            value PVC     1='Privacy violation'        
                          2='Confidentiality violation'
                          3='Fertility Monitor Deviation'
                          4='Pregnancy Test Deviation'
                          5='Data collection violation'
                          6='Dosage violation'
                          7='Severe adherence violation'
                          8='Use of unauthorized concomitant medication'
                          9='Use of contraceptives'
                          10='Missed one or more study visits or visit outside of allowable window'
                          11='Meets an exclusion criteria'
                          12='Specimen collection violation'
                          13='Other';
            /**** Protocol violation - new version 40.2 ****/
             value PVCN     1='Privacy violation'        
                          2='Confidentiality violation'
                          3='Fertility Monitor Deviation'
                          4='Pregnancy Test Deviation'
                          5='Data collection violation'
                          6='Dosage violation'
                          7='Severe adherence violation'
                          8='Use of unauthorized concomitant medication'
                          9='Use of contraceptives'
                          10='Missed visits'
                          11='Meets an exclusion criteria'
                          12='Specimen collection violation'
                          13='Other';
			/**** Exercise ****/
			value EXE 	  1='Low'  
						  2='Moderate'  
						  3='High';
			/**** Demographic ****/
			value STU 	  1='no'  
						  2='yes, full-time'  
						  3='yes, part-time';
			/**** family medical history ****/
            value YNKm    1='YES' 2='NO' 99='DK'; 
            value FH      1='FULL' 2='HALF';
			value DCODE   1='Heart Disease'
			              2='Cancer'
						  3='Cerebrovascular Disease'
                          4='Chronic lower respiratory disease'
						  5='Trauma'
						  6='Diabetes'
						  7='Influenza and Pneumonia'
						  8='Alzheimer disease'
						  9='Kidney failure or kidney disease'
						  10='Septicemia'
						  11='Other'
						  12='dont know';
             value CERV   1='Mother'
                          5='Sister'
                          6='Half-sister'
                          8='Daughter'
                          9='Maternal Grandmother'
                          10='Paternal Grandmother'
                          11='Maternal Aunt'
                          12='Paternal Aunt';
			value TERM	  1='Preterm'
						  2='Full/Post term';
            /**** Adherence clinic / Adherence phone****/
			value YNSM    1='YES temporarily' 2='NO' 3='YES permanently';
			value YNFA    2='NO' 3='YES permanently' 4='YES temporarily';
            value NRSO    1='never' 2='rarely' 3='sometimes' 4='often';
			value ADCM    1='Less than 3 days' 
                          2='3-5 days'
                          3='6-10 days'
                          4='More than 10 days'
						  98='...';
            /**** End point ****/
            value PN      1='POSITIVE' 2='NEGATIVE' 98='...';
			value NEO	  1='Complication' 2='Death';
			/**** aspirin_or_placebo ****/
			value A_P 	01='Aspirin'
						02='Placebo'
						03='Don’t Know';
			/*** Discontinued reasons ***/
            value DISCONT 0='Not reported'
						  1='Did not show to baseline'
   						  2='Pregnant before baseline'
                          3='Pregnant before randomization' 
                          4='Wrong generation of study ID' 
                          5='Ineligible after baseline';
            /*** status.sas ***/
            value ep      1='Report of Positive Pregnancy Test'
                          2='Pregnancy Loss'
                          3='Pregnancy Termination'
                          4='Delivery of Infant'
                          5='End of Follow-Up without Pregnancy';
			value lt 1='Loss <10 completed weeks'
                          2='Fetal Loss 10-20 completed weeks'
                          3='Stillbirth >20 completed weeks'; 
            value CRIT    2='Old' 4='New';
            value age     0='missing' 1='18<=age=<34' 2='age>=35'; 
			value wt      1='permanent' 2='temporary';
			value wr      1='no pills' 
                          2='no pills,no FU'
                          3='pills,phone' 
                          4='pills,limited FU'
                          5='pills,no FU';
            /**** Screening ****/
            value NOTT    0='.' 1='NONE' 2='ONE' 3='TWO' 4='THREE OR MORE';
            value NW      0='.' 1='No' 2='With the first loss' 3='With the second loss' 4='With both';
            value OTTM    0='.' 1='ONE' 2='TWO' 3='THREE OR MORE';
            value YNDK    0='.' 1='YES' 2='NO' 3='DK';
            value prob    1='no category-just open screeningID or finish after heardsource'  
                          2='no category-not interest (beginning of Screening)' 
                          3='no category-not interest (end of Screening)' 
                          4='no category-criteria';
 			value crits   1='Old Screening Criteria' 2='New Screening Criteria';
			value elgs    0='eligible' 1='not eligible';
			value intrst  0='interested' 1='not interested';
			value elgp    0='system-dcc equal decided eligibility'
                          1='problem system-dcc eligibility';
            value ie      0='NO' 1='YES';

			/*** occupation***/
            value OCTYPE  1='Management'        
                          2='Business or Financial operations'
                          3='Computer and Mathematical'
                          4='Architecture & Engineering'
                          5='Life, Physical & Social Science'
                          6='Community & Social Services'
                          7='Legal'
                          8='Education, Training, Library'
                          9='Art, Design, Entertainment,Sports & Media'
                          10='Healthcare practitioners Technical'
                          11='Healthcare Support'
                          12='Protective Service'
                          13='Food preparation & Serving'
						  14 = 'Building & Grounds Cleaning&Maintenance'
                          15 = 'Personal care & Service'
                          16 = 'Sales & Related'
                          17 = 'Office & Administrative   support'
						  18 = 'Farming, Fishing, Forestry'
                          19 = 'Construction & Extraction'
                          20 = 'Installation, Maintenance&Repair'
                          21 = 'Production '
                          22 = 'Transportation&Material Moving'  
                          23 = 'Military'
                          24 = 'Other' 
						  ;    
            value STATOC  1='Not employed'
			              2='Employed part time'
					      3='Employed full time'
				   	      4='Other';
			   /*** health report ***/
			value freq_int 1='A lot'  2='Average'  3='A few' ;
			value last_preg 1='Live birth'  2='Stillbirth'  3='Ectopic/Moral'  4='Planed abortion'  5='Spontaneous abortion';
			   /*** demographic ***/
		  value  EDUC 1='Never attended'
		              2='Not high school graduate'
					  3='High school graduate'
					  4='GED or equivalent'
					  5='Some college, no degree'
					  6='Associates degree (occupational, technical or vocational program)'
					  7='Associates degree (academic program)'
					  8='BA'
					  9='MA'
					  10='Professional school degree'
					  11='Doctoral degree';

	      value INCM 1='Less than $19,999'
                     2='$20,000-$39,999'
                     3='$40,000-$74,999'
                     4='$75,000-$99,999'
                     5='$100,000 or over';

           value RACE 1='White'
		              2='Black, African-American, or Negro'
					  3='American Indian or Alaska Native'
					  4='Asian Indian'
                      5='Chinese'
					  6='Filipino'
					  7='Japanese'
					  8='Korean'
					  9='Vietnamese'
					  10='Other Asian'
					  11='Native Hawaiian'
                      12='Guamanian or Chamorro'
					  13='Samoan'
					  14='Other Pacific Islander'
					  15='Some other race' ;

	       value SPAN 1='No, not Spanish/Hispanic/Latino'
		              2='Yes, Puerto Rican'
					  3='Yes, Mexican, Mexican American, or Chicano'
					  4='Yes, Cuban'
					  5='Yes, other Spanish/Hispanic/Latino';


			   /*** health reprodaction B ***/

value Medic
1='Anti-acne agents'
2='Anti-asthma agents'
3='Anticoagulants / Antiplatelet agents'
4='Antidiabetic agents'
5='Anti-infective agents'
6='Antineoplastic agents'
7='Anti-osteoporosis agents'
8='Antiparkinson agents'
9='Anti-rheumatic agents'
10='Acidifying agents / Alkalinizing agents'
11='Antitussives, expectorants, and mucolytic agents'
12='Anti-allergic agents'
13='Cardiovascular drugs'
14='Central nervous system agents'
15='Eye, Ear, and Nose preparations'
16='Gastrointestinal drugs'
17='Hormones'
18='Vaccines / immunizing agents'
19='Vitamins, minerals, electrolytes'
20='Natural/herbal products'
21='Aspirin'
22='NSAIDs'
23='Tocolytics'
24='Other'  
98='...'
;

value PREGOUT
1='Live Birth'
2='Stillbirth'
3='Ectopic pregnancy'
4='Fetal reduction'
5='Spontaneous abortion'
6='Therapeutic abortion'
7='Molar pregnancy'
8='Elective termination' 
98='...';

        /*** health reprodaction B OLD ***/

value MedicO
1='Anti-acne agents'
2='Anti-asthma agents'
3='Anticoagulants / Antiplatelet agents'
4='Antidiabetic agents'
5='Anti-infective agents'
6='Antineoplastic agents'
7='Anti-osteoporosis agents'
8='Antiparkinson agents'
9='Anti-rheumatic agents'
10='Acidifying agents / Alkalinizing agents'
11='Antitussives, expectorants, and mucolytic agents'
12='Anti-allergic agents'
13='Cardiovascular drugs'
14='Central nervous system agents'
15='Eye, Ear, and Nose preparations'
16='Gastrointestinal drugs'
17='Hormones'
18='Vaccines / immunizing agents'
19='Vitamins, minerals, electrolytes'
20='Natural/herbal products'
21='Other'  
98='...';
 
                /****  Safety-new version 40.1 ****/
           value NSA 0='.' 1='Yes, nausea and/or vomiting' 2='Yes, other' 3='NO' 98='...';
		   value NSB 0='.' 1='Yes, vaginal bleeding' 2='Yes, other bleeding' 3='NO' 98='...';
           value NSJ 0='.' 1='Yes, ER' 2='Yes, Hospital' 3='NO' 98='...';

               /**** Withdrawal -new version 40.1 ****/
		   value FUSTAT 1='Stop pills, remaining on FU' 
						2='Stop pills, no FU'
						3='continue pills, phone FU'
						4='continue pills, no FU, periodically contact'
						5='continue pills, no FU'
						6='Lost to follow-up'
						98='...';

               /**** STATUS ****/
			value with 11='no pills,FU - permanent'
                       12='no pills,FU - temporary' 
                       13='no pills,FU'
					   21='no pills,no FU - permanent'
                       22='no pills,no FU - temporary' 
                       23='no pills,no FU'
					   3='pills,FU phone only'
                       4='pills,periodically contact'
                       5='pills,no FU'
                       6='unable to contact'; 
		    value ppty 1='home' 2='clinic' 3='home+clinic';
			value clt 1='Loss <10 completed weeks'
                      2='Fetal Loss 10-20 completed weeks'
                      3='Stillbirth >20 completed weeks'
					  4='Ectopic Pregnancy'
					  5='Hydatidiform Mole';
			value ppt 0='No PPT' 1='Chemical Loss' 2='Confirmed Pregnancy';
			value lb  0='clinical loss' 1='live birth';


					  /***** Treatments *****/
				    value TRTYPE 0='No Verification'
					             1='Treatment verified'
								 2='Folic Acid'
								 3='DCC no verification';


					  /***** CHARTS *****/
					/*C3*/
				    value VC 	1='Vaginal'
								2='Cesarean';
					value SPON 	1='Spontaneous' 
								2='Induced' 
								3='No labor'; 
					value TB 	1='Singleton' 
								2='Twins' 
								3='Triples' 
								4='Other multiple birth';  

					  /***** Long data *****/
					value OFT	1='Never'
								2='Moderate'
								3='A lot';
					value phy_che 1='No'
								  2='Yes, regularly'
								  3='Yes, not regularly';

                    value code   1='actual visit' 
                                 2='missed visit'
                                 3='technical visit';
/************** Checklists ***************/
/*  PR 36, PRt_first, PR7_second */
            value ASPLAC
                         0='.'
                         1='ASPIRIN'
                         2='PLACEBO' 
                         3='DONT KNOW';

/* PP */
			value sex 
                      1='Male'
                      2='Female' 
                      3='Undetermined'
                     
;

			value PREE 1='Mild/mod' 2='Severe' 3='Superimposed'
			4='Eclampsia' 5='HELLP syndrome' 6='Pregnancy Induced Hypertension';

run;



