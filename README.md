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

* `PRS_demo` is developed using R. The statistical computing software R (3.5) and the following packages are required:
  * [tidyverse](https://cran.r-project.org/web/packages/tidyverse/index.html)
  * [data.table](https://cran.r-project.org/web/packages/data.table/index.html)
  * [R.utils](https://cran.r-project.org/web/packages/R.utils/index.html)
  * [plyr](https://cran.r-project.org/web/packages/plyr/index.html)
  * [bigsnpr](https://cran.r-project.org/web/packages/bigsnpr/index.html)
  * [bigreadr](https://cran.r-project.org/web/packages/bigreadr/index.html)
  * [optparse](https://cran.r-project.org/web/packages/optparse/index.html)
  * [parallel](https://www.rdocumentation.org/packages/parallel/versions/3.6.2)
  * [foreach](https://cran.r-project.org/web/packages/foreach/index.html)
  * [rngtools](https://cran.r-project.org/web/packages/rngtools/index.html)

* Make output folder for PRS weights
```
mkdir weights
```

* Download LD and GWAS data
```
wget ftp://ftp.biostat.wisc.edu/pub/lu_group/Projects/PRS_demo/input
```

* Download PLINK
  * [Follow instuctions here](https://www.cog-genomics.org/plink/)

### Run
* To run the script to get PRS scores, run
```
bash calculate_prs.sh
```
* Output will be written to `prs_scores.txt` and look like:
FID	IID	ldpred2.1	ldpred2.2	ldpred2.3	ldpred2.4	ldpred2.5	ldpred2.6	ldpred2.7	ldpred2.8	ldpred2.9	ldpred2.10	ldpred2.11	default.1	default.2	default.3	default.4	default.5
HG00096	HG00096	-2.709912906	-2.367355776	-2.204724184	-2.212556324	-2.468014721	-2.568552717	-2.408022168	-2.301862655	-2.178286068	-2.179196476	-2.410473579	-1.891271903	-2.003325213	-2.121306523	-2.448309424	-2.365903774
HG00097	HG00097	-0.202214435	0.127935094	-0.017310255	-0.509704838	0.14871823	-0.172781656	-0.545119528	0.116065641	-0.072899305	-0.64310577	0.009480999	-0.9335967	-1.22874728	-1.096819952	-1.21292302	-1.222593815
HG00099	HG00099	1.239131822	0.907123618	1.473268357	1.577682725	0.890438713	1.355253198	1.672755373	1.021328061	1.4274955	1.475365085	0.867623375	1.016747501	1.215648071	1.164261179	1.238319676	1.22782765
HG00101	HG00101	0.564273895	0.113741275	0.37351323	1.461305466	0.101573823	0.576187324	1.222949459	0.159140862	0.533272559	1.77859753	0.111396084	0.893027121	1.171808315	1.357727971	2.276533248	2.318640298
HG00102	HG00102	-0.554622487	-0.483446556	-0.98319366	-0.907363403	-0.551957729	-0.628749486	-0.836319154	-0.481738687	-1.008373167	-1.083592472	-0.341703666	-0.504729749	-0.53259322	-0.560753354	-0.929405362	-0.960385747![image](https://github.com/svdorn/PRSdemo/assets/22485021/9e4f0f45-4fbd-4686-b6df-36acb157000a)

