import sys
import random

# Extension of the targets
# z_limits: D2(2cm long), C, Al, Cu, Sn, Pb. Position in [mm]
z_limits = [[-69.2,-50.5],[-10.74,-9.26],[-10.6,-9.4],[-10.18,-9.82],[-10.15,-9.85],[-10.07,-9.93]]

target = str(sys.argv[1])

def randomize_vertex(target_index):
    #set the limits of the targets based on the target index
    min_z = z_limits[target_index][0]
    max_z = z_limits[target_index][1]
    #generate a random vetex value dependign on the limits of the target
    rdm_vertex = random.uniform(min_z, max_z)
    # print results in cm
    print (rdm_vertex/10.)

# choose the vertex depending of the target
if target=="D2":
    randomize_vertex(0)
elif target=="C":
    randomize_vertex(1)
elif target=="Al":
    randomize_vertex(2)
elif target=="Cu":
    randomize_vertex(3)
elif target=="Sn":
    randomize_vertex(4)
elif target=="Pb":
    randomize_vertex(5)
else:
    print ("Not a valid target to randomize vertex")
