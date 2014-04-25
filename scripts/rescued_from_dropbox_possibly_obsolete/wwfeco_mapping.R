library(maps)

setwd('c:/users/dan mcglinn/documents/lab data/gis/WWFecoregionbiome/')
load('wwfeco.Rdata')

paintShape = function(obj,field,state,col,border=FALSE,add=TRUE){
 require(sp)
 eval(parse(text=paste('plot(obj[obj@data$',field,"=='",state,"',],add=add,
        border=border,col='",col,"')",sep='')))
}

pdf('all_biome_map.pdf',width=14,height=7)
## map all on one
par(mfrow=c(1,2))
map('world',interior=FALSE)
paintShape(wwfeco,'biomeLump','Broad','darkgreen')
paintShape(wwfeco,'biomeLump','Conifer','dodgerblue')
paintShape(wwfeco,'biomeLump','Grass','pink')
paintShape(wwfeco,'biomeLump','Desert','yellow')
paintShape(wwfeco,'biomeLump','Mangrove','purple')
paintShape(wwfeco,'biomeLump','Med','orange')
paintShape(wwfeco,'biomeLump','Montane','brown')
paintShape(wwfeco,'biomeLump','Tundra','grey')

plot(1:10,1:10,type='n',axes=F,frame.plot=F,xlab='',ylab='')
legend('center',c('Broadleaf','Conifer','Grassland','Desert',
       'Mangrove','Mediterranean','Montane','Tundra'),col=c(
       'darkgreen','dodgerblue','pink','yellow','purple','orange','brown',
       'grey'),bty='n',cex=1.25,lwd=15)
dev.off()

pdf('biome_maps.pdf')
##map each ecoregion individually
map('world',interior=FALSE)
mtext(side=3,text='Broadleaf Forests')
paintShape(wwfeco,'biomeShrt','Trop Moist','darkgreen')
paintShape(wwfeco,'biomeShrt','Trop Dry','limegreen')
paintShape(wwfeco,'biomeShrt','Temp Broad','seagreen')
##
map('world',interior=FALSE)
mtext(side=3,text='Conifer Forests')
paintShape(wwfeco,'biomeShrt','Trop Conif','dodgerblue')
paintShape(wwfeco,'biomeShrt','Temp Conif','blue')
paintShape(wwfeco,'biomeShrt','Boreal','darkblue')
##
map('world',interior=FALSE)
mtext(side=3,text='Grasslands')
paintShape(wwfeco,'biomeShrt','Trop Grass','pink')
paintShape(wwfeco,'biomeShrt','Temp Grass','red')
paintShape(wwfeco,'biomeShrt','Flood Grass','darkred')
##
map('world',interior=FALSE)
mtext(side=3,text='Desert')
paintShape(wwfeco,'biomeShrt','Desert','yellow')
##
#map('world',interior=FALSE)
paintShape(wwfeco,'biomeShrt','Mangrove','purple',add=FALSE,border=TRUE)
mtext(side=3,text='Mangroves')
##
map('world',interior=FALSE)
paintShape(wwfeco,'biomeLump','Med','orange')
mtext(side=3,text='Mediterranean')
##
map('world',interior=FALSE)
paintShape(wwfeco,'biomeLump','Montane','brown')
mtext(side=3,text='Montane')
##
map('world',interior=FALSE)
paintShape(wwfeco,'biomeLump','Tundra','grey')
mtext(side=3,text='Tundra')

dev.off()





