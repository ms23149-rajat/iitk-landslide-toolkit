#!/bin/bash
# TRIGRS v2.1 Installation Script
# Group B, P-1 — SURGE/SARIP 2026
# Usage: bash install.sh

echo "=== TRIGRS v2.1 Installation ==="

# Step 1: Go to home folder
cd ~

# Step 2: Clone the repository
echo "Cloning TRIGRS repository..."
git clone https://code.usgs.gov/usgs/landslides-trigrs.git
cd landslides-trigrs

# Step 3: Create GSL symbolic links
echo "Creating GSL symbolic links..."
mkdir -p ~/lib
ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.27 ~/lib/libgsl.so
ln -s /usr/lib/x86_64-linux-gnu/libgslcblas.so.0 ~/lib/libgslcblas.so

# Step 4: Copy TopoIndex files into TRIGRS folder
echo "Copying TopoIndex source files..."
cp src/TopoIndex/* src/TRIGRS/

# Step 5: Compile all programs
echo "Compiling TRIGRS..."
cd src/TRIGRS
make LDFLAGS="-w -O3 -L$HOME/lib"
make tpx LDFLAGS="-w -O3 -L$HOME/lib"
cd ../..

# Step 6: Fix initialization file paths
echo "Fixing initialization file paths..."
sed -i 's|Data/|data/|g' tr_in.txt
sed -i 's|data/dem.asc|data/tutorial/dem.asc|g' tpx_in.txt
sed -i 's|data/directions.asc|data/tutorial/directions.asc|g' tpx_in.txt

echo "=== Installation Complete! ==="
echo "To run the tutorial test case:"
echo "  src/TRIGRS/tpx tpx_in.txt"
echo "  src/TRIGRS/trg tr_in.txt"
