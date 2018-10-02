from sklearn import linear_model
from sklearn import preprocessing
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import scipy.stats as stats
import itertools


dataPeople = pd.read_csv("clientes.csv")
lst = ['Income',  'Is Married',  'Has College',  'Is Professional',
  'Is Retired',  'Own',  'White']
no_lst = ['Obs No.','Buy']
train_features_best = dataPeople[[c for c in lst]]


log_model = linear_model.LogisticRegression(solver='lbfgs')
log_model.fit(X = train_features_best, y = dataPeople["Buy"])
accuracy  = log_model.score(X=train_features_best, y=dataPeople["Buy"])
print(train_features_best.columns)
print("Accuracy")
print(accuracy)
print("Coeficientes")
print(log_model.coef_)
#print("Intercección ")
#print(log_model.intercept)

print("Matriz de confusion")
aux_preds = log_model.predict(X= train_features_best)
tablePred=pd.crosstab(aux_preds,dataPeople["Buy"])
print (pd.crosstab(aux_preds,dataPeople["Buy"]))