# P-1 — TRIGRS v2.1

**Status:** RUNS ✅
**Intern:** Rajat (Group B, SURGE/SARIP 2026)
**Date:** May 2026

## What it does
TRIGRS (Transient Rainfall Infiltration and Grid-Based Regional
Slope-Stability) simulates how rainfall infiltrates a hillside
over time and calculates the Factor of Safety (FS) at every grid
cell. FS < 1.0 means the slope is unstable and landslide likely.

## Key Papers
- Baum, Savage, Godt (2008) USGS OFR 2008-1159
- Alvioli & Baum (2016) Environmental Modelling & Software 81, 122-135

## Code Location
- USGS GitLab: https://code.usgs.gov/usgs/landslides-trigrs
- Local copy: ~/landslides-trigrs

## Programs Compiled
- trg — serial TRIGRS (single processor)
- prg — parallel TRIGRS (MPI, multiple processors)
- tpx — TopoIndex (terrain preparation helper)

## System Requirements
- Ubuntu 24.04 LTS
- gfortran / f95 compiler
- mpif90 (OpenMPI)
- libgsl27 + libgslcblas0
- GDAL 3.8+ (for DEM processing)
- GRASS GIS 8.3+ (for flow directions)
- Python 3.12+ with numpy

## Installation
Run the installation script:
  bash install.sh
See notes.md for known gotchas before running!

## Workflow — Two Levels

### Level 1: Tutorial Test Case (verification)
Uses the built-in 10x10 tutorial dataset:
  cd ~/landslides-trigrs
  src/TRIGRS/tpx tpx_in.txt
  src/TRIGRS/trg tr_in.txt
Output: data/tutorial/TRfs_min_tutorial_2.asc

### Level 2: Real Terrain Run (Kerala Western Ghats)
Uses Copernicus GLO-30 DEM (DS-13) for Idukki District.
See kerala_run.sh for full automated workflow.
Output: kerala_trigrs_run/output/TRfs_min_kerala_*.asc

## Test Results

### Tutorial (10x10 grid, 100 cells)
- Storm: 2-stage, 60 hours total
- Result: FS < 1.0 appears in steep middle cells ✅
- Verified: serial == parallel (diff confirmed) ✅

### Kerala Real Terrain (735x742 grid, 537,672 cells)
- Study area: Idukki District (76.8-77.0E, 9.8-10.0N)
- DEM: Copernicus GLO-30, 30m resolution (DS-13)
- Rainfall Period 1 (0-48hrs): 3mm/hr light rainfall
- Rainfall Period 2 (48-60hrs): 15mm/hr heavy rainfall

#### At 48 hours (end of light rainfall)
- Unstable (FS<1.0):     69,038 (12.8%)
- Marginal (1.0-1.2):    58,389 (10.9%)
- Stable (FS>=1.2):     410,245 (76.3%)
- Mean FS: 2.454

#### At 60 hours (end of heavy rainfall)
- Unstable (FS<1.0):     89,558 (16.7%)
- Marginal (1.0-1.2):    61,920 (11.5%)
- Stable (FS>=1.2):     386,194 (71.8%)
- Mean FS: 2.321

#### Key Scientific Finding
Heavy rainfall (48-60hrs) triggered 3.9% MORE unstable slopes
(12.8% to 16.7%). Consistent with 2018 Kerala disaster observations
where landslides accelerated dramatically during peak rainfall.

#### Validation (TODO)
Validation against actual 2018 Kerala landslide locations
requires DS-1 (Hao 2020 inventory). Coordinate with Group A
who owns DS-1 acquisition. Once available, overlay
TRfs_min_kerala_*.asc against inventory polygons and compute ROC.

## Scripts
- install.sh      — compiles TRIGRS from source
- kerala_run.sh   — downloads DEM, prepares inputs, runs TRIGRS

## Output Files (test_case/)
- TRfs_min_tutorial_2.asc — tutorial Factor of Safety at 60hrs
- TRfs_min_kerala_1.asc   — Kerala Factor of Safety at 48hrs
- TRfs_min_kerala_2.asc   — Kerala Factor of Safety at 60hrs
