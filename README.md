# PRSdemo

### Set up
* Clone this repo into a folder on your local computer
```
git clone https://github.com/svdorn/PRSdemo.git
```
* Change directory into PRSdemo folder
```
cd PRSdemo
```

* `PRSdemo` is developed using R. The statistical computing software R (>=4.3) is required.
  * The following packages are necessary for running `PRSdemo`, but they will be automatically downloaded for you when you run the demo [tidyverse](https://cran.r-project.org/web/packages/tidyverse/index.html), [data.table](https://cran.r-project.org/web/packages/data.table/index.html), [R.utils](https://cran.r-project.org/web/packages/R.utils/index.html), [plyr](https://cran.r-project.org/web/packages/plyr/index.html), [bigsnpr](https://cran.r-project.org/web/packages/bigsnpr/index.html), [bigreadr](https://cran.r-project.org/web/packages/bigreadr/index.html), [optparse](https://cran.r-project.org/web/packages/optparse/index.html), [foreach](https://cran.r-project.org/web/packages/foreach/index.html), [rngtools](https://cran.r-project.org/web/packages/rngtools/index.html)

* Make output folder for PRS weights
```
mkdir weights
```

* Download LD and GWAS data and put it in the input folder

If you don't already have `wget` downloaded on your computer, follow the following tutorials to download it on your machine.
  * [Download and Install wget on Mac](https://www.jcchouinard.com/wget/#Download_and_Install_Wget_on_Mac)
  * [Download and Install wget on Linux](https://www.jcchouinard.com/wget/#Download_and_Install_Wget_on_Linux)
  * [Download and Install wget on Windows](https://www.jcchouinard.com/wget/#Download_and_Install_Wget_on_Windows)

Download the LD and GWAS data using `wget`
```
wget -nd -r -P ./input ftp://ftp.biostat.wisc.edu/pub/lu_group/Projects/PRS_demo/input
```

* Download PLINK
  * [Follow instuctions here](https://www.cog-genomics.org/plink/)

### Run
* To run the script to get PRS scores, run
```
bash calculate_prs.sh
```
* Output will be written to `prs_scores.txt` and the first few rows of data will look like:
![image](https://github.com/svdorn/PRSdemo/assets/22485021/9e4f0f45-4fbd-4686-b6df-36acb157000a)

