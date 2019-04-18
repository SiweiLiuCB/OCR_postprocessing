##############################
## Garbage detection
## Ref: first three rules in the paper
##      'On Retrieving Legal Files: Shortening Documents and Weeding Out Garbage'
## Input: one word -- token
## Output: bool -- if the token is clean or not
##############################
ifCleanToken <- function(cur_token){
  now <- 1
  if_clean <- TRUE
  
  ## in order to accelerate the computation, conduct ealy stopping
  rule_list <- c("str_count(cur_token, pattern = '[A-Za-z0-9]') <= 0.5*nchar(cur_token)", 
                 # If the number of punctuation characters in a string is greater than the number of alphanumeric characters, it is garbage
                 "length(unique(strsplit(gsub('[A-Za-z0-9]','',substr(cur_token, 2, nchar(cur_token)-1)),'')[[1]]))>1", 
                 #Ignoring the first and last characters in a string, if there are two or more different punctuation characters in thestring, it is garbage
                 "nchar(cur_token)>20", 
                 #A string composed of more than 20 symbols is garbage
                 "gsub('([A-Za-z0-9])\\1\\1+', '', cur_token)!=cur_token", 
                 #If there are three or more identical characters in a row in a string, it is garbage
                 "(length(strsplit(gsub('[:a-z:]','',cur_token),NULL)[[1]]) > length(strsplit(gsub('[:A-Z:]','',cur_token),NULL)[[1]])) & (length(strsplit(gsub('[:a-z:]','',cur_token),NULL)[[1]]) < length(strsplit(cur_token,NULL)[[1]]))", 
                 #If the number of uppercase characters in a string is greater than the number of lowercase characters, and if the number of uppercase characters is less than the total number of characters in the string, it is garbage
                 "grepl('^[A-Za-z]+$', cur_token, perl = T) & nchar(cur_token)>3 & ((8*str_count(cur_token,char_class('aeiouAEIOU')) < str_count(cur_token,pattern= '[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]')) | (8*str_count(cur_token,pattern= '[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]') < str_count(cur_token,char_class('aeiouAEIOU'))))", 
                 #If all the characters in a string are alphabetic, and if the number of consonants in the string is greater than 8 times the number of vowels in the string, or vice-versa, it is garbage
                 "(length(grep('^.*[aeiouAEIOU]{4}', cur_token, value = TRUE)) == 1) | (length(grep('^.*[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]{5}', cur_token, value = TRUE)) == 1)", 
                 #If there are four or more consecutive vowels in the string or five or more consecutive consonants in the string, it is garbage
                 "grepl('[[:lower:]]', substr(cur_token, 1, 1)) & grepl('[[:lower:]]', substr(cur_token, nchar(cur_token), nchar(cur_token))) & (length(grep('[A-Z]', substr(cur_token, 2, nchar(cur_token)-1))) == 1)" 
                 #If the first and last characters in a string are both lowercase and any other character is uppercase, it is garbage
  )  
  
  
  while((if_clean == TRUE)&now<=length(rule_list)){
    if(eval(parse(text = rule_list[now]))){
      if_clean <- FALSE
    }
    now <- now + 1
  }
  return(if_clean)
}