rm(list=ls())


setwd("N:\\DiPHRData\\eager\\_Analyst Files\\boy_sensitivity\\data")

imp=read.csv("vitd_imp_first.csv",na="")

table(imp$statusNEW)

imp$season_base=factor(imp$season_base)
imp$loss_num=factor(imp$loss_num)
imp$count_live_NIH=factor(imp$count_live_NIH)
imp$take_vitamins=factor(imp$take_vitamins)

imp$vitd30=(imp$VitDngmL>=30)*1


weight=function(dat){
  
  
  fit.den=glm(lost~VitDngmL+age+BMI+loss_num+count_live_NIH+is_treatment+married+season_base,
              family=binomial(logit),data=dat,na.action = na.exclude)
  p.den=predict(fit.den,type="response")
  summary(p.den)
  
  fit.num=glm(lost~1,family=binomial(logit), data=dat)
  p.num=predict(fit.num,type="response")
  summary(p.num)
  
  dat$sw_z=p.num/p.den
  dat$sw_z[dat$lost==0]=((1-p.num)/(1-p.den))[dat$lost==0]
  summary(dat$sw_z)
  summary(dat$sw_z[dat$lost==1]) 
  
  return(dat)
  
}

#-------------------------------------------

pvalue=function(i,j) {
  
  n=nrow(subset(imp,X_Imputation_==1))

  m=20 #max(imp$X_Imputation_)

  v=array(NA,dim=c(m,3))

for(k in 1:m) {
  
#  print(k)
  
  datimp=subset(imp,X_Imputation_==k)
  
  datimp$boylb=0
  datimp=within(datimp,{boylb[pptnew==1]=boym[pptnew==1]})
  
# calculate weight sw_z
  datimp$lost=(datimp$statusNEW!='withdrawal')*1
  table(datimp$lost)
  datimp=weight(datimp)
  
# assign proportion 
  
  lost=subset(datimp,lost==1)
  
  tab=with(lost,table(vitd30,boylb,useNA="always"))
  
  missing1=tab[2,3]
  missing0=tab[1,3]
  
  n_missing1=as.integer(missing1*i/100) # suficient
  n_missing0=as.integer(missing0*j/100) # insufficient
  
  if(n_missing1>0) boy1=c(rep(1,n_missing1),rep(0,missing1-n_missing1)) else boy1=rep(0,missing1)
  if(n_missing0>0) boy0=c(rep(1,n_missing0),rep(0,missing0-n_missing0)) else boy0=rep(0,missing0)
  
set.seed(k)
#  print(k)

# suffle boy1 and boy0
lost[is.na(lost$boylb) & lost$vitd30==1,]$boylb=sample(boy1)
lost[is.na(lost$boylb) & lost$vitd30==0,]$boylb=sample(boy0)

try({
fit = glm(boylb ~ vitd30+age+white+count_live_NIH,family=binomial(log), 
          weight=sw_z,data=lost)
summary(fit)

coeff=coef(fit)[2] 
variance=vcov(fit)[2, 2] 
pvalue=summary(fit)$coefficients["vitd30",4]
v[k,]=c(coeff,variance,pvalue)

}) #try


} #k
  


#-----------------------------------------

#Create a matrix of extracted estimates from the model applied to each of the five complete imputed datasets.
#1st column are the coefficients, 2nd column are the variances, 3rd column are the p-values.

(mat <- v)
  
# Pooled estimates. 
(pooledMean <- mean(mat[,1],na.rm=T))

#Calculating the pooled estimate of the standard error. Total variance is the sum of between-variance and within-variance*degrees-of-freedom-correction.
(betweenVar <- mean(mat[,2],na.rm=T)) # mean of variances
(withinVar <- sd(mat[,1],na.rm=T)^2) # variance of variances
(dfCorrection <- (nrow(mat)+1)/(nrow(mat))) # dfCorrection

(totVar <- betweenVar + withinVar*dfCorrection) # total variance
(pooledSE <- sqrt(totVar)) # standard error

(pooledP <- mean(mat[,3],na.rm=T)) # approximation, which is very close to the exact approach

#Put them all together
(pooledEstimates <- round(c(pooledMean, pooledSE, pooledP),5))

print(c(i,j,pooledEstimates))


return(c(i,j,pooledEstimates))


}


#--------------------------------------------

setwd("N:\\DiPHRData\\EAGeR\\_Analyst Files\\boy_sensitivity\\result\\0507")


all=NULL

for(i in seq(0,100,1))
  for(j in seq(0,100,1))
    all=rbind(all,pvalue(i,j))

all=data.frame(all)
names(all)=c("suf","insuf","est","se","pvalue")
all$rr=exp(all$est)

write.csv(all,"sens.csv",row.names=F)

range(all$rr)







           
