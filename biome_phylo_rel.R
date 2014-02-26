
library(ape)
source('biome_functions.R')

phyl = read.tree('../../trees/Land.plant.tre')
tax = read.tree('../../trees/tempomode_trees_02112013/tempo_scrubbed_CONSTRAINT_rooted.dated.tre')
diffs = phyl$tip.label %in% tax$tip.label
?cophenetic
phy_genera = unique(get_genera(phyl$tip.label))
tax_genera = unique(get_genera(tax$tip.label))
length(phy_genera)
length(tax_genera)
biome = load_biomes()
