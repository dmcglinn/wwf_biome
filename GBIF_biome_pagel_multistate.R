library('ape')
library('diversitree')

biome <- read.csv('../data_products/spbiomes.csv',header=TRUE)
phy <- read.tree('../../trees/tempomode_trees_02112013/tempo_scrubbed_CONSTRAINT_rooted.dated.tre')

## carry out initial data filtering, biome lumping, and convert to binary
source('GBIF_biome_filter_for_analysis.R')

## convert biome counts to binary using 5% treashold
rowsums = rowSums(biomeSub)
freq = biomeSub / rowsums
biomeSubBin = ifelse(freq >=0.05,1,0)

n <- colSums(biomeSubBin)
states <- as.data.frame(biomeSubBin[,sort(order(n, decreasing=TRUE)[1:8])])
rownames(states) <- sub(" ", "_", rownames(states))
names(states) <- letters[seq_len(ncol(states))]

drop <- setdiff(phy$tip.label, rownames(states))
phy.sub <- diversitree:::drop.tip.fixed(phy, drop)

lik <- make.mkn.multitrait(phy.sub, states, depth=0)
argnames(lik)

