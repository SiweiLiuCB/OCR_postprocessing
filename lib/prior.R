#define ELE function
ele <- function(x) {
  N <- 44000000
  V <- 112946
  pr_c <- (x + 0.5)/(N + V/2)
  return(pr_c)
}


# calculate the prior probabilities 
prior_prob <- function(train_vec, method = 'ele'){
  train_vec <- tolower(train_vec)
  #calculate freq(c)
  freqs <- rep(list(0), length(candidate_dict))
  names(freqs) <- candidate_dict
  nonzero_freqs <- table(train_vec) 
  nonzero_prob <-  table(train_vec)/length(train_vec) #for mle
  if (method == "ele"){
  freqs[names(nonzero_freqs)] <- nonzero_freqs
  priors <- lapply(freqs, ele) #ELE
  }
  if (method == "mle"){
    freqs[names(nonzero_prob)] <- nonzero_prob
    priors <- freqs
  }
  return(priors)
}

