# NetPubMed

These scripts allow analyzing results from a two-level query on PubMed: 

## First level query
General PubMed queries specified by the users are performed, and the MeSH terms from every article are stored in an R database. 

## Second level query
A set of MeSH terms (n>=1) are searched for within the results of the first query, using Graph-Theoretical methods. 
Briefly, it is possible to compute visitation probabilities to the other terms: given a graph including all MeSH terms from the first query, and starting random walks from the new MeSH terms specified, what other MeSH terms is the user likely to visit? 

Finally, it is possible to extract the data for plotting using tools such as Plotly and Gephi (see the file queryPubmed.r). 

