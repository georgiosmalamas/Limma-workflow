# Package installation
# 21/01/2023


### if (!require("BiocManager"))
    install.packages("BiocManager")
BiocManager::install("maEndToEnd", version = "devel")
install.packages("devtools")
library(devtools)

devtools::install_github("r-lib/remotes")
library(remotes)
packageVersion("remotes") 

remotes::install_github("b-klaus/maEndToEnd", ref="master")
#General Bioconductor packages
    library(Biobase)
    library(oligoClasses)
     
#Annotation and data import packages
    library(ArrayExpress)
    library(pd.hugene.1.0.st.v1)
    library(hugene10sttranscriptcluster.db)
     
#Quality control and pre-processing packages
    library(oligo)
    library(arrayQualityMetrics)
     
#Analysis and statistics packages
    library(limma)
    library(topGO)
    library(ReactomePA)
    library(clusterProfiler)
     
#Plotting and color options packages
    library(gplots)
    library(ggplot2)
    library(geneplotter)
    library(RColorBrewer)
    library(pheatmap)
    library(enrichplot)
     
#Formatting/documentation packages
    library(rmarkdown)
    library(BiocStyle)
    library(dplyr)
    library(tidyr)

#Helpers:
    library(stringr)
    library(matrixStats)
    library(genefilter)
    library(openxlsx)
    library(devtools)
    
