# filtering based on intensities 


palmieri_medians <- rowMedians(Biobase::exprs(palmieri_eset_norm))

hist_res <- hist(palmieri_medians, 100, col = "cornsilk1", freq = FALSE, 
            main = "Histogram of the median intensities", 
            border = "antiquewhite4",
            xlab = "Median intensities")
            
man_threshold <- any number

hist_res <- hist(palmieri_medians, 100, col = "cornsilk", freq = FALSE, 
            main = "Histogram of the median intensities",
            border = "antiquewhite4",
            xlab = "Median intensities")

abline(v = man_threshold, col = "coral4", lwd = 2)

no_of_samples <- 
  table(paste0(pData(palmieri_eset_norm)$Factor.Value.disease., "_", 
                  pData(palmieri_eset_norm)$Factor.Value.phenotype.))
no_of_samples


samples_cutoff <- min(no_of_samples)

idx_man_threshold <- apply(Biobase::exprs(palmieri_eset_norm), 1,
                           function(x){
                          sum(x > man_threshold) >= samples_cutoff})
                          table(idx_man_threshold)

   idx_man_threshold
   FALSE  TRUE 
   10493 22804

palmieri_manfiltered <- subset(palmieri_eset_norm, idx_man_threshold)
