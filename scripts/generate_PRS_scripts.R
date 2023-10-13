#!/s/bin/R35
repos <- "https://cloud.r-project.org"
if (!require(glue)) {
    install.packages("glue", repos = repos)
    library(glue)
}
if (!require(R.utils)) {
    install.packages("R.utils", repos = repos)
    library(R.utils)
}
if (!require(plyr)) {
    install.packages("plyr", repos = repos)
    library(plyr)
}
if (!require(bigsnpr)) {
    install.packages("bigsnpr", repos = repos)
    library(bigsnpr)
}
if (!require(bigreadr)) {
    install.packages("bigreadr", repos = repos)
    library(bigreadr)
}
if (!require(optparse)) {
    install.packages("optparse", repos = repos)
    library(optparse)
}
if (!require(tidyverse)) {
    install.packages("tidyverse", repos = repos)
    library(tidyverse)
}

options(stringsAsFactors=F)
args = commandArgs(trailingOnly=TRUE)
wd <- as.character(args[1])
h2 <- as.numeric(args[2])
k <- as.numeric(args[3])

####################### Implement all PRS methods in condor ###################
### parameter initialization ###
N <- 60000
script_num <- 1
#################################### pumas ####################################
pumas <- "F"

# LDpred2
system(glue("Rscript ./prs_methods/LDpred2.R {wd} {h2} {N} {k} {pumas} {script_num}"))
script_num <- script_num + k*22
