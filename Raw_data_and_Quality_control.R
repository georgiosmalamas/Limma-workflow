# Downloading raw data

raw_data_dir <- tempdir()

if (!dir.exists(raw_data_dir)) {
    dir.create(raw_data_dir)
}

anno_AE <- getAE("E-MTAB-XXXX", path = raw_data_dir, type = "raw")

# Import of annotation data and microarray expression data as “ExpressionSet

sdrf_location <- file.path(raw_data_dir, "E-MTAB-XXXX.sdrf.txt")
SDRF <- read.delim(sdrf_location)

rownames(SDRF) <- SDRF$Array.Data.File
SDRF <- AnnotatedDataFrame(SDRF)

# Import CEL files

raw_data <- oligo::read.celfiles(filenames = file.path(raw_data_dir, 
                                                SDRF$Array.Data.File),
                                    verbose = FALSE, phenoData = SDRF)
stopifnot(validObject(raw_data))

head(Biobase::pData(raw_data))

#Selectfor the desired columns
Biobase::pData(raw_data) <- Biobase::pData(raw_data)[, c("x", "y.", "z")]

## Quality control

Biobase::exprs(raw_data)
exp_raw <- log2(Biobase::exprs(raw_data))
PCA_raw <- prcomp(t(exp_raw), scale. = FALSE)

percentVar <- round(100*PCA_raw$sdev^2/sum(PCA_raw$sdev^2),1)
sd_ratio <- sqrt(percentVar[2] / percentVar[1])

dataGG <- data.frame(PC1 = PCA_raw$x[,1], PC2 = PCA_raw$x[,2],
                    Disease = pData(raw_data)$Factor.Value.disease.,
                    Phenotype = pData(raw_data)$Factor.Value.phenotype.,
                    Individual = pData(raw_data)$Characteristics.individual.)

ggplot(dataGG, aes(PC1, PC2)) +
      geom_point(aes(shape = Disease, colour = Phenotype)) +
  ggtitle("PCA plot of the log-transformed raw expression data") +
  xlab(paste0("PC1, VarExp: ", percentVar[1], "%")) +
  ylab(paste0("PC2, VarExp: ", percentVar[2], "%")) +
  theme(plot.title = element_text(hjust = 0.5))+
  coord_fixed(ratio = sd_ratio) +
  scale_shape_manual(values = c(4,15)) + 
  scale_color_manual(values = c("darkorange2", "dodgerblue4"))
  
  



