type_of_typo <- function(typo, candidate_chosen){
  distance <- adist(tolower(typo), candidate_chosen, counts = TRUE)
  #classify the type of typo
  typo_type = NA
 
  if (distance > 0){
  # deletion
  if (attr(distance, "counts")[,,'ins'] == 1 & distance != 2){
  typo_type = "DEL"
  }
  #insertion
  if (attr(distance, "counts")[,,'del'] == 1 & distance != 2) {
    typo_type = "INS"
  } 
  #reversal
  if (distance == 2){
  typo_type = "REV"
  }
  #substitution
  if (attr(distance, "counts")[,,'sub'] == 1){
  typo_type = "SUB"
  }
  }
  return(typo_type)
}


perform_correction <- function(typo){
  # check if typo has any candiates
  candidates <- choose_candidate(typo)
  if(length(candidates)==0) {
    return(list(correction = typo, type = NA))
  }
  else {
    #choose the candidate with highest score
    scores <- sapply(candidates, calculate_score, typo) 
    candidate_chosen <- candidates[which.max(scores)]
    return(list(correction = candidate_chosen, type = type_of_typo(typo, candidate_chosen)))
  }
}


