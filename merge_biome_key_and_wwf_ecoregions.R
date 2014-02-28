
biome_key = read.csv('biome_categories_key.csv')

wwf_eco = read.csv('wwf_eco_lookup.csv')

wwf_biome_merge = merge(wwf_eco, biome_key, by='Code')

write.csv(wwf_biome_merge, file='wwf_biome_merge.csv', row.names=F)
