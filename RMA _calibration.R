# RMA

palmieri_eset_norm <- oligo::rma(raw_data, target = "core")

# Plot the PCA analysis of the calibrated data analogously to the one with the raw data
exp_palmieri <- Biobase::exprs(palmieri_eset_norm)
PCA <- prcomp(t(exp_palmieri), scale = FALSE)

percentVar <- round(100*PCA$sdev^2/sum(PCA$sdev^2),1)
sd_ratio <- sqrt(percentVar[2] / percentVar[1])

dataGG <- data.frame(PC1 = PCA$x[,1], PC2 = PCA$x[,2],
                    Disease = 
                     Biobase::pData(palmieri_eset_norm)$Factor.Value.disease.,
                    Phenotype = 
                     Biobase::pData(palmieri_eset_norm)$Factor.Value.phenotype.)


ggplot(dataGG, aes(PC1, PC2)) +
      geom_point(aes(shape = Disease, colour = Phenotype)) +
  ggtitle("PCA plot of the calibrated, summarized data") +
  xlab(paste0("PC1, VarExp: ", percentVar[1], "%")) +
  ylab(paste0("PC2, VarExp: ", percentVar[2], "%")) +
  theme(plot.title = element_text(hjust = 0.5)) +
  coord_fixed(ratio = sd_ratio) +
  scale_shape_manual(values = c(4,15)) + 
  scale_color_manual(values = c("darkorange2", "dodgerblue4"))
  
  # Heatmap clustering analysis
  
  phenotype_names <- ifelse(str_detect(pData
                                    (palmieri_eset_norm)$Factor.Value.phenotype.,
                             "non"), "non_infl.", "infl.")

disease_names <- ifelse(str_detect(pData
                                    (palmieri_eset_norm)$Factor.Value.disease.,
                             "Crohn"), "CD", "UC")

annotation_for_heatmap <- 
  data.frame(Phenotype = phenotype_names,  Disease = disease_names)

row.names(annotation_for_heatmap) <- row.names(pData(palmieri_eset_norm))


dists <- as.matrix(dist(t(exp_palmieri), method = "manhattan"))

rownames(dists) <- row.names(pData(palmieri_eset_norm))
hmcol <- rev(colorRampPalette(RColorBrewer::brewer.pal(9, "YlOrRd"))(255))
colnames(dists) <- NULL
diag(dists) <- NA

ann_colors <- list(
  Phenotype = c(non_infl. = "chartreuse4", infl. = "burlywood3"),
  Disease = c(CD = "blue4", UC = "cadetblue2")
                   )
pheatmap(dists, col = (hmcol), 
         annotation_row = annotation_for_heatmap,
         annotation_colors = ann_colors,
         legend = TRUE, 
         treeheight_row = 0,
         legend_breaks = c(min(dists, na.rm = TRUE), 
                         max(dists, na.rm = TRUE)), 
         legend_labels = (c("small distance", "large distance")),
         main = "Clustering heatmap for the calibrated samples"
         
         
