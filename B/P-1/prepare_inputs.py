import numpy as np
import os
DEMDIR = os.path.expanduser("~/data/DS-13-GLO30-Kerala")
RUNDIR = os.path.expanduser("~/kerala_trigrs_run")
os.system("gdal_translate -q -of AAIGrid -a_nodata -9999 "+DEMDIR+"/Kerala_DEM_nodata.tif "+DEMDIR+"/Kerala_dem_raw.asc")
os.system("gdal_translate -q -of AAIGrid "+DEMDIR+"/Kerala_slope.tif "+DEMDIR+"/Kerala_slope_raw.asc")
os.system("gdal_translate -q -of AAIGrid "+RUNDIR+"/Kerala_directions_grass.tif "+RUNDIR+"/Kerala_directions_raw.asc")
h1,dem=[],[]
f=open(DEMDIR+"/Kerala_dem_raw.asc")
for i in range(6):h1.append(f.readline())
for l in f:dem.append([float(v) for v in l.split()])
f.close()
dem=np.array(dem)
mask=dem==-9999
print("Valid DEM cells: "+str(int(np.sum(~mask))))
h2,dirs=[],[]
f=open(RUNDIR+"/Kerala_directions_raw.asc")
for i in range(6):
    line=f.readline()
    h2.append("NODATA_value -9999\n" if "NODATA" in line else line)
for l in f:dirs.append([int(float(v)) for v in l.split()])
f.close()
dirs=np.array(dirs)
g2t={45:1,90:2,135:3,180:4,225:5,270:6,315:7,360:8,0:8,65535:-9999}
dirs=np.vectorize(lambda v:g2t.get(v,-9999))(dirs)
combined=mask|(dirs==-9999)
dem[combined]=-9999
dirs[combined]=-9999
h3,slope=[],[]
f=open(DEMDIR+"/Kerala_slope_raw.asc")
for i in range(6):h3.append(f.readline())
for l in f:slope.append([float(v) for v in l.split()])
f.close()
slope=np.array(slope)
slope[combined]=-9999
nrows,ncols=dem.shape
valid=int(np.sum(~combined))
print("Valid cells: "+str(valid))
def write_asc(fname,data,header):
    f=open(fname,"w")
    for l in header:f.write(l)
    for row in data:f.write(" ".join([str(v) for v in row])+"\n")
    f.close()
write_asc(RUNDIR+"/dem_final.asc",dem,h1)
write_asc(RUNDIR+"/dir_final.asc",dirs,h2)
write_asc(RUNDIR+"/slope_matched.asc",slope,h3)
grids={"depthwt_matched.asc":2.4,"zmax_matched.asc":3.0,"rizero_matched.asc":-1e-9,"zones_matched.asc":1.0,"ri1_matched.asc":8.33e-7,"ri2_matched.asc":4.17e-6}
for fname,val in grids.items():
    arr=np.full((nrows,ncols),val)
    arr[combined]=-9999
    write_asc(RUNDIR+"/"+fname,arr,h1)
open(RUNDIR+"/valid_cells.txt","w").write(str(valid))
f=open(RUNDIR+"/TIgrid_size.txt","w")
f.write(" imax      nrow      ncol      nwf\n")
f.write("      "+str(valid)+"         742         735      "+str(valid)+"\n")
f.close()
content=open(RUNDIR+"/tr_in.txt").read()
content=content.replace("\n0\n","\n0,1\n",1)
open(RUNDIR+"/tr_in.txt","w").write(content)
print("prepare_inputs.py complete!")
