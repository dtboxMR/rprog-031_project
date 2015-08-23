WARNING: 
If the data on your computer is stored in a different directory 
you'll have to change the path on the line 11 of the script.
The comments right above this line in the script also have this warning.

For loading the resulting dataset into R use the following script 
replacing the "path" with the path to the directory you downloaded the file:
read.table(path, header = TRUE)

The script follows the following steps (those are not exactly the steps 
from the instruction to the assignment):
1. Loading Data
  1. Loading training set data
  2. Loading test set data
  3. Loading names
2. Merging Datasets
3. Extracting Variables 
4. Adding Activities and Subjects
  1. Adding activities
  2. Adding subjects
5. Creating Summary Dataset
6. Writing the Result into a File 

The are more detailed comments in the script file.

I kept the variables containing "meanFreq" in their names
because they are the components of the mean frequency 


