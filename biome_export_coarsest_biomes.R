

source('biome_functions.R')

biome_key = read.csv('biome_categories_key.csv')

spbiome = load_biomes('../data_products/spbiomes_moresp.csv', biome_key,
                      'Coarsest')

write.csv(spbiome, '../data_products/spbiome_coarsest.csv',
          row.names=TRUE)
