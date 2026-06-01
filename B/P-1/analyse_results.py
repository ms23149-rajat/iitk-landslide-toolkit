import numpy as np
import os
RUNDIR = os.path.expanduser("~/kerala_trigrs_run")
for t,fname in [(48,"TRfs_min_kerala_1.asc"),(60,"TRfs_min_kerala_2.asc")]:
    data=[]
    f=open(RUNDIR+"/output/"+fname)
    for i in range(6):f.readline()
    for l in f:data.extend([float(v) for v in l.split()])
    f.close()
    arr=np.array(data)
    valid=arr[arr!=-9999]
    print("=== Results at "+str(t)+" hours ===")
    print("Unstable (FS<1.0): "+str(np.sum(valid<1.0))+" ("+str(round(100*np.sum(valid<1.0)/len(valid),1))+"%)")
    print("Marginal (1.0-1.2): "+str(np.sum((valid>=1.0)&(valid<1.2)))+" ("+str(round(100*np.sum((valid>=1.0)&(valid<1.2))/len(valid),1))+"%)")
    print("Stable (FS>=1.2): "+str(np.sum(valid>=1.2))+" ("+str(round(100*np.sum(valid>=1.2)/len(valid),1))+"%)")
    print("Mean FS: "+str(round(float(np.mean(valid[valid<10])),3)))
print("Analysis complete!")
