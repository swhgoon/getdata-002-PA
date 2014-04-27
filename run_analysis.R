# Peer Assessment - Getting and Cleaning Data Project
# https://class.coursera.org/getdata-002/human_grading/
# Steps:
# 1 Download this script to your working directory.
# 2 Download & unzip datafile there for the folder "UCI HAR Dataset".
# 3 Run
# > source("run_analysis.R")
# > run_analysis()

run_analysis <- function() {
    mainpath <- getwd()
    setwd(file.path(mainpath, "UCI HAR Dataset"))
    ## subject: train + test
    subject <- rbind(read.table("train/subject_train.txt", col.names = "Subject"), #
                     read.table("test/subject_test.txt", col.names = "Subject"))
    ## y: train + test
    y <- rbind(read.table("train/y_train.txt", col.names = "Code"), #
               read.table("test/y_test.txt",  col.names = "Code"))  
    a <- read.table("activity_labels.txt", col.names = c("Code", "Label"))
    y$Name <- a$Label[y$Code]
    ## x: train + test
    x <- rbind(read.table("train/X_train.txt"),#
                      read.table("test/X_test.txt"))
    ## tidy
    d <- cbind(subject, y)  
    f <- read.table("features.txt",#
                    col.names = c("Index", "Name"), colClasses = c("integer", "character"))
    idx <- f[grep("mean|std", f$Name, ignore.case = TRUE), ]
    for (i in seq(nrow(idx))) {
        tmp <- data.frame(x[, idx$Index[i]])
        colnames(tmp) <- idx$Name[i]
        d <- cbind(d, tmp)
    }
    r <- as.data.frame(#
      aggregate(d[, -(1:3)], list(Subject = d$Subject, Activity = d$Name), mean))
    # back to mainpath and save
    setwd(mainpath)
    write.table(r, "tidydata.txt")
} 
