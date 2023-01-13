# Annotation

anno_palmieri <- AnnotationDbi::select(hugene10sttranscriptcluster.db,
                                  keys = (featureNames(palmieri_manfiltered)),
                                  columns = c("SYMBOL", "GENENAME"),
                                  keytype = "PROBEID")

anno_palmieri <- subset(anno_palmieri, !is.na(SYMBOL))

# removing multiple mapping

anno_grouped <- group_by(anno_palmieri, PROBEID)
anno_summarized <- 
  dplyr::summarize(anno_grouped, no_of_matches = n_distinct(SYMBOL))

head(anno_summarized)
anno_filtered <- filter(anno_summarized, no_of_matches > 1)


ids_to_exlude <- (featureNames(palmieri_manfiltered) %in% probe_stats$PROBEID)

table(ids_to_exlude)

palmieri_final <- subset(palmieri_manfiltered, !ids_to_exlude)

validObject(palmieri_final)

fData(palmieri_final)$PROBEID <- rownames(fData(palmieri_final))

fData(palmieri_final) <- left_join(fData(palmieri_final), anno_palmieri)

   Joining, by = "PROBEID"

# restore rownames after left_join
rownames(fData(palmieri_final)) <- fData(palmieri_final)$PROBEID 
    
validObject(palmieri_final)


# Linear models for IBM vs normal tissue

individual <- 
  as.character(Biobase::pData(palmieri_final)$Characteristics.individual.)

tissue <- str_replace_all(Biobase::pData(palmieri_final)$Factor.Value.phenotype.,
                  " ", "_")

tissue <- ifelse(tissue == "muscle",
                 "nI", "I")

disease <- 
  str_replace_all(Biobase::pData(palmieri_final)$Factor.Value.disease.,
                  " ", "_")
disease <- 
  ifelse(str_detect(Biobase::pData(palmieri_final)$Factor.Value.disease., 
                    "IBM"), "IBM", "Normal Tissue")
                    
  i_IBM <- individual[disease == "CD"]
design_palmieri_IBM <- model.matrix(~ 0 + tissue[disease == "IBM"] + i_IBM)
colnames(design_palmieri_IBM)[1:2] <- c("IBM", "NT")
rownames(design_palmieri_IBM) <- i_IBM 

i_NT <- individual[disease == "NT"]
design_palmieri_NT <- model.matrix(~ 0 + tissue[disease == "Normal Tissue"] + i_NT )
colnames(design_palmieri_NT)[1:2] <- c("IBM", "NT")
rownames(design_palmieri_NT) <- i_NT



