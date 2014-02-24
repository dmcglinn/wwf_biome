## $Id$

setwd('/home/danmcglinn/gbif')

library(ape)
source('./biome/biome_functions.R')

phyl = read.tree('./trees/Land.plant.tre')
tax = read.tree('./trees/plantlist_species.APGIII_taxonomy.tre')
diffs = phyl$tip.label %in% tax$tip.label
?cophenetic
phy_genera = unique(get_genera(phyl$tip.label))
tax_genera = unique(get_genera(tax$tip.label))
length(phy_genera)
length(tax_genera)
biome = load_biomes()
