#!/s/bin/R35
library(glue)
library(data.table)
library(R.utils)
library(tidyverse)
library(dplyr)
options(stringsAsFactors=F)
args = commandArgs(trailingOnly=TRUE)
in_folder <- as.character(args[1])
k <- as.numeric(args[2])
out_folder <- paste0(in_folder,"/PRSweights/sorted_prs/")


####################### define helper functions ###################
# Obtain necessary information from PRS output for PRS calculation
extract_snp_weights <- function(dat,snp,a1,weight){
    out <- data.frame(SNP=dat[,snp],A1=dat[,a1],Weight=dat[,weight])
    return(out)
}


####################### Sort all PRS weights in condor ###################
### parameter initialization ###

# LDpred2
params <- c(1:13)
for (ite in 1:k){
    for (j in 1:length(params)){
        dat <- c()
        weight.col <- j + 2
        for (chr in 1:22) {
            dat.tmp <- as.data.frame(fread(paste0(in_folder,"/PRSweights/prs/ite",ite,".chr",chr,".ldpred2.txt"),header=F))
            dat.sorted <- extract_snp_weights(dat=dat.tmp,snp="V1",a1="V2",weight=weight.col)
            dat <- rbind(dat,dat.sorted)
        }
        dat[,3] <- dat[,3]/sd(dat[,3])
        if(j == 1) {
            lddat <- dat
        } else {
            lddat <- cbind(lddat, dat[,3])
        }
    }

    fwrite(lddat,paste0(out_folder,"ite",ite,".ldpred2.txt"),col.names=F,row.names=F,sep="\t",quote=F)

}

# prs default - use beta sumstats above p-value threshold
p_value_cutoff <- c(0.01, 0.05, 0.1, 0.5, 1)
for (ite in 1:k) {
    gwas.raw <- as.data.frame(fread(paste0(in_folder,"/gwas_QCed/gwas_RL_",ite,".txt.gz"),header=T))
    gwas.out <- gwas.raw[,c(3,4,7,9)]
    colnames(gwas.out) <- c("snp","a1","weight","p")

    for (j in 1:length(p_value_cutoff)) {
        dat <- gwas.out
        
        dat <- dat %>% 
            mutate(weight = ifelse(p <= p_value_cutoff[j], weight, 0), p = NULL)
        
        if(j == 1) {
            default.dat <- dat
        } else {
            default.dat <- cbind(default.dat, dat[,3])
        }
    }

    fwrite(default.dat,paste0(out_folder,"ite",ite,".default.txt"),col.names=F,row.names=F,sep="\t",quote=F)
}