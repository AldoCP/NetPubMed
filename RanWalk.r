# From https://r-forge.r-project.org/R/?group_id=1126
# Functions from RWOAG
# Functions for random walks:

      .rwr <- function(W,P0,gamma) {
          W <- t(W);    PT <- P0;    k <- 0;    delta <- 1
          while  (delta > 1e-5) {
            PT1 <- (1-gamma)*W;      PT2 <- PT1 %*% t(PT);      PT3 <- (gamma*P0);      PT4 <- t(PT2) + PT3
            delta <- sum(abs(PT4 - PT));      PT <- PT4;      k <- k + 1
          }
          return(PT)
      }

      randomWalk.matrix <- function(intM, queryGenes) {
          if(sum(!queryGenes %in% row.names(intM))>0) {
      	stop("queryGenes contains genes not found in intMat")
          }
          Ng <- dim(intM)[1]
          gamma <- 0.7
          # to get the transition matrix for gene network and normalize
          for (i in 1:Ng) {
            intM[,i] <- intM[,i]/sum(intM[,i])
          }
          p0 <- numeric(length=Ng)
          names(p0) <- row.names(intM)

          p0[queryGenes] <- 1
          p0 <- p0/sum(p0)
          res <- .rwr(t(intM),t(p0),gamma)
          return(drop(res))
      }

