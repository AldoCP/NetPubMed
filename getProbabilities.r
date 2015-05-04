getGraph <- function(query0){
MaxArticles <- 1000
  res <- EUtilsSummary(query0, retmax=MaxArticles)
  summary(res)
  zz <- Mesh(EUtilsGet(res))
  zz <- lapply(zz[lapply(zz,length)>1], function(x) x[which(x$Type=="Descriptor"),])
  zz <- lapply(zz, function(x) as.vector(x[order(x[,1]),1]))
    matr2 <- function(x){ if(length(x)==1) {return(NULL)} else {return(t(combn(x,2)))}}
  zz <- ldply(lapply(zz, matr2), data.frame)[,2:3]
  zz <- zz[order(zz[,1], zz[,2]),]

  inde <- !duplicated(zz[, 1:2])
  zz <- cbind(zz[inde, ], tapply(inde, cumsum(inde), length))
  names(zz) <- c("i", "p", "w")

  adja <- graph.edgelist(as.matrix(zz[,1:2]), directed=FALSE)
  E(adja)$weight = as.numeric(zz[,3])
  return(adja)
}

getProbabilities <- function(Matr0, Nterms){
ThresArticles <- 0
  nueva<-as.matrix(get.adjacency(Matr0, attr="weight"))
      nueva[nueva<ThresArticles] <- 0
      visProbs <- randomWalk.matrix(bipartite::empty(nueva), Nterms)
  return(list(Probs = sort(visProbs, decreasing=T), Network = bipartite::empty(nueva)))
}
