library(synapseClient)
library(plyr)
library(dplyr)
library(reshape2)

synapseLogin()

# Get public mapped bams
qMapped <- "select UID,id,bamType,benefactorId from file where parentId=='syn1773111' and fileType=='bam'"
resMapped <- tbl_df(synQuery(qMapped))
colnames(resMapped) <- gsub(".*\\.", "", colnames(resMapped))

# Get public unmapped bams
qUnmapped <- "select UID,id,bamType,benefactorId from file where parentId=='syn2246519'"
resUnmapped <- tbl_df(synQuery(qUnmapped))
colnames(resUnmapped) <- gsub(".*\\.", "", colnames(resUnmapped))
resUnmapped$bamType <- "unmapped"

# Get private mapped and unmapped bams
qPrivate <- "select UID,id,bamType,benefactorId from file where parentId=='syn2261941' and fileType=='bam'"
resPrivate <- tbl_df(synQuery(qPrivate))
colnames(resPrivate) <- gsub(".*\\.", "", colnames(resPrivate))

res <- rbind(resMapped, resUnmapped, resPrivate)

resByBamType <- dcast(res, UID ~ bamType, value.var="id")
bad <- apply(resByBamType[, c("mapped", "unmapped")], 1, function(x) any(is.na(x)))

resGood <- resByBamType[!bad, ]

write.csv(resGood, file="bam_samples.csv", row.names=FALSE)
