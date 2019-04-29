# Project: OCR (Optical Character Recognition) 

![image](figs/intro.png)

### [Full Project Description](doc/project4_desc.md)


+ Project summary: In this project, I created an OCR post-processing procedure to enhance Tesseract OCR output. Our project focuses on the post-processing. The whole project contains three parts: (1) Error detection (2) Error correction (3) Evaluation and performance measure. 

+ Papers: Our assigned papers are (1) [D1 On Retrieving Legal Files](https://github.com/TZstatsADS/Spring2019-Proj4-grp11/blob/master/doc/paper/D-1.pdf). and (2) [C3 Probability Scoring for Spelling Correction](https://github.com/TZstatsADS/Spring2019-Proj4-grp11/blob/master/doc/paper/C-3.pdf) 

**(1) Error Detection**
Since we figured that there are thirteen text files whose total number of lines do not match between their corresponding ground_truth and tesseract files (We did line checks), we manually trimmed the lines of those files and saved all those files in the folder called "ground_truth_trimmed. Then we implemented the rest five methods of error detection. Detail of the total eight methods for error detection can be seen from the following figure.
![image](https://github.com/TZstatsADS/Spring2019-Proj4-grp11/blob/master/figs/8methods_for_error_detection.png)

**(2) Error Correction**
As for correction, we used Bayesian probability scoring method, which utilizes two types of information sources: prior and channel. MLE and ELE estimation methods were applied. Since the MLE method is poor when observed frequency of a certain word is zero, we decided to implement ELE method. (1) Calculate the prior: we first calculated the frequency of each word (freq(c)) in the ground truth file. Then applied the ELE calculation, (freq(c) + 0.5) / (N + V /2), in which N is the length of english.words, and V is the length in the ground truth. (2) Calculate the channel: For the denominator, we calculated the number of times a certain character or consecutive two characters appears in the training set. For the numerator, We first found the correction candidates of the typo, and we figured which kind of typo it is (There are total four kinds: del, add, sub, rev), and where (which position) the typo is. And used the provided confusion matrix to calculate. Then we extracted the value from confusion matrix. For the denominator we can also extract from the table we calculated previously.

**(3) Evaluation and performance measure**
Finally, we evaluate the performance the algorithms by comparing the word-level and character-level precision and recall. For the number of correct items in the precision and recall functions. We used the following method to calculate: we combine the cleaned words and the corrected words and took the intersection with the ground truth. For character-wise:
We split the OCR, corrected list and ground truth into characters, and calculated the intersection between the characters in corrected list and those in ground truth. 


```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
