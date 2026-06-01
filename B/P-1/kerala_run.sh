#!/bin/bash
# Kerala TRIGRS Run - Group B P-1 SURGE/SARIP 2026
# Usage: bash kerala_run.sh
set -e
echo Kerala TRIGRS Run Starting
TRIGRS=~/landslides-trigrs
DEMDIR=~/data/DS-13-GLO30-Kerala
RUNDIR=~/kerala_trigrs_run
GRASSDB=~/grassdata
echo STEP1 Downloading DEM...
mkdir -p $DEMDIR && cd $DEMDIR
wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N09_00_E076_00_DEM/Copernicus_DSM_COG_10_N09_00_E076_00_DEM.tif
wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N09_00_E077_00_DEM/Copernicus_DSM_COG_10_N09_00_E077_00_DEM.tif
wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N10_00_E076_00_DEM/Copernicus_DSM_COG_10_N10_00_E076_00_DEM.tif
wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N10_00_E077_00_DEM/Copernicus_DSM_COG_10_N10_00_E077_00_DEM.tif
echo STEP1 Done
echo STEP2 Processing DEM...
gdal_merge.py -q -o Kerala_DEM_merged.tif -of GTiff Copernicus_DSM_COG_10_N09_00_E076_00_DEM.tif Copernicus_DSM_COG_10_N09_00_E077_00_DEM.tif Copernicus_DSM_COG_10_N10_00_E076_00_DEM.tif Copernicus_DSM_COG_10_N10_00_E077_00_DEM.tif
gdal_translate -q -projwin 76.8 10.0 77.0 9.8 -of GTiff Kerala_DEM_merged.tif Kerala_DEM_Idukki.tif
gdalwarp -q -t_srs EPSG:32643 -r bilinear -tr 30 30 Kerala_DEM_Idukki.tif Kerala_DEM_Idukki_UTM.tif
gdalwarp -q -srcnodata 0 -dstnodata -9999 -of GTiff Kerala_DEM_Idukki_UTM.tif Kerala_DEM_nodata.tif
gdaldem slope -q Kerala_DEM_nodata.tif Kerala_slope.tif
echo STEP2 Done
echo STEP3 GRASS flow directions...
python3 $RUNDIR/prepare_inputs.py
echo STEP3 Done
echo STEP4 Running TRIGRS...
cd $RUNDIR
$TRIGRS/src/TRIGRS/tpx tpx_in.txt
$TRIGRS/src/TRIGRS/trg tr_in.txt
echo STEP4 Done
echo STEP5 Analysing results...
python3 $RUNDIR/analyse_results.py
echo Kerala Run Complete
