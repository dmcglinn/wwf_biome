'paintShape' = function(obj, col, field=NULL, state=NULL, border=FALSE, add=TRUE){
  require(sp)
  if (!is.null(field)) {
    field = eval(parse(text=paste0('obj@data$',field)))
    if (!is.null(state)) { 
      if (!is.na(state) )
        good_rows = ifelse(is.na(field), FALSE, field == paste(state))
      else
        good_rows = is.na(field)
    }
    else
      good_rows = rep(T,length(field))
    eval(parse(text=paste0('plot(obj[good_rows,],add=add,border=border,col=col)')))
  }
  else{
    plot(obj, col=col, border=border, add=add)
  }
}

'labelShape' = function(obj, labels, col, cex){
  text(coordinates(obj), labels = eval(parse(text=paste('obj@data$',labels,sep=''))),
       col=col, cex=cex)
}

'add_plot_axes' = function(sides=1:2, cex=1.75, lwd=3, xlab="", ylab=""){
  if(1 %in% sides)
   axis(side=1, cex.axis=cex, lwd=lwd)
  if(2 %in% sides)
    axis(side=2, cex.axis=cex, lwd=lwd, xlab=xlab, ylab=ylab)
  if(xlab != "")
    mtext(side=1, xlab, cex=cex, padj = 2.5)
  if(ylab != "")
    mtext(side=2, ylab, cex=cex, padj = -2.5)
}

'get_genera' = function(genus_species_list){
  ## returns the genus from a text string "genus_species"
  genera = sapply(genus_species_list, function(x) strsplit(x, "_")[[1]][1] )
  return(genera)
}

'get_biome_names' = function(biome_code, biome_key, field) {
  ## takes the detailed biome names and returns a smaller set of names
  ## that lumps and abbreviates the detailed names
  indices = match(biome_code, biome_key$Code)
  biome_names = as.character(eval(parse(text=paste('biome_key$', field, '[indices]', sep=''))))
  return(biome_names)
}

'lump_biome_data' = function(biome_data, biome_key, field) {
  ## input:  the biome data with the detailed biome names as the column headers
  ## returns: the biome data lumped into a smaller set of biome name
  biome_code = colnames(biome_data)
  lumped_names = get_biome_names(biome_code, biome_key, field)
  cat = split(biome_code, lumped_names)
  biome_lumped = do.call(cbind,
                         lapply(cat, function(x) rowSums(biome_data[x])))
  return(as.data.frame(biome_lumped))
}

'load_biomes' = function(biome_file, biome_key, field, cutoff=1) {
  biome = read.csv(biome_file)
  rownames(biome) = sub(" ", "_", biome[[1]])
  biome = biome[ , -1]
  biome_lumped = lump_biome_data(biome, biome_key, field)
  ## Carry out initial data filtering on counts, at least cutoff number of
  ## observations and drop the Lake biome
  biome_lumped = subset(biome_lumped, subset = rowSums(biome_lumped) >= cutoff, 
                        select = -grep("Lake", names(biome_lumped)))
  if (field == 'Coarsest')
    biome_lumped = subset(biome_lumped, subset = rowSums(biome_lumped) >= cutoff, 
                          select = -grep("Mangrove", names(biome_lumped)))  
  return(biome_lumped)
}


'get_binary_biomes' = function(biome, cutoff=1/20){
  ## Convert biome counts to binary using a threshold proportion (cutoff)
  biome_freq = biome / rowSums(biome)
  biome_bin = biome_freq
  biome_bin[] = as.integer(biome_freq > cutoff)
  return(biome_bin)
}

'load_phy' = function(phypath='../trees/', extra.time=1/10) {
  phy = read.tree(phypath)

  drop = setdiff(phy$tip.label, rownames(biome))
  phy.sub = drop.tip(phy, drop)
  
  ## Elongate all terminal branches by some time (default is 100Ky) to
  ## deal with incompatible states separated by zero branch lengths.
  i = phy$edge[ , 2] <= length(phy$tip.label)
  phy.sub$edge.length[i] = phy.sub$edge.length[i] + extra.time

  return(phy.sub)
}
