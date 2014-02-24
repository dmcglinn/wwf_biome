## $Id$

setwd('/home/danmcglinn/gbif')

library(vegan)
library(maptools)
gpclibPermit()

source('./biome/biome_functions.R')

biome_cont = load_biomes('./data_products/spbiomecontinent.csv')

load('/home/danmcglinn/GIS/WWFecoregionbiome/wwfeco.Rdata')
load('gbif_geog.Rdata')

plot(countryDat)

## warning this takes forever to run
#cont_shp = unionSpatialPolygons(countryDat, ID=countryDat$continent)
#save(cont_shp,file='continent_shape.Rdata')
load('continent_shape.Rdata')
png('./biome/fig/world_continent.png',
    width = 480 * 3, height = 480 * 3)
plot(cont_shp)
#points(coordinates(cont_shp),pch=19) # gives centroids
dev.off()

##
biome_cont_sum = colSums(biome_cont)
biome_cont_bin = get_binary_biomes(biome_cont,cutoff = 1/20)
biome_cont_bin_sum = colSums(biome_cont_bin)
c_names = sapply(names(biome_cont), function(x) strsplit(x, "_",)[[1]][2])
b_names = sapply(names(biome_cont), function(x) strsplit(x, "_",)[[1]][1])
c_names_uni = unique(c_names)
b_names_uni = unique(b_names)
c_sums = tapply(biome_cont_sum,c_names,sum)
b_sums = tapply(biome_cont_sum,b_names,sum)
b_bin_sums = tapply(biome_cont_bin_sum,b_names,sum)

c_prop = c_sums / sum(c_sums)

cls = c("green3","darkgreen", "brown", "mediumpurple","cyan",
        "lightpink", "dodgerblue", "grey")
for(i in 1:8){
  par(mfrow=c(1,1))
  png(paste('./biome/fig/',c_names_uni[i],'_samp_pie.png',sep=""), bg = 'transparent')
  pie(biome_cont_sum[c_names == c_names_uni[i]],main=c_names_uni[i],
      col = cls, labels = b_names_uni, cex = 1.25)
  dev.off()
  ##
  png(paste('./biome/fig/',c_names_uni[i],'_sp_pie.png',sep=""), bg = 'transparent')
  pie(biome_cont_bin_sum[c_names == c_names_uni[i]],main=c_names_uni[i],
      col = cls, labels = b_names_uni, cex = 1.25)
  dev.off()
}  

## make legend
png('./biome/fig/pie_legend.png',
    width = 480 * 3, height = 480 * 3)
par(mar=rep(0,4))
plot(1:10,1:10,type='n',axes=F,xlab='',ylab='')
legend('center',b_names_uni,col=cls,lwd=8*6,bty='n',cex=6)
dev.off()
