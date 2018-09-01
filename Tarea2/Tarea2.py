import numpy as np
import pandas as pd
from pylab import plot,show

df = pd.read_csv('distanciaCombustible.csv')

dist = np.array(df['distance'])
comb = np.array(df['litros'])
rend = comb/dist
A = np.array([ dist, np.ones(len(dist))])
y = comb
w = np.linalg.lstsq(A.T,y, rcond=None)[0]
line = (w[0]*dist+w[1])

print("¿Cuánto combustible se necesitará para recorrer 100, 200 y 500 Km?")
print(w[0]*100+w[1])
print(w[0]*200+w[1])
print(w[0]*500+w[1])

print("¿Con 200 litros de combustible aproximadamente cuántos Kilómetros podrá recorrer un vehículo?")
print((200-w[1])/w[0])

print("Coeficiente de correlación:")
print(np.corrcoef(dist.tolist(), comb.tolist())[1,0])

plot(dist,y,'o',dist,line,'r-', markersize=.5)
show()
