import matplotlib.pyplot as plt
import numpy as np

data = np.genfromtxt('synth_data.csv' , delimiter=',')
x = data[:, 0]
y = data[:, 1]
z = data[:, 2].astype('uint32')
pal = [(1, 0, 0.5), (0, 0.5, 1)]
clr = []
for i in range(0, len(z)):
   clr.append(pal[z[i]])
plt.scatter(x, y, c=clr)
plt.show()
