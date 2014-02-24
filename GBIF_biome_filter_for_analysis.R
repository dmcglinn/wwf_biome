## $Id$
## script creates object biomeSubBin in which the
## biome variables have been converted to binary

rownames(biome) = biome[,1]
biome = biome[,-1]

## merge biome names
biomeKey = data.frame(
           biomeShrt=c('Trop.Moist','Trop.Dry','Trop.Conif','Temp.Broad',
                      'Temp.Conif','Boreal','Trop.Grass','Temp.Grass',
                      'Flood.Grass','Mont.Grass','Tundra','Med.Forest',
                      'Desert','Mangrove','Lake','Ice'),
           biomeLump=c('Broad','Broad','Conifer','Broad','Conifer','Conifer',
                       'Grass','Grass','Grass','Montane','Tundra','Med','Desert',
                       'Mangrove','Lake','Tundra')
           )

names(biome) = as.character(biomeKey$biomeLump[match(names(biome),
               biomeKey$biomeShrt)])
biome = biome[,order(names(biome))]
## aggregate column values mannually
head(biome)
biomeLump = cbind(apply(biome[,1:3],1,sum),
            apply(biome[,3:6],1,sum),
            biome[,7],apply(biome[,8:10],1,sum),
            biome[,11:14],apply(biome[,15:16],1,sum))
colnames(biomeLump) = c('Broad','Conifer','Desert','Grass','Lake','Mangrove',
                      'Med','Montane','Tundra')

## carry out initial data filtering on counts, at least 20
biomeSub = biomeLump[apply(biomeLump,1,sum)>=20,]

## drop Lake Biome 
biomeSub = biomeSub[,colnames(biomeSub) != 'Lake']



