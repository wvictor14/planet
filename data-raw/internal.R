# 2023-05-21
# change Caucasian -> European
sysdata_filenames <- load("R/sysdata.rda")
nbeta <- planet:::nbeta
names(nbeta)[3] <- 'European'

# resave all internal data with updated nbeta
save(list = sysdata_filenames, file = "R/sysdata.rda")