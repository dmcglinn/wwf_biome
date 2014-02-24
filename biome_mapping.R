library(maps)
 
source('./wwf_biome/biome_functions.R')
 
load('/home/danmcglinn/GIS/WWFecoregionbiome/wwfeco.Rdata')
 
## plot biogeographic relms
realms = c('Neartic', 'Neotropic', 'Paleartic', 'Afrotropic','Indo-Malay',
           'Oceania', 'Australasia','Antarctic')
realms_abbr = c('NE','NT','PA','AT','IM','OC','AA','AN')
cols = c('darkgreen','dodgerblue','pink','yellow','purple',
         'orange','brown','grey')
 

pdf('./wwf_biome/biome_maps/all_realm_map.pdf')
  map('world',interior=FALSE)
  for (i in seq_along(realms_abbr)) {
    paintShape(wwfeco,cols[i],'REALM',realms_abbr[i])
  } 
dev.off()
 
biomes = c('Broad','Conifer','Grass','Desert','Mangrove','Med','Montane','Tundra')
 
pdf('./wwf_biome/biome_maps/all_biome_map.pdf',width=14,height=7)
  ## map all on one
  par(mfrow=c(1,2))
  map('world',interior=FALSE)
  for(i in seq_along(biomes)){
    paintShape(wwfeco,cols[i],'biomeLump',biomes[i])
  }
  plot(1:10,1:10,type='n',axes=F,frame.plot=F,xlab='',ylab='')
  legend('center',c('Broadleaf','Conifer','Grassland','Desert',
         'Mangrove','Mediterranean','Montane','Tundra'),col=cols,
         bty='n',cex=1.25,lwd=15)
dev.off()
 
pdf('./wwf_biome/biome_maps/wwf_biome_maps.pdf')
  ##map each ecoregion individually
  map('world',interior=FALSE)
  mtext(side=3,text='Broadleaf Forests')
  paintShape(wwfeco,'darkgreen','biomeShrt','Trop Moist')
  paintShape(wwfeco,'limegreen','biomeShrt','Trop Dry')
  paintShape(wwfeco,'seagreen','biomeShrt','Temp Broad')
  ##
  map('world',interior=FALSE)
  mtext(side=3,text='Conifer Forests')
  paintShape(wwfeco,'dodgerblue','biomeShrt','Trop Conif')
  paintShape(wwfeco,'blue','biomeShrt','Temp Conif')
  paintShape(wwfeco,'darkblue','biomeShrt','Boreal')
  ##
  map('world',interior=FALSE)
  mtext(side=3,text='Grasslands')
  paintShape(wwfeco,'pink','biomeShrt','Trop Grass')
  paintShape(wwfeco,'red','biomeShrt','Temp Grass')
  paintShape(wwfeco,'darkred','biomeShrt','Flood Grass')
  ##
  map('world',interior=FALSE)
  mtext(side=3,text='Desert')
  paintShape(wwfeco,'yellow','biomeShrt','Desert')
  ##
  #map('world',interior=FALSE)
  paintShape(wwfeco,'purple','biomeShrt','Mangrove',add=FALSE,border=TRUE)
  mtext(side=3,text='Mangroves')
  ##
  map('world',interior=FALSE)
  paintShape(wwfeco,'orange','biomeLump','Med')
  mtext(side=3,text='Mediterranean')
  ##
  map('world',interior=FALSE)
  paintShape(wwfeco,'brown','biomeLump','Montane')
  mtext(side=3,text='Montane')
  ##
  map('world',interior=FALSE)
  paintShape(wwfeco,'grey','biomeLump','Tundra')
  mtext(side=3,text='Tundra')
dev.off()

## Map labeled biomes, a seperate pdf for each labeled biome
biomeShrt = as.character(unique(wwfeco@data$biomeShrt))
for (i in seq_along(biomes)) {
  wwfeco_tmp = wwfeco[wwfeco@data$biomeShrt == biomeShrt[i],]
  pdf(paste('./wwf_biome/biome_maps/labeled/',sub(" ","_",biomeShrt[i]),'_labeled.pdf',sep=""),
      width=7 * 8, height = 7 * 8)
    map('world',interior=FALSE)
    paintShape(wwfeco_tmp,'dodgerblue')
    labelShape(wwfeco_tmp,'eco_code','red',0.05)
    map('world',interior=TRUE,add=TRUE)
  dev.off()
}

## Map fine scale biomes
eco_lookup_key = read.csv('./wwf_biome/biome_categories_key.csv')
eco_lookup = read.csv('./wwf_biome/wwf_eco_lookup.csv')
eco_lookup$Code = eco_lookup_key$Code[match(eco_lookup$Fine_biome,eco_lookup_key$Fine)]
eco_lookup$Color = eco_lookup_key$Color[match(eco_lookup$Fine_biome,eco_lookup_key$Fine)]
## the column "Code" applies to the "Fine_biome" column
wwfeco@data$Code = eco_lookup$Code[match(wwfeco@data$eco_code,eco_lookup$eco_code)]
wwfeco@data$Color = eco_lookup$Color[match(wwfeco@data$eco_code,eco_lookup$eco_code)]

code = as.character(eco_lookup_key$Code)
cols = as.character(eco_lookup_key$Color)
  
pdf('./wwf_biome/biome_maps/fine_biomes_labled.pdf',width=7 * 8, height = 7 * 8)
  par(mfrow=c(1,1))
  map('world',interior=FALSE)
  for (i in seq_along(code)) {
    paintShape(wwfeco,cols[i],'Code',code[i])
    labelShape(wwfeco,'eco_code','black',0.05)
  }
  plot(1:10,1:10,type='n',axes=F,frame.plot=F,xlab='',ylab='')
  legend('center',as.character(eco_lookup_key$Fine),col=cols, bty='n',cex=2*4,lwd=100)
dev.off()

pdf('./wwf_biome/biome_maps/fine_biomes.pdf',width=7 * 8, height = 7 * 8)
  par(mfrow=c(1,1))
  map('world',interior=FALSE)
  for (i in seq_along(code)) {
    paintShape(wwfeco,cols[i],'Code',code[i])
  }
  plot(1:10,1:10,type='n',axes=F,frame.plot=F,xlab='',ylab='')
  legend('center',as.character(eco_lookup_key$Fine),col=cols, bty='n',cex=2*4,lwd=100)
dev.off()
