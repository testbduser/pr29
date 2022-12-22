from sklearn.cluster import KMeans
import numpy as np
data = np.genfromtxt('synth_data.csv', delimiter=',')
xy = data[:, [0,1]]
z = data[:, 2].astype('uint32')
km = KMeans(n_clusters=2)
km.fit(xy, z)
print(km.cluster_centers_)
