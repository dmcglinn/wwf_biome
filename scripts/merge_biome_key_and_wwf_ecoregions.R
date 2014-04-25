
biome_key = read.csv('biome_categories_key.csv')

wwf_eco = read.csv('wwf_eco_lookup.csv')

wwf_biome_merge = merge(wwf_eco, biome_key, by='Code')

## drop the Fine_biome field because this identical to the Fine field
wwf_biome_merge = wwf_biome_merge[, -grep("Fine_biome", names(wwf_biome_merge))]

write.csv(wwf_biome_merge, file='wwf_biome_merge.csv', row.names=F)
