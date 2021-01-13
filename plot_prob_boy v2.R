rm(list=ls())
library(sas7bdat)


setwd("N:\\DiPHRData\\eager\\_Analyst Files\\boy_sensitivity\\data")

vd=read.sas7bdat("vitd_imp_fig2.sas7bdat")
names(vd)

vd=subset(vd,X_Imputation_==5)

summary(vd)

setwd("N://DIPHRData//EAGeR//_Analyst Files//boy_sensitivity//result")

fit=read.csv("prob_boy_age29_white_0506.csv")

fit=subset(fit,X_Imputation_==5)

fit=subset(fit,VitDngmL<=120)
summary(fit$Predicted)

png("prob_boy_0506.png", width = 6, height = 6, units = 'in', res = 1200)


par(font.lab=2)

plot(vd$VitDngmL,vd$boylb,col="darkblue",xlab="Preconception 25-hydroxyvitamin D (ng/mL)",
     ylab="Probability of male live birth",xlim=c(0,120))


polygon(c(fit$VitDngmL, rev(fit$VitDngmL)), c(fit$LCLM, rev(fit$UCLM)),
        col ='lightblue',border = NA)

lines(fit$VitDngmL,fit$Predicted,lwd=2,col="blue")

dev.off()

