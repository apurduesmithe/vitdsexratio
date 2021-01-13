rm(list=ls())
library(sas7bdat)

setwd("N:\\DiPHRData\\eager\\_Analyst Files\\boy_sensitivity\\data")

vd=read.sas7bdat("vitd_imp_fig2.sas7bdat")
names(vd)

vd=subset(vd,X_Imputation_==5)

bw1=1
bw2=2
bw3=3

d0=density(vd$VitDngmL)

d1=density(vd$VitDngmL,bw=bw1)
d2=density(vd$VitDngmL,bw=bw2)
d3=density(vd$VitDngmL,bw=bw3) 

setwd("N://DIPHRData//EAGeR//_Analyst Files//boy_sensitivity//result")

png("density_vitD_0506.png", width = 6, height = 6, units = 'in', res = 1200)

par(font.lab=2)

plot(d1,main="",col="darksalmon",lwd=2,
     xlab="Preconception 25-hydroxyvitamin D (ng/mL)",
     ylab="Density function")
lines(d2,col="lightgreen",lwd=2)
lines(d3,col="lightblue",lwd=2)

legtxt1=expression(italic(h)==1)
legtxt2=expression(italic(h)==2)
legtxt3=expression(italic(h)==3)

legend(80,0.03,legend=c(legtxt1,legtxt2,legtxt3),bty="n",
       title="Bandwidth",col=c("darksalmon","lightgreen","lightblue"),lty=1,lwd=2)

rug(vd$VitDngmL,col="darkblue")

dev.off()
