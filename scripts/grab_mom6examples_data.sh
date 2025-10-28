#!/bin/bash -l


#qsub -P tm70 -q copyq -l walltime=06:00:00,ncpus=1,mem=8GB,jobfs=100GB,storage=gdata/tm70+scratch/tm70 /g/data/tm70/cyb561/mom6exampledata/grab_mom6examples_data.sh


#CBull 
#27/10/2025
set -x
GME="wget -c ftp://ftp.gfdl.noaa.gov/perm/Alistair.Adcroft/MOM6-testing/"

cd /g/data/tm70/cyb561/mom6exampledata

${GME}AM2_LM3_MOM6i_1deg.tgz
${GME}Baltic_OM4_025.tgz
${GME}Baltic_OM4_05.tgz
${GME}CM2G63L.tgz
${GME}CORE.tgz
${GME}global.tgz
${GME}GOLD_SIS_025.tgz
${GME}GOLD_SIS.tgz
${GME}MESO_025_23L.tgz
${GME}MESO_025_63L.tgz
${GME}MOM6_SIS_icebergs.tgz
${GME}obs.tgz
${GME}obs.woa13.tgz
${GME}OM_1deg.tgz
${GME}OM4_025.tgz
${GME}OM4_025.tgz.old
${GME}OM4_05.tgz
${GME}OM4_360x320_C180.tgz
${GME}reanalysis-sample.tgz
${GME}reanalysis.tgz
${GME}src_AM2_LM3_SIS1.tgz

${GME}OM4_05/ocean_hgrid.nc
${GME}OM4_05/ocean_mask.nc
${GME}OM4_05/ocean_static.nc
${GME}OM4_05/ocean_topog.nc
 
${GME}hashed-files/46803f1e1595e29ea527086438a58391.gz
${GME}hashed-files/d266258d8d1ea2c2da906a7a44036e8a.gz
${GME}hashed-files/d60a48ad1a201fd726186472507605d2.gz

${GME}OM4_025/basin_codes.v20140629.nc
${GME}OM4_025/ocean_hgrid.nc
${GME}OM4_025/ocean_mask.nc
${GME}OM4_025/ocean_static.nc
${GME}OM4_025/ocean_topog.nc
${GME}OM4_025/WOA05_ptemp_salt_annual.v20141007.nc

echo "job finished: `date`"

