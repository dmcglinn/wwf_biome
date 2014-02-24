## $Id$

library(maps)

setwd('c:/users/dan mcglinn/documents/lab data/gbif/trunk')

spclim = read.csv('spclimate.csv',header=TRUE)
names(spclim)
attach(spclim)

map('world')
points(Longitude.me,Latitude.me,pch='.',col='red')

hist(log10(count),ylab='',xlab='',main='',cex=1.5,axes=F)
axis(side=1,lwd=2,cex.axis=1.5)
axis(side=2,lwd=2,cex.axis=1.5)
mtext(side=1,expression(log[10]*' Number of Occurrences'),padj=2,cex=1.5)
mtext(side=2,'Frequency',padj=-3,cex=1.5)
abline(v=2,col='red',lwd=2)