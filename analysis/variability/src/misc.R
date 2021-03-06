
add.alpha <- function(col, alpha=0.2){
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) 
        rgb(x[1], x[2], x[3],
            alpha=alpha))  
}


pdf.f <- function(f, file, ...) {
  cat(sprintf('Writing %s\n', file))
  pdf(file, ...)
  on.exit(dev.off())
  f()
}

samp2site.spp <- function(site,spp,abund) { 
  x <- tapply(abund, list(site=site,spp=spp), sum)
  x[is.na(x)] <- 0
  
  return(x)
}

## This functions takes site-species-abundance data and creates a
## matrix where the sites are columns and the rows are species.

##this function takes three vectors: 1) the site species are found
##in. For plant animal networks this is generally the pollinators 2)
##the species found in those sites. In the case of p-a data is this
##usally the plants and 3) the adbundance of those species. In p-a
##data this is the frequency of interactions

comm.mat2sample <-  function (z) {
  temp <- data.frame(expand.grid(dimnames(z))[1:2], as.vector(as.matrix(z)))
  temp <- temp[sort.list(temp[, 1]), ]
  data.frame(Site = temp[, 1], Abund = temp[, 3], GenSp = temp[, 2])
}



