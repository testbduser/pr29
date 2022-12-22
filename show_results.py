import matplotlib.pyplot as plt
import numpy as np
import psycopg2

con = psycopg2.connect('dbname=lab_trig user=user2 password=1234 host=192.168.1.40 port=5432')
cur = con.cursor()
cur.execute('SELECT x, y, z FROM kmeans_test;')
arr = cur.fetchall()
cur.close()
cur.close()
data = np.array([*arr])
x = data[:, 0]
y = data[:, 1]
z = data[:, 2].astype('uint32')
pal = [(1, 0, 0.5), (0, 0.5, 1)]
clr = []
for i in range(0, len(z)):
  clr.append(pal[z[i]])
plt.scatter(x, y, c=clr)
plt.show()
