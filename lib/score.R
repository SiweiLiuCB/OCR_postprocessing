calculate_score <- function(candidates, typo, prior=priors){
  score <- priors[[candidates]] * channel_prob(candidates, typo) 
  return(score)
}
