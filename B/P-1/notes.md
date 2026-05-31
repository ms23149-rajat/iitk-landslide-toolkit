# Installation Notes — TRIGRS v2.1
**Intern:** Rajat (Group B, SURGE/SARIP 2026)
**Machine:** labws2, Ubuntu 24.04 LTS
**Date:** May 2026

## What Went Right
- gfortran, f95, and mpif90 were already installed on the lab machine
- git clone from USGS GitLab worked first time
- All 38 Fortran source files compiled without errors
- TopoIndex and both TRIGRS programs (trg, prg) compiled successfully
- Tutorial test case ran and produced correct FS output

## Gotchas — Read This Before You Start!

### 1. Double-nested folder from git clone
If you are already inside a landslides-trigrs folder when you run
git clone, it creates landslides-trigrs/landslides-trigrs/.
Fix: always run git clone from your home folder (~).

### 2. GSL library symbolic links needed
libgsl-dev was not installed and sudo access was not available.
The .so files existed but without the correct names.
Fix: create symbolic links in ~/lib/
  ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.27 ~/lib/libgsl.so
  ln -s /usr/lib/x86_64-linux-gnu/libgslcblas.so.0 ~/lib/libgslcblas.so
Then compile with: make LDFLAGS="-w -O3 -L$HOME/lib"

### 3. Capital D in tr_in.txt paths
The file uses Data/tutorial/ but Linux requires data/tutorial/
Fix: sed -i 's|Data/|data/|g' tr_in.txt

### 4. TopoIndex source files not in TRIGRS folder
The Makefile expects TopoIndex files in src/TRIGRS/
Fix: cp ../TopoIndex/* . (run from inside src/TRIGRS/)

### 5. tpx_in.txt missing tutorial/ in paths
Fix: sed -i 's|data/dem.asc|data/tutorial/dem.asc|g' tpx_in.txt
     sed -i 's|data/directions.asc|data/tutorial/directions.asc|g' tpx_in.txt

## AI Tools Used
- Claude (Anthropic) used as step-by-step mentor throughout installation
- Helped diagnose GSL linking error and devise symbolic link workaround
- Explained Makefile structure and compilation process

## Suggestions for Next Year's Interns
- Ask the lab admin to install libgsl-dev before you start — saves one hour
- Read tr_in.txt carefully before running — check all file paths exist
- The tutorial test case in data/tutorial/ is well designed — run it first
- Do not skip TopoIndex — TRIGRS will fail without its routing files

## Parallel Version (prg) Test Results
**Machine:** labws2 (32 processors available)
**Date:** May 2026

### Timing Comparison (tutorial 10x10 grid, 100 cells)
| Version | Processors | Time   |
|---------|------------|--------|
| trg (serial)   | 1  | 0.005s |
| prg (parallel) | 4  | 0.656s |

### Key Findings
- Parallel version runs correctly on 4 processors ✅
- Results identical to serial version (verified with diff) ✅
- Parallel is SLOWER on small test case — expected behaviour
- Alvioli 2016 shows speedup only appears on large grids (>1M cells)
- MPI overhead dominates for small problems

### Command to run parallel version
mpirun -np 4 src/TRIGRS/prg tr_in.txt

## Real Terrain Run — Kerala Western Ghats
**Date:** May 2026
**Study area:** Idukki District, Kerala (76.8-77.0°E, 9.8-10.0°N)
**DEM:** Copernicus GLO-30 (DS-13), 30m resolution
**Grid size:** 735 x 742 = 537,672 valid cells

### Rainfall Input (Kerala 2018 style)
- Period 1 (0-48hrs): 3mm/hr light rainfall
- Period 2 (48-60hrs): 15mm/hr heavy rainfall

### Results at 60 hours
- Unstable cells (FS<1.0):      89,558 (16.7%)
- Marginally stable (1.0-1.2):  61,920 (11.5%)
- Stable cells (FS>=1.2):      386,194 (71.8%)
- Minimum FS: 0.248
- Mean FS: 2.321

### Key Finding
16.7% of the study area shows FS<1.0 after heavy
rainfall — consistent with widespread 2018 Kerala
landsliding observations.

## Kerala Real Terrain Run Difficulties

### 1. Flow Direction Convergence Never Completed
TopoIndex stopped at "Correcting cell index numbers" silently.
Root cause: circular flow paths in direction grid.
Attempts: Python D8, GRASS export, ESRI vs TopoIndex numbering.
Final solution: Used GRASS r.fill.dir directions but ran
TRIGRS without runoff routing (missing TI files = auto skip).
TRIGRS runs successfully without routing. ✅

### 2. All Input Grids Must Match DEM Nodata Exactly
Every .asc file must have IDENTICAL nodata cells as DEM.
Even one extra nodata cell causes Grid mismatch error.
Fix: Python script forcing all grids to use DEM nodata mask.

### 3. TIgrid_size.txt nwf Value Wrong
TopoIndex writes nwf=1 when routing fails.
TRIGRS needs nwf >= imax to allocate arrays.
Fix: Manually set nwf = imax = 537672 in TIgrid_size.txt

### 4. tr_in.txt Line 57 Format Error
Flag value needs TWO values on same line.
Wrong:   0
Correct: 0,1
Fix: sed -i 's/^0$/0,1/' tr_in.txt

### 5. kerala_run.sh Not Fully Automated
Several manual Python scripts needed during processing.
Full automation is a TODO for next intern.
Follow notes.md step by step instead.

## Time Taken
Tutorial install and test: ~3 hours
Kerala real terrain run:   ~6 hours (flow direction debugging)
Total P-1 time:            ~9 hours
