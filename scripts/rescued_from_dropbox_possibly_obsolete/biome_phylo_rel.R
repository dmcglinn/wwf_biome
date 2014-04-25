## $Id: biome_phylo_rel.R 116 2012-05-18 02:44:42Z danmcglinn $

setwd('/home/danmcglinn/gbif')

library(ape)
source('./biome/biome_functions.R')

phyl = read.tree('./trees/Land.plant.tre')
tax = read.tree('./trees/plantlist_species.APGIII_taxonomy.tre')
diffs = phyl$tip.label %in% tax$tip.label

phy_genera = unique(get_genera(phyl$tip.label))
tax_genera = unique(get_genera(tax$tip.label))
length(phy_genera)
length(tax_genera)

sum(phy_genera %in% tax_genera)


biome = load_biomes()
