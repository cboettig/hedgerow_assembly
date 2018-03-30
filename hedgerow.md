Change point analysis on networks
================

Libraries

``` r
#devtools::install::github("cboettig/NetGen")
library(tidyverse)
library(graphkernels)
library(igraph)
library(NetGen)
```

Data

``` r
# A list of 36 networks
load("data/networks/baci_networks_years.Rdata")
```

And here we go:

``` r
tidy_nets <- 
        map2_df(nets, names(nets), function(x,y){
        meta <-  strsplit(y, "\\.")[[1]]
        tibble(location = meta[[1]],  year = meta[[2]], network = list(as.data.frame(x)))
})


tidy_nets
```

    ## # A tibble: 36 x 3
    ##    location year  network               
    ##    <chr>    <chr> <list>                
    ##  1 Barger   2006  <data.frame [8 × 13]> 
    ##  2 Barger   2007  <data.frame [7 × 23]> 
    ##  3 Barger   2008  <data.frame [8 × 23]> 
    ##  4 Barger   2009  <data.frame [9 × 14]> 
    ##  5 Barger   2011  <data.frame [7 × 9]>  
    ##  6 Barger   2012  <data.frame [11 × 21]>
    ##  7 Barger   2013  <data.frame [19 × 36]>
    ##  8 Barger   2014  <data.frame [9 × 25]> 
    ##  9 Butler   2007  <data.frame [8 × 15]> 
    ## 10 Butler   2008  <data.frame [7 × 15]> 
    ## # ... with 26 more rows

``` r
graphs <- tidy_nets %>% 
        filter(location == "Barger") %>% 
        pull(network) %>% 
        lapply(igraph::graph_from_incidence_matrix)
```

``` r
output <- graphkernels::CalculateGraphletKernel(graphs, par=3)
```

``` r
yrs <- tidy_nets %>%  filter(location == "Barger") %>% pull(year)

rownames(output) <-  yrs
colnames(output) <- yrs
as.data.frame(output) %>% 
        rownames_to_column("year") %>%  
        tidyr::gather(start_year, value, -year) %>%
        ggplot() + 
        geom_tile(aes(start_year, year, fill = value))
```

![](hedgerow_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

-----

# Simulated Data

``` r
time <- c(rep(1,5), rep(4, 5))

i = 1
graphs <- lapply(time, function(i){ 
        
        x = netgen(n_modav = c(250, 25), 
                  cutoffs = c(90, 10), 
                  net_type = 1, 
                  net_degree = 10,
                  net_rewire = c(0.01,0.1),
                  mod_probs = c(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0))
})
```

    ## 
    ## module count = 2 
    ## average degree = 9.896 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 9.76 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 10.096 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 9.736 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 9.868 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 9.96 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 9.832 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 10.364 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 9.584 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

    ## 
    ## module count = 2 
    ## average degree = 9.752 
    ## average module size = 125 
    ## number of components = 1 
    ## size of largest component = 250

``` r
adj_plot(graphs[[1]])
```

![](hedgerow_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
adj_plot(graphs[[10]])
```

![](hedgerow_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

``` r
output <- graphkernels::CalculateGraphletKernel(graphs, par=3)
```

``` r
rownames(output) <- 2001:2010
colnames(output) <- 2001:2010
as.data.frame(output) %>% 
        rownames_to_column("year") %>%  
        tidyr::gather(start_year, value, -year) %>%
        ggplot() + 
        geom_tile(aes(start_year, year, fill = value))
```

![](hedgerow_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->
