library(synapseClient)
library(plyr)
library(dplyr)
library(reshape2)

synapseLogin()

# Get public mapped bams
qPublic <- "select UID,id,bamType,benefactorId from file where benefactorId=='syn1773109' and fileType=='bam'"
resPublic <- tbl_df(synQuery(qPublic))
colnames(resPublic) <- gsub(".*\\.", "", colnames(resPublic))

# Get private mapped and unmapped bams
qPrivate <- "select UID,id,bamType,benefactorId from file where parentId=='syn2261941' and fileType=='bam'"
resPrivate <- tbl_df(synQuery(qPrivate))
colnames(resPrivate) <- gsub(".*\\.", "", colnames(resPrivate))

res <- rbind(resPublic, resPrivate)

resByBamType <- dcast(res, UID ~ bamType, value.var="id")
bad <- apply(resByBamType[, c("mapped", "unmapped")], 1, function(x) any(is.na(x)))

resGood <- resByBamType[!bad, ]

write.csv(resGood, file="bam_samples.csv", row.names=FALSE)
