# Example file: 
# This file queries the medical literature (PubMed records) on depression from 1995 to 2015; 
# then, it examines the network centrality (eigenvector centrality) 
# of the term "Internet" within the 2004-2014 results; 
# finally, three text files are generated: 
# a) a summary of results for the most popular terms linking "depression" and "Internet" during 2004-2014, 
# which was used with Plotly to generate this plot: http://goo.gl/LPCfkX ;
# b) two .csv files containing connectivity matrices to be used with Gephi to visualize the results 
# of the queries for 2004 and 2014 (http://goo.gl/J7K06z). 

    rm(list = ls(all = TRUE))

# setwd("/rpubmed4")

library(RISmed)
library(plyr)
library(igraph)
source("RanWalk.r")
source("getProbabilities.r")


queries <- list(r14to15 = "depression[MeSH] AND 2014/01/01[Date - MeSH] : 2015/01/01[Date - MeSH] ",
                r12to13 = "depression[MeSH] AND 2012/01/01[Date - MeSH] : 2013/01/01[Date - MeSH] ",
                r10to11 = "depression[MeSH] AND 2010/01/01[Date - MeSH] : 2011/01/01[Date - MeSH] ",
                r08to09 = "depression[MeSH] AND 2008/01/01[Date - MeSH] : 2009/01/01[Date - MeSH] ",
                r06to07 = "depression[MeSH] AND 2006/01/01[Date - MeSH] : 2007/01/01[Date - MeSH] ",
                r04to05 = "depression[MeSH] AND 2004/01/01[Date - MeSH] : 2005/01/01[Date - MeSH] ",
                r02to03 = "depression[MeSH] AND 2002/01/01[Date - MeSH] : 2003/01/01[Date - MeSH] ",
                r00to01 = "depression[MeSH] AND 2000/01/01[Date - MeSH] : 2001/01/01[Date - MeSH] ",
                r98to99 = "depression[MeSH] AND 1998/01/01[Date - MeSH] : 1999/01/01[Date - MeSH] ",
                r96to97 = "depression[MeSH] AND 1996/01/01[Date - MeSH] : 1997/01/01[Date - MeSH] ",
                r94to95 = "depression[MeSH] AND 1994/01/01[Date - MeSH] : 1995/01/01[Date - MeSH] ")

resres0 <- lapply(queries, getGraph)

nn <- lapply(resres0[1:6], graph.strength)
nn <- lapply(nn, function(x) names(x)[x>=10])
nn <- table(unlist(nn))
nn[nn>=length(resres0[1:6])] # so, Internet runs from 1:6 in all graphs


resres1 <- lapply(resres0[1:6], function(x) getProbabilities(x, "Internet"))

resres2 <- rbind.fill(lapply(resres1, function(x) as.data.frame(t(x$Probs))))

resres3 <- resres2[,-c(1, 6, 7)]
rownames(resres3) <- c("2014", "2012", "2010", "2008", "2006", "2004")

resres4 <- rbind(resres3, total=colSums(resres3, na.rm=T))

# for plotly: 
TOwrite <- apply(resres3[,1:15], 2, scale)
rownames(TOwrite) <- c("2014", "2012", "2010", "2008", "2006", "2004")
write.table(TOwrite, file= "trial2.txt",quote=F, sep=";")

# for gephi: 
mat2010 <- resres1[[3]]$Network
mat2010[mat2010<=55] <- 0
mat2010 <- empty(mat2010)
mat2010 <- mat2004[-c(1,3), -c(1,3)]
colnames(mat2010) <- gsub(" ", "_", colnames(mat2010))
colnames(mat2010) <- gsub(",", "", colnames(mat2010))
rownames(mat2010) <- gsub(" ", "_", rownames(mat2010))
rownames(mat2010) <- gsub(",", "", rownames(mat2010))
# write.table(mat2010, file= "mat2010.csv",quote=F, sep=";")

mat2014 <- resres1[[1]]$Network
mat2014[mat2014<=55] <- 0
mat2014 <- empty(mat2014)
mat2014 <- mat2014[-c(1,10), -c(1,10)]
colnames(mat2014) <- gsub(" ", "_", colnames(mat2014))
colnames(mat2014) <- gsub(",", "", colnames(mat2014))
rownames(mat2014) <- gsub(" ", "_", rownames(mat2014))
rownames(mat2014) <- gsub(",", "", rownames(mat2014))
# write.table(mat2014, file= "mat2014.csv",quote=F, sep=";")

