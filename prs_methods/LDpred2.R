#!/s/bin/R35
library(data.table)
library(R.utils)
options(stringsAsFactors=F)
args = commandArgs(trailingOnly=TRUE)
wd <- as.character(args[1])
h2 <- as.numeric(args[2])
N_info <- as.numeric(args[3])
k <- as.numeric(args[4])
pumas <- as.character(args[5])
script_num <- as.numeric(args[6])

# - step 1 inputs
if (pumas=="T"){
    gwas.in.path <- paste0(wd,"/pumas/subsampled/")
    gwas.out.path <- paste0(wd,"/PRSweights/gwas_pumas/")
    out_path <- paste0(wd,"/PRSweights/pumas/")
} else {
    gwas.in.path <- paste0(wd,"/gwas_QCed/")
    gwas.out.path <- paste0(wd,"/PRSweights/gwas_prs/")
    out_path <- paste0(wd,"/PRSweights/prs/")
}


# - step 2 inputs
m <- 1030186
ldref <- "./LD/UKB_hm3_small_ref"

for (ite in 1:k){
    # - step 1
    if (pumas=="T"){
        gwas.raw <- as.data.frame(fread(paste0(gwas.in.path,"gwas_train.gwas.omnibus.ite",ite,".txt")))
    } else {
        gwas.raw <- as.data.frame(fread(paste0(gwas.in.path,"gwas_RL_",ite,".txt.gz")))
    }
    gwas.out <- gwas.raw[,c(1,3,2,10,4:8)]
    colnames(gwas.out) <- c("chr","rsid","pos","n_eff","a1","a0","MAF","beta","beta_se")
    for (chr in 1:22){
        print(chr)
        gwas.out.tmp <- gwas.out[gwas.out$chr==chr,]
        fwrite(gwas.out.tmp,paste0(gwas.out.path,"ite",ite,".chr",chr,".ldpred2.txt"),col.names=T,row.names=F,sep="\t",quote=F)
    }
    
    # - step 2
    for (chr in 1:22){
        gwas_formatted_out <- paste0(gwas.out.path,"ite",ite,".chr",chr,".ldpred2.txt")
        chr_out_path <- paste0(out_path,"ite",ite,".chr",chr,".ldpred2")
    
        # ldpred2 script
        t = paste0(wd,"/script/prs/tmp/ldpred2.", script_num, ".R")
        write("rm(list=ls())", file = t)
        cat("library(plyr)", file = t, sep ="", append = T)
        cat("\nlibrary(bigsnpr)", file = t, sep ="", append = T)
        cat("\nlibrary(bigreadr)", file = t, sep ="", append = T)
        cat("\nlibrary(optparse)", file = t, sep ="", append = T)
        cat("\nlibrary(tidyverse)", file = t, sep ="", append = T)
        
        cat("\nbim_file <- fread2(\"",ldref,".bim\")", file = t, sep ="", append = T)
        cat("\nfam_file <- fread2(\"",ldref,".fam\")", file = t, sep ="", append = T)
        cat("\nval_bed <- snp_attach(\"",ldref,".rds\")", file = t, sep ="", append = T)

        cat("\nG <- snp_fastImputeSimple(val_bed$genotypes)", file = t, sep ="", append = T)
        cat("\nCHR <- val_bed$map$chromosome", file = t, sep ="", append = T)
        cat("\nPOS <- val_bed$map$physical.pos", file = t, sep ="", append = T)
        cat("\nmap <- val_bed$map[-(3)]", file = t, sep ="", append = T)
        cat("\nnames(map) <- c(\"chr\", \"rsid\", \"pos\", \"a1\", \"a0\")", file = t, sep ="", append = T)
        
        cat("\nsummstats <- fread2(\"",gwas_formatted_out,"\")", file = t, sep ="", append = T)
        cat("\nn_snp <- dim(summstats)[1]", file = t, sep ="", append = T)
        cat("\nsnp.ratio <- nrow(summstats)/", m, file = t, sep ="", append = T)
        cat("\nsummstats$sgenosd <- 2*summstats$MAF*(1-summstats$MAF)", file = t, sep ="", append = T)
        cat("\nsummstats$MAF <- NULL", file = t, sep ="", append = T)
        cat("\ninfo_snp <- snp_match(summstats, map, match.min.prop = 0.05, join_by_pos=F)", file = t, sep ="", append = T)
        cat("\nmaf <- snp_MAF(G, ind.col = info_snp$`_NUM_ID_`)", file = t, sep ="", append = T)
        cat("\nsd_val <- sqrt(2 * maf * (1 - maf))", file = t, sep ="", append = T)
        cat("\nsd_gwas <- with(info_snp, sqrt(sgenosd))", file = t, sep ="", append = T)
        cat("\nis_bad <- abs(sd_gwas-sd_val) >= 0.05 | sd_gwas < 0.01 | sd_val < 0.01", file = t, sep ="", append = T)
        cat("\ndf_beta <- info_snp[!is_bad, c(\"beta\", \"beta_se\", \"n_eff\")]", file = t, sep ="", append = T)
        cat("\ninfo_snp <- info_snp[!is_bad,]", file = t, sep ="", append = T)
        cat("\ninfo_chr <- info_snp$`_NUM_ID_`", file = t, sep ="", append = T)
        cat("\ncorr <- snp_cor(G, ind.col = info_chr, size = 500)", file = t, sep ="", append = T)
        cat("\nh2_est <- ",h2,"*snp.ratio", file = t, sep ="", append = T)
        cat("\nif(h2_est < 1e-4){", file = t, sep ="", append = T)
        cat("\n\tbeta_LDpred2 <- data.frame(info_snp$rsid,info_snp$a1,beta_inf=rep(0,length(info_snp$rsid)),beta_auto=rep(0,length(info_snp$rsid)),beta_grid=matrix(rep(0,30*length(info_snp$rsid)),ncol=30))", file = t, sep ="", append = T)
        cat("\n} else {", file = t, sep ="", append = T)
        
        cat("\n\tcorr_sp <- bigsparser::as_SFBM(as(corr, \"dgCMatrix\"))", file = t, sep ="", append = T)
        #cat("\n\tbeta_inf <- snp_ldpred2_inf(corr_sp, df_beta, h2 = h2_est)", file = t, sep ="", append = T)
        cat("\n\tauto <- snp_ldpred2_auto(corr_sp, df_beta, h2_init = h2_est, allow_jump_sign = FALSE, shrink_corr = 0.5)", file = t, sep ="", append = T)
        cat("\n\tbeta_auto <- auto[[1]]$beta_est", file = t, sep ="", append = T)
        cat("\n\tbeta_auto <- ifelse(is.na(beta_auto), 0, beta_auto)", file = t, sep ="", append = T)
        cat("\n\tp_seq <- signif(c(1e-3, 1e-2, 0.1), 2)", file = t, sep ="", append = T)
        cat("\n\th_seq <- round(c(0.1,0.3)*h2_est,4)", file = t, sep ="", append = T)
        cat("\n\tparams <- expand.grid(p = p_seq, h2 = h_seq, sparse = c(TRUE,FALSE))", file = t, sep ="", append = T)
        cat("\n\tbeta_grid <- snp_ldpred2_grid(corr_sp, df_beta, params)", file = t, sep ="", append = T)
        cat("\n\tbeta_grid <- apply(beta_grid,2,function(s){return(ifelse(is.na(s), 0, s))})", file = t, sep ="", append = T)
        cat("\n\tbeta_grid <- apply(beta_grid,2,function(s){return(ifelse(abs(s)>=1, 0, s))})", file = t, sep ="", append = T)
        cat("\n\tbeta_LDpred2 <- data.frame(info_snp$rsid,info_snp$a1,beta_auto,beta_grid)", file = t, sep ="", append = T)
        cat("\n}", file = t, sep ="", append = T)
        
        cat("\nfwrite2(beta_LDpred2, \"",chr_out_path,".txt\", col.names = F, row.names = F, quote = F,sep=\" \",na=NA)", file = t, sep ="", append = T)
        
        # condor script
        script <- paste0("Rscript ",wd,"/script/prs/tmp/ldpred2.", script_num, ".R")
        write.table(paste0("#!/bin/bash\n",script),paste0(wd,"/script/prs/",script_num,".sh"),col.names=F,row.names=F,sep="\n",quote=F)
        script_num <- script_num + 1
    }
}

