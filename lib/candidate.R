# choose candidates that are one generalized Levenshtein (edit) distance away from the typo
choose_candidate <- function(typo){
  dist <- levenshtein.damerau.distance(tolower(typo), candidate_dict)
  result = candidate_dict[dist == 1]
  return(result)
} 
