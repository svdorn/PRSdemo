#!/s/bin/R35
suppressMessages(library(data.table))
suppressMessages(library(R.utils))
options(stringsAsFactors=F)
args = commandArgs(trailingOnly=TRUE)
wd <- as.character(args[1])

extract_fid_iid <- function(dat,fid,iid){
    out <- data.frame(FID=dat[,fid],IID=dat[,iid])
    return(out)
}

extract_score_data <- function(prs_name, num_weights) {
    scores <- c()
    for (i in 1:num_weights) {
        # read scores from .profile file
        dat <- as.data.frame(fread(paste0(wd, "/", prs_name, ".", i+2, ".profile"), header = TRUE))
        # normalize the score
        score <- dat[,"SCORESUM"]
        normalized_score <- (score - mean(score)) / sd(score)
        # add the score to the vector of different versions of scores
        scores <- cbind(scores, normalized_score)
        colnames(scores)[i] <- paste0(prs_name, ".", i)
    }

    return(scores)
}

cat("\nCreating table for final PRS scores from LDpred2 and default PRS methods and normalizing scores...")
# Set initial table for prs scores
dat.tmp <- as.data.frame(fread(paste0(wd,"/ldpred2.3.profile"), header = TRUE))
dat <- extract_fid_iid(dat.tmp,fid="FID",iid="IID")
colnames(dat) <- c("FID", "IID")
prs_scores <- dat

# Extract LD Pred2 PRS scores
prs_scores <- cbind(prs_scores, extract_score_data("ldpred2", 11))
# Extract Default PRS scores
prs_scores <- cbind(prs_scores, extract_score_data("default", 5))

# write prs scores data to file
fwrite(prs_scores,"./prs_scores.txt",col.names=T,row.names=F,sep="\t",quote=F)
cat("\n\nFinal PRS scores written to file: ./prs_scores.txt\n")