#the above was based on...
#narky@narky-virtualbox:~$ ftp ftp://ftp.gfdl.noaa.gov/perm/Alistair.Adcroft/MOM6-testing/
#Trying 140.208.31.25:21 ...
#Connected to lapftp01-p.gfdl.noaa.gov.
#ls220 140.208.31.25 FTP server ready
#
#331 Anonymous login ok, send your complete email address as your password
#230 Anonymous access granted, restrictions apply
#Remote system type is UNIX.
#Using binary mode to transfer files.
#200 Type set to I
#250 CWD command successful
#250 CWD command successful
#250 CWD command successful
#ftp> ls
#229 Entering Extended Passive Mode (|||10056|)
#150 Opening ASCII mode data connection for file list
#-rw-r--r--   1 8061     79       3356794780 Dec 18  2018 AM2_LM3_MOM6i_1deg.tgz
#-rw-r--r--   1 8061     79        1064679 Dec 18  2018 Baltic_OM4_025.tgz
#-rw-r--r--   1 8061     79         239346 Dec 18  2018 Baltic_OM4_05.tgz
#-rw-r--r--   1 8061     79       7872017573 Dec 18  2018 CM2G63L.tgz
#-rw-r--r--   1 8061     79       894842510 Dec 18  2018 CORE.tgz
#-rw-r--r--   1 8061     79       740673699 Dec 18  2018 global.tgz
#-rw-r--r--   1 8061     79       129131001 Dec 18  2018 GOLD_SIS_025.tgz
#-rw-r--r--   1 8061     79       1016438131 Dec 18  2018 GOLD_SIS.tgz
#drwxrwxr-x   2 8061     79              5 Aug 28  2021 hashed-files
#-rw-r--r--   1 8061     79       151684209 Dec 18  2018 MESO_025_23L.tgz
#-rw-r--r--   1 8061     79       601352754 Dec 18  2018 MESO_025_63L.tgz
#-rw-r--r--   1 8061     79         100455 Dec 18  2018 MOM6_SIS_icebergs.tgz
#-rw-r--r--   1 8061     79       84135263 Dec 18  2018 obs.tgz
#-rw-r--r--   1 8061     79       1058331974 Dec 18  2018 obs.woa13.tgz
#-rw-r--r--   1 8061     79        9337533 Aug 25  2021 OM_1deg.tgz
#drwxrwxr-x   2 8061     79              8 Aug 21  2020 OM4_025
#-rw-r--r--   1 8061     79       421212984 Sep 17  2019 OM4_025.tgz
#-rw-r--r--   1 8061     79       323578402 Dec 18  2018 OM4_025.tgz.old
#drwxrwxr-x   2 8061     79              6 Dec 18  2018 OM4_05
#-rw-r--r--   1 8061     79       89046853 Dec 18  2018 OM4_05.tgz
#-rw-r--r--   1 8061     79       1056624578 Dec 18  2018 OM4_360x320_C180.tgz
#-rw-r--r--   1 8061     79       173987410 Dec  8  2021 reanalysis-sample.tgz
#-rw-r--r--   1 8061     79       12382889092 Aug 15  2019 reanalysis.tgz
#-rw-r--r--   1 8061     79       27133310 Mar 20  2023 src_AM2_LM3_SIS1.tgz
#226 Transfer complete
#ftp> cd OM4_05
#250 CWD command successful
#ftp> ls
#229 Entering Extended Passive Mode (|||10102|)
#150 Opening ASCII mode data connection for file list
#-rw-r--r--   1 8061     79       79710004 Dec 18  2018 ocean_hgrid.nc
#-rw-r--r--   1 8061     79        3334568 Dec 18  2018 ocean_mask.nc
#-rw-r--r--   1 8061     79       44834900 Dec 18  2018 ocean_static.nc
#-rw-r--r--   1 8061     79        8308084 Dec 18  2018 ocean_topog.nc
#226 Transfer complete
#ftp> 
#ftp> 
#ftp> cd ..
#250 CWD command successful
#ftp> cd hashed-files
#l250 CWD command successful
#ftp> ls
#229 Entering Extended Passive Mode (|||10121|)
#150 Opening ASCII mode data connection for file list
#-r--r--r--   1 8061     79       83743632 Aug 28  2021 46803f1e1595e29ea527086438a58391.gz
#-r--r--r--   1 8061     79       288453162 Aug 28  2021 d266258d8d1ea2c2da906a7a44036e8a.gz
#-r--r--r--   1 8061     79       400473706 Aug 28  2021 d60a48ad1a201fd726186472507605d2.gz
#226 Transfer complete
#ftp> cd ..
#250 CWD command successful
#ftp> cd OM4_025
#l250 CWD command successful
#ftp> ls
#229 Entering Extended Passive Mode (|||10043|)
#150 Opening ASCII mode data connection for file list
#-rw-r--r--   1 8061     79        6241536 Mar 31  2020 basin_codes.v20140629.nc
#-rw-r--r--   1 8061     79       298760500 Dec 18  2018 ocean_hgrid.nc
#-rw-r--r--   1 8061     79       12458392 Dec 18  2018 ocean_mask.nc
#-rw-r--r--   1 8061     79       168026444 Dec 19  2018 ocean_static.nc
#-rw-r--r--   1 8061     79       24885412 Dec 18  2018 ocean_topog.nc
#-r--r--r--   1 8061     79       659427020 Aug 21  2020 WOA05_ptemp_salt_annual.v20141007.nc
#226 Transfer complete

