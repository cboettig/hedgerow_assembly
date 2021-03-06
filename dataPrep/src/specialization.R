calcSpec <- function(nets, spec, spec.metric, cutoff){
    ## applies specieslevel from bipartite to networks
    ## calculates the species roles from a network and returns a dataframe
    ## with site status and ypr
    ## takes networks and specimen data

    species.lev <- lapply(nets, function(x){
        sl <- specieslevel(x)
        sl$'higher level'$tot.int <- colSums(x)
        sl$'lower level'$tot.int <- rowSums(x)
        sl$'higher level'$mean.k <- mean(sl$'higher level'$degree)
        sl$'lower level'$mean.k <- mean(sl$'lower level'$degree)
        sl$'higher level'$sd.k <- sd(sl$'higher level'$degree)
        sl$'lower level'$sd.k <- sd(sl$'lower level'$degree)
        sl$'higher level'$k <- (sl$'higher level'$degree -
                                sl$'higher level'$mean.k)/sl$'higher level'$sd.k
        sl$'lower level'$k <- (sl$'lower level'$degree -
                               sl$'lower level'$mean.k)/sl$'lower level'$sd.k
        return(sl)
    })

    ## extract the values and make a dataframe
    specs  <-  mapply(function(a, b)
        getSpec(species.lev = a,
                names.net = b,
                seps="[.]"),
        a = species.lev,
        b = names(nets),
        SIMPLIFY = FALSE)

    specs <- do.call(rbind, specs)
    rownames(specs) <- NULL

    specs$ypr <- spec$ypr[match(paste(specs$Site,
                                      specs$assem),
                                paste(spec$Site, spec$Year))]

    specs$SiteStatus <- spec$SiteStatus[match(paste(specs$Site,
                                                    specs$assem),
                                              paste(spec$Site,
                                                    spec$Year))]
    specs$SiteStatus <- factor(specs$SiteStatus,
                               levels= c("control", "maturing",
                                         "mature"))

    specs$overall.spec <- traits[,spec.metric][match(specs$GenusSpecies,
                                                     traits$GenusSpecies)]

    specs$specialization <- "spec"
    specs$specialization[specs$overall.spec > cutoff] <- "gen"

    return(specs)
}
