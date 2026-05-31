# Test Case Output Files

## Tutorial Test Case (10x10 grid)
File: TRfs_min_tutorial_2.asc
- Grid: 10x10 = 100 cells
- Storm Period 1 (0-48hrs): light rainfall 3e-7 m/s
- Storm Period 2 (48-60hrs): heavy rainfall 9e-5 m/s
- Source: Built-in TRIGRS tutorial dataset
- Purpose: Verify TRIGRS compiles and runs correctly

## Kerala Real Terrain (735x742 grid)
Files: TRfs_min_kerala_1.asc, TRfs_min_kerala_2.asc
- Grid: 735x742 = 537,672 cells
- Study area: Idukki District, Kerala
- Coordinates: 76.8-77.0E, 9.8-10.0N (UTM Zone 43N)
- DEM: Copernicus GLO-30, 30m resolution (DS-13)
- Storm Period 1 (0-48hrs): light rainfall 3mm/hr
- Storm Period 2 (48-60hrs): heavy rainfall 15mm/hr

### How to read these files
- Open in QGIS or any GIS software
- Values represent Factor of Safety (FS)
- FS < 1.0  = unstable (landslide likely)
- FS 1.0-1.2 = marginally stable
- FS > 1.2  = stable
- -9999     = no data

### Results Summary
At 48 hours (end of light rainfall):
  Unstable (FS<1.0):  69,038 cells (12.8%)
  Marginal (1.0-1.2): 58,389 cells (10.9%)
  Stable (FS>=1.2):  410,245 cells (76.3%)
  Mean FS: 2.454

At 60 hours (end of heavy rainfall):
  Unstable (FS<1.0):  89,558 cells (16.7%)
  Marginal (1.0-1.2): 61,920 cells (11.5%)
  Stable (FS>=1.2):  386,194 cells (71.8%)
  Mean FS: 2.321

Key finding: Heavy rainfall (48-60hrs) triggered
3.9% more slope failures (12.8% to 16.7%)

### Validation TODO
Compare with Hao 2020 Kerala inventory (DS-1)
Contact Group A for cleaned inventory shapefile
