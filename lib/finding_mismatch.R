finding_mismatch <- function(tess = current_tesseract_txt, grdth = current_ground_truth_txt){
  
# This function is to locate the row index of those lines with mismatching number of words
  
  tess_num <- sapply(strsplit(tess, " "), length)
  grdth_num <- sapply(strsplit(grdth, " "), length)
  mismatch_line <- which(tess_num != grdth_num)
  mismatch_tess_num <- tess_num[tess_num != grdth_num]
  mismatch_grdth_num <- grdth_num[tess_num != grdth_num]
  
  # Return 3 items:
  # 1. row index for those mismatching ones
  # 2. total number of words for that row from tesseract
  # 3. total number of words for that row from ground_truth
  
  return(list(mismatch_line=mismatch_line, mismatch_tess_num=mismatch_tess_num, mismatch_grdth_num=mismatch_grdth_num))
}



