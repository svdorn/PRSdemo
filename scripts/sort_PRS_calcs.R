#!/s/bin/R35
library(glue)
library(data.table)
library(R.utils)
options(stringsAsFactors=F)
args = commandArgs(trailingOnly=TRUE)
in_folder <- as.character(args[1])
k <- as.numeric(args[2])
out_folder <- paste0(in_folder,"/PRSweights/prs_scores/")

extract_scoresum <- function(dat,fid,iid,scoresum){
    out <- data.frame(FID=dat[,fid],IID=dat[,iid],Scoresum=dat[,scoresum])
    return(out)
}

extract_score_data <- function(prs_name, num_weights) {
    scores <- c()
    for (i in 1:num_weights) {
        dat <- as.data.frame(fread(paste0(in_folder, "/PRSweights/final_weights/", prs_name, ".", i, ".profile", header = TRUE)))

        scores <- cbind(scores, dat[,"SCORESUM"])
    }

    return(scores)
}

# Extract LD Pred2 data
# Set initial table for prs scores
prs_scores <- c()

# Extract LD Pred2 PRS scores
extract_score_data("ldpred2", 11)
# Extract Default PRS scores
extract_score_data("default", 5)
params <- c(1:13)
for (j in 3:length(params)){
    dat <- c()
    dat.tmp <- as.data.frame(fread(paste0(in_folder,"/PRSweights/final_weights/ldpred2.",j,".profile"), header = TRUE))
    dat.sorted <- extract_scoresum(dat.tmp,fid="FID",iid="IID",scoresum="SCORESUM")
    dat <- rbind(dat,dat.sorted)

    if(j == 3) {
        colnames(dat) <- c("FID", "IID", paste0("LD Pred2 ", j - 2))
        lddat <- dat
    } else {
        lddat <- cbind(lddat, dat[,3])
        colnames(lddat)[j] <- paste0("LD Pred2 ", j - 2)
    }
}

# Extract default PRS score data
for (j in 1:5) {
    dat.tmp <- as.data.frame(fread(paste0(in_folder,"/PRSweights/final_weights/default.",j,".profile"), header = TRUE))
    dat <- extract_scoresum(dat.tmp,fid="FID",iid="IID",scoresum="SCORESUM")

    if (j == 1) {

    }
}

fwrite(lddat,paste0(out_folder,"ite",k,".ldpred2_prs.txt"),col.names=T,row.names=F,sep="\t",quote=F)