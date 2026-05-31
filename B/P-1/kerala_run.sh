#!/bin/bash
# Kerala Western Ghats TRIGRS Run
# Group B, P-1 — SURGE/SARIP 2026
# Usage: bash kerala_run.sh

echo "=== Kerala TRIGRS Run ==="

# Step 1: Download DS-13 GLO-30 DEM tiles
echo "Downloading Copernicus GLO-30 DEM tiles..."
mkdir -p ~/data/DS-13-GLO30-Kerala
cd ~/data/DS-13-GLO30-Kerala

wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N09_00_E076_00_DEM/Copernicus_DSM_COG_10_N09_00_E076_00_DEM.tif
wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N09_00_E077_00_DEM/Copernicus_DSM_COG_10_N09_00_E077_00_DEM.tif
wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N10_00_E076_00_DEM/Copernicus_DSM_COG_10_N10_00_E076_00_DEM.tif
wget -nc https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N10_00_E077_00_DEM/Copernicus_DSM_COG_10_N10_00_E077_00_DEM.tif

# Step 2: Merge tiles
echo "Merging DEM tiles..."
gdal_merge.py -o Kerala_DEM_merged.tif -of GTiff \
  Copernicus_DSM_COG_10_N09_00_E076_00_DEM.tif \
  Copernicus_DSM_COG_10_N09_00_E077_00_DEM.tif \
  Copernicus_DSM_COG_10_N10_00_E076_00_DEM.tif \
  Copernicus_DSM_COG_10_N10_00_E077_00_DEM.tif

# Step 3: Crop to Idukki study area
echo "Cropping to Idukki study area..."
gdal_translate -projwin 76.8 10.0 77.0 9.8 -of GTiff \
  Kerala_DEM_merged.tif Kerala_DEM_Idukki.tif

# Step 4: Reproject to UTM Zone 43N
echo "Reprojecting to UTM Zone 43N..."
gdalwarp -t_srs EPSG:32643 -r bilinear -tr 30 30 \
  Kerala_DEM_Idukki.tif Kerala_DEM_Idukki_UTM.tif

# Step 5: Handle nodata
echo "Processing nodata values..."
gdalwarp -srcnodata 0 -dstnodata -9999 -of GTiff \
  Kerala_DEM_Idukki_UTM.tif Kerala_DEM_nodata.tif

# Step 6: Generate slope
echo "Generating slope grid..."
gdaldem slope Kerala_DEM_nodata.tif Kerala_slope.tif

# Step 7: Generate flow directions in GRASS
echo "Generating flow directions in GRASS..."
grass -c Kerala_DEM_nodata.tif ~/grassdata/kerala_run << 'GRASSEOF'
r.in.gdal input=Kerala_DEM_nodata.tif output=kerala_dem
g.region raster=kerala_dem
r.fill.dir input=kerala_dem output=kerala_dem_filled direction=kerala_flowdir
r.out.gdal input=kerala_flowdir output=Kerala_directions_grass.tif format=GTiff type=UInt16 nodata=65535
exit
GRASSEOF

# Step 8: Convert to ASC format
echo "Converting to ASC format..."
gdal_translate -of AAIGrid -a_nodata -9999 Kerala_DEM_nodata.tif Kerala_dem_raw.asc
gdal_translate -of AAIGrid Kerala_slope.tif Kerala_slope_raw.asc
gdal_translate -of AAIGrid Kerala_directions_grass.tif Kerala_directions_raw.asc

# Step 9: Run Python processing scripts
echo "Processing input grids with Python..."
cd ~/kerala_trigrs_run
python3 ~/landslides-trigrs/scripts/prepare_kerala_inputs.py

# Step 10: Run TRIGRS
echo "Running TopoIndex..."
~/landslides-trigrs/src/TRIGRS/tpx tpx_in.txt

echo "Running TRIGRS..."
~/landslides-trigrs/src/TRIGRS/trg tr_in.txt

echo "=== Kerala Run Complete! ==="
echo "Results in: ~/kerala_trigrs_run/output/"
