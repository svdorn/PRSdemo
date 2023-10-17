#!/bin/bash

set -o errexit

script_path="./scripts"
work_dir="./weights"
heritability=0.3
RL=1

# download and import necessary R packages
Rscript --vanilla ${script_path}/download_R_packages.R

## genrate PRS scripts
Rscript --vanilla ${script_path}/LDpred2.R $work_dir $heritability

## sort PRS model weights
Rscript --vanilla ${script_path}/sort_SNP_weights.R $work_dir

## PRS score calculation for LD pred2
for n in {3..13};
do
    echo
    echo "Calculating PRS scores for LDpred2 model ${n}"
    echo
    ./plink/plink --bfile ./input/1kg_hm3_QCed_noM --score ${work_dir}/ldpred2.txt 1 2 ${n} header sum center --out ${work_dir}/ldpred2.${n}
done
## PRS score caclulation for default PRS
for n in {3..7};
do
    echo
    echo "Calculating PRS scores for default model ${n}"
    echo
    ./plink/plink --bfile ./input/1kg_hm3_QCed_noM --score ${work_dir}/default.txt 1 2 ${n} header sum center --out ${work_dir}/default.${n}
done

## combine PRS calculations into a final table
Rscript --vanilla ${script_path}/sort_PRS_calcs.R $work_dir $RL