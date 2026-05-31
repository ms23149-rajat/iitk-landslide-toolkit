# Key Papers and Datasets for TRIGRS v2.1

## Papers

### Paper 1 - The Main Manual
Citation: Baum, R.L., Savage, W.Z., and Godt, J.W. (2008)
TRIGRS - A Fortran program for transient rainfall infiltration
and grid-based regional slope-stability analysis, version 2.0.
U.S. Geological Survey Open-File Report 2008-1159, 75 p.
Download: https://pubs.usgs.gov/publication/ofr20081159
Contains: Full theory, user manual, tutorial, all file formats

### Paper 2 - The Parallel Version
Citation: Alvioli, M. and Baum, R.L. (2016)
Parallelization of the TRIGRS model for rainfall-induced
landslides using the message passing interface.
Environmental Modelling & Software 81, 122-135.
Download: https://doi.org/10.1016/j.envsoft.2016.04.002
Contains: MPI parallelization, performance benchmarks

## Datasets Used

### DS-13 - Copernicus GLO-30 DEM
Description: Global 30m Digital Surface Model (TanDEM-X)
Used for: Kerala terrain run (Idukki District)
Tiles downloaded: N09_E076, N09_E077, N10_E076, N10_E077
Download AWS: s3://copernicus-dem-30m/
Tile URL format:
  https://copernicus-dem-30m.s3.amazonaws.com/
  Copernicus_DSM_COG_10_N{LAT}_00_E{LON}_00_DEM/
  Copernicus_DSM_COG_10_N{LAT}_00_E{LON}_00_DEM.tif
OpenTopography DOI: https://doi.org/10.5069/G9028PQB
License: Free for any use

### DS-1 - Hao 2020 Kerala 2018 Landslide Inventory
Description: 4728 field-validated landslide polygons
Event: August 2018 Kerala floods
Paper: Hao et al. (2020) ESSD 12, 2899
DOI: https://doi.org/10.17026/dans-x6c-y7x2
Note: DANS repository blocked on lab proxy
Alternative: Contact Group A who owns DS-1 acquisition
Status: NEEDED for validation of Kerala TRIGRS results

## Note for Future Interns
Save PDFs of both papers in this folder as:
  Baum_2008_TRIGRS_OFR2008-1159.pdf
  Alvioli_Baum_2016_EnvModSoftware.pdf
