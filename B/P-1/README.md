# P-1 — TRIGRS v2.1

**Status:** RUNS ✅  
**Intern:** Rajat (Group B, SURGE/SARIP 2026)  
**Date:** May 2026

## What it does
TRIGRS (Transient Rainfall Infiltration and Grid-Based Regional Slope-Stability) simulates how rainfall infiltrates a hillside over time and calculates the Factor of Safety at every grid cell. FS < 1.0 means the slope is unstable.

## Key Papers
- Baum, Savage, Godt (2008) USGS OFR 2008-1159
- Alvioli & Baum (2016) Environmental Modelling & Software 81, 122-135

## Code Location
- USGS GitLab: https://code.usgs.gov/usgs/landslides-trigrs
- Local copy: ~/landslides-trigrs

## Programs Compiled
- `trg` — serial TRIGRS (single processor)
- `prg` — parallel TRIGRS (MPI, multiple processors)
- `tpx` — TopoIndex (terrain preparation helper)

## System Requirements
- Ubuntu 24.04 LTS
- gfortran / f95 compiler
- mpif90 (OpenMPI)
- libgsl27 + libgslcblas0

## Workflow
1. Run TopoIndex: `src/TRIGRS/tpx tpx_in.txt`
2. Run TRIGRS: `src/TRIGRS/trg tr_in.txt`

## Test Case
Tutorial dataset (10x10 grid, 2-stage storm, 60 hours)
Located in: ~/landslides-trigrs/data/tutorial/
Result: FS < 1.0 appears in steep middle cells after heavy rainfall ✅
