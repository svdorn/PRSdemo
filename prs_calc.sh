#!/bin/bash
script_path="./scripts"
work_dir="./rep"
heritability=0.3
RL=1


## genrate PRS scripts
#nohup Rscript --vanilla ${script_path}/generate_PRS_scripts.R $work_dir $heritability $RL

## run PRS scripts to calculate PRS model weights
#for n in {1..22};
#do
#    /bin/bash ./rep/script/prs/${n}.sh
#done
/bin/bash ./rep/script/prs/22.sh

## sort PRS model weights
nohup Rscript --vanilla ${script_path}/sort_SNP_weights.R $work_dir $RL &


## PRS calculation for LD pred
#for n in {3..13};
#do
#    ./Software/plink/plink --bfile ./LD/UKB_hm3_small_ref --score ./rep/PRSweights/sorted_prs/ite1.ldpred2.txt 1 2 ${n} header sum center --out ./rep/PRSweights/final_weights/ldpred2.${n}
#done
## PRS caclulation for default PRS
for n in {3..7};
do
    ./Software/plink/plink --bfile ./LD/UKB_hm3_small_ref --score ./rep/PRSweights/sorted_prs/ite1.default.txt 1 2 ${n} header sum center --out ./rep/PRSweights/final_weights/default.${n-2}
done

## combine PRS calculations into a final table
Rscript --vanilla ${script_path}/sort_PRS_calcs.R $work_dir $RL &