
library(vegan)
source('./wwf_biome/biome_functions.R')

biome = load_biomes('./data_products/spbiomes.csv')

## create a biome file for the genera names
genera = get_genera(rownames(biome))
biome_genus = aggregate(biome, list(genera), sum)
row.names(biome_genus) = biome_genus[,1]
biome_genus = biome_genus[,-1]

## how strongly do species tend to only occur in a single biome,
## first standardize the species by coverting counts to frequencies
biome_freq = biome / rowSums(biome)
biome_genus_freq = biome_genus / rowSums(biome_genus)
## larger variance indicates that species typically only occur in a single
## biome, largest possible variance for 8 biomes is 0.125
freq_var = apply(biome_freq, 1, var)
freq_genus_var = apply(biome_genus_freq, 1, var)

png('./wwf_biome/fig/var_dist.png', width = 480)
  par(mfrow=c(1, 1))
  plot(density(freq_var),xlab='',ylab='',main='',ylim=c(0,25),
       xlim=c(0, 0.13),lwd=3,axes=F,col='red')
  par(new=TRUE)
  plot(density(freq_genus_var), xlab='', ylab='', main='',
       ylim=c(0,25),xlim=c(0, 0.13),lwd=3,axes=F,col='blue')
  abline(v=0.125, col=1,lwd=3, lty=2)
  add_plot_axes(side=1,xlab='Variance in Biome Prop.',ylab='Density')
  axis(side=2,labels = FALSE,tck=0,cex=1.75,lwd=3)
  par(new=FALSE)
dev.off()
##
## create rank SAD type plots of frequency
biome_ranked = t(apply(biome_freq,1,sort,dec=TRUE))
rank_avgs = apply(biome_ranked,2,mean)

png('./wwf_biome/fig/biome_RAD.png',width=540 * 2)
  cls = rgb(255,0,0,alpha=0.01 * 255, maxColorValue = 255)
  par(mfrow=c(1,2))
  plot(0:1,1:2,type='n',ylim=c(0,1),xlim=c(1,8),xlab='',ylab='',axes=F)
  add_plot_axes(xlab='Rank',ylab='Proportion of Occurances')
  for(i in 1:nrow(biome_freq)){
    lines(1:8,ifelse(biome_ranked[i,]>0,biome_ranked[i,],NA),col=cls)
  }  
  lines(1:8,rank_avgs,col='black',lwd=3)
  ##
  plot(0:1,1:2,type='n',ylim=c(1e-6,1),xlim=c(1,8),xlab='',ylab='',axes=F,log='y')
  add_plot_axes(xlab='Rank',ylab='Proportion of Occurances')
  for(i in 1:nrow(biome_freq)){
    lines(1:8,ifelse(biome_ranked[i,]>0,biome_ranked[i,],NA),col=cls)
  }
  lines(1:8,rank_avgs,col='black',lwd=3)
dev.off()

## Compute how many biomes a species typically occupies
## in a binary cutoff context
cutoffs = seq(0.001, 1/3, length.out=100)
sp_biome_count = rep(NA, length(cutoffs))
ge_biome_count = rep(NA, length(cutoffs))
for(i in seq_along(cutoffs)){
  tmp_sp = get_binary_biomes(biome, cutoff=cutoffs[i])
  tmp_ge = get_binary_biomes(biome_genus, cutoff=cutoffs[i])
  sp_biome_count[i] = mean(rowSums(tmp_sp))
  ge_biome_count[i] = mean(rowSums(tmp_ge))
}

png('./wwf_biome/fig/avg_biome_counts.png', width = 480)
  par(mfrow=c(1,1))
  plot(cutoffs*100, sp_biome_count, col='red', type='l',
       lwd=3, axes=F, ylim=c(1,4), xlab='', ylab='')
  lines(cutoffs*100, ge_biome_count, col='blue', lwd=3)
  add_plot_axes(xlab='Biome membership  % cutoff',
                ylab='Average # of biomes')
  legend('topright',c('Species','Genera'),col=c('red','blue'),cex=2,lwd=5,bty='n')
dev.off()

## which biomes are most well represented in the data
png('./wwf_biome/fig/sample_biome_barplot.png')
  par(mfrow=c(1,1))
  barplot(colSums(biome), cex.names=0.01, ylab='',cex=2,
          names.arg=c('broad', 'conf', 'dese', 'grass', 'mang', 'med', 
                      'mont', 'tund'),
          col = c("green3","darkgreen", "brown", "mediumpurple","cyan",
                  "lightpink", "dodgerblue", "grey"))
dev.off()
##
png('./wwf_biome/fig/species_biome_barplot.png')
  par(mfrow=c(1,1))
  barplot(colSums(get_binary_biomes(biome,cutoff=0.05)), cex.names=0.01, ylab='',cex=2,
          names.arg=c('broad', 'conf', 'dese', 'grass', 'mang', 'med', 
                      'mont', 'tund'),
          col = c("green3","darkgreen", "brown", "mediumpurple","cyan",
                  "lightpink", "dodgerblue", "grey"))
dev.off()

boxplot(biome_freq)

## how are biomes correlated with one another
round(cor(biome),2)
pca = rda(t(biome))
pca_corr = rda((t(biome)),scale=TRUE)

par(mfrow=c(1,1))
plot(pca,type='n')
text(pca,display='wa')
plot(pca_corr,type='n')
text(pca_corr,display='wa')

png('./wwf_biome/fig/pca_corr.png')
  plot(pca_corr,type='n')
  text(pca_corr,display='wa')
dev.off()

##
barplot(pca$CA$eig / pca$tot.chi, ylim=c(0,1))
barplot(pca_corr$CA$eig / pca_corr$tot.chi, ylim=c(0,1))

##############################################
## drop broadleaf
biome_no_broad = biome[,-1]
pca = rda(t(biome_no_broad))
pca_corr = rda((t(biome_no_broad)),scale=TRUE)

par(mfrow=c(1,2))
plot(pca,display=c('wa'))
plot(pca_corr,display=c('wa'))
##
barplot(pca$CA$eig / pca$tot.chi, ylim=c(0,1))
barplot(pca_corr$CA$eig / pca_corr$tot.chi, ylim=c(0,1))




