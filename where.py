import numpy as np

a=np.zeros((30,2),dtype='uint16')

a[3:10,0]=1
a[13:20,0]=1

for i in range(30):
    a[i,1] = i

print(a)

maps = np.where(a[:,0] == 1)
#b=np.zeros((14,1),dtype='uint16')

b = a[maps,1]

print(b)

c = np.zeros((7,2),dtype='uint16')

c[:,0] = b[0,:7]
c[:,1] = b[0,7:]
print(c)
