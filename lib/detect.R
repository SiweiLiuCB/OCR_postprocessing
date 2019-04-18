detect <- function(current_tesseract_txt, current_ground_truth_txt, mismatch_info) {
  
  ############################################################################################
  #### this function is to find matching ground truth words for those detected error words ###
  ############################################################################################
  
  tesseract_vec_by_line <- list()
  tesseract_if_clean_by_line <- list()
  tesseract_vec <- NULL
  tesseract_if_clean <- NULL
  ground_truth_vec_by_line <- list()
  ground_truth_err_by_line <- list()
  ground_truth_err <- NULL
  
  for (i in 1:length(current_tesseract_txt)){
    tesseract_vec_by_line[[i]] <- str_split(current_tesseract_txt[i]," ")[[1]]
    tesseract_if_clean_by_line[[i]] <- unlist(lapply(tesseract_vec_by_line[[i]],ifCleanToken))
    tesseract_vec <- c(tesseract_vec, tesseract_vec_by_line[[i]])
    tesseract_if_clean <- c(tesseract_if_clean, tesseract_if_clean_by_line[[i]])
    ground_truth_vec_by_line[[i]] <- str_split(current_ground_truth_txt[i]," ")[[1]]
    
    ## if the number of words in corresponding row are not equal, 
    ## extract previous and following 2 words of the error word (total of 5 ), 
    ## and apply string-distance function (stringdist) to locate the most likely ground truth word.
    
    if ((i %in% mismatch_info$mismatch_line) & (sum(!tesseract_if_clean_by_line[[i]])>0)){
      tesseract_errorword <- tesseract_vec_by_line[[i]][!tesseract_if_clean_by_line[[i]]]
      #tesseract_errorword <- tesseract_errorword[tesseract_errorword!=""]
      err_index <- which(!tesseract_if_clean_by_line[[i]])
      suspect_index <- list()
      for (j in 1:length(err_index)) {
        ## Locate the error word index and the nearby words (+/- 2 words)
        suspect_index[[j]] <- c(err_index[j]-2,err_index[j]-1,err_index[j],err_index[j]+1,err_index[j]+2)
        suspect_index[[j]] <- suspect_index[[j]][suspect_index[[j]]>0 & suspect_index[[j]]<=length(tesseract_if_clean_by_line[[i]])]
      }
      
      ## Extract ground truth words and its nearby words (+/-2)
      suspect_ground_truth <- lapply(suspect_index, function(z) ground_truth_vec_by_line[[i]][z])  
      
      ## Select the most likely ground truth word from "suspect_ground_truth"
      grdth_temp <- NULL
      for (j in 1:length(err_index)) {
        err_distance <- stringdist::stringdist(suspect_ground_truth[[j]],tesseract_errorword[j])
        if (length(sum(min(err_distance) == err_distance))>1){
          err_index_temp1 <- which(err_distance == min(err_distance))
          err_index_temp2 <- which.min(abs(nchar(suspect_ground_truth[[j]][err_distance == min(err_distance)]) - nchar(tesseract_errorword[j])))
          err_index_temp <- err_index_temp1[err_index_temp2]
          grdth_temp <- c(grdth_temp, suspect_ground_truth[[j]][err_index_temp])
        } else {
          grdth_temp <- c(grdth_temp, suspect_ground_truth[[j]][which.min(err_distance)])
        }
      }
      ground_truth_err_by_line[[i]] <- grdth_temp
      ground_truth_err <- c(ground_truth_err, ground_truth_err_by_line[[i]])
    } else {
      ## For word count matching lines, simply transfer the index over and extract the corresponding ground truth word
      ground_truth_err_by_line[[i]] <- ground_truth_vec_by_line[[i]][!tesseract_if_clean_by_line[[i]]]
      ground_truth_err <- c(ground_truth_err, ground_truth_err_by_line[[i]])
    }
  }
  
  tesseract_delete_error_vec <- tesseract_vec[tesseract_if_clean]
  tesseract_err <- tesseract_vec[!tesseract_if_clean]
  comparison <- cbind.data.frame(tesseract_err, ground_truth_err)
  
  # return a list of two items:
  # 1. comparison table (left column: detected error word in tesseract; right column: suspected ground truth word)
  # 2. tesseract_delete_error_vec: tesseract word vectors with clean words only
  
  return(list(comparison=comparison,tesseract_delete_error_vec=tesseract_delete_error_vec))
}