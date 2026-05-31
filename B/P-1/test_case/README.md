# Test Case Output Files

## Tutorial Test Case (10x10 grid)
File: TRfs_min_tutorial_2.asc
Grid: 10x10 = 100 cells
Storm Period 1 (0-48hrs): 1.08 mm/hr (3e-7 m/s)
Storm Period 2 (48-60hrs): 324 mm/hr (9e-5 m/s)
Source: Built-in TRIGRS tutorial dataset
WARNING: Synthetic storm NOT realistic rainfall!
324 mm/hr is 10x more intense than real Kerala 2018.
For installation verification purposes ONLY.

## Kerala Real Terrain (735x742 grid)
Files: TRfs_min_kerala_1.asc, TRfs_min_kerala_2.asc
Grid: 735x742 = 537,672 cells
Study area: Idukki District, Kerala
Coordinates: 76.8-77.0E, 9.8-10.0N (UTM Zone 43N)
DEM: Copernicus GLO-30, 30m resolution (DS-13)
Storm Period 1 (0-48hrs): 3 mm/hr (8.33e-7 m/s)
Storm Period 2 (48-60hrs): 15 mm/hr (4.17e-6 m/s)
Based on Kerala 2018 rainfall observations

## How to read these files
Open in QGIS or any GIS software
FS < 1.0   = unstable (landslide likely)
FS 1.0-1.2 = marginally stable
FS > 1.2   = stable
-9999      = no data

## Results at 48 hours (end of light rainfall)
Unstable (FS<1.0):  69038 cells (12.8%)
Marginal (1.0-1.2): 58389 cells (10.9%)
Stable (FS>=1.2):  410245 cells (76.3%)
Mean FS: 2.454

## Results at 60 hours (end of heavy rainfall)
Unstable (FS<1.0):  89558 cells (16.7%)
Marginal (1.0-1.2): 61920 cells (11.5%)
Stable (FS>=1.2):  386194 cells (71.8%)
Mean FS: 2.321

Key finding: Heavy rainfall triggered 3.9% more failures
Consistent with 2018 Kerala disaster observations

## Validation TODO
Compare with Hao 2020 Kerala inventory (DS-1)
Contact Group A for cleaned inventory shapefile
Compute ROC curve: TRIGRS predictions vs actual locations
