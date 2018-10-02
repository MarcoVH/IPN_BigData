from sklearn import linear_model
from sklearn import preprocessing
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import scipy.stats as stats
import itertools

dataPeople = pd.read_csv("clientes.csv")
lst = dataPeople.columns
no_lst = ['Obs No.','Buy']

aux_acc=0
print(range(len(lst)))
for j in range(len(lst)-1):
	print (j)
	combinaciones = list(itertools.combinations([c for c in dataPeople.columns if c not in no_lst], j+1))
	for i in combinaciones:
		train_features = dataPeople[[c for c in dataPeople.columns if c in i]]
		print(i)
		log_model = linear_model.LogisticRegression(solver='lbfgs')
		log_model.fit(X = train_features ,
	             y = dataPeople["Buy"])
		preds = log_model.predict(X= train_features)
		tablePred=pd.crosstab(preds,dataPeople["Buy"])
		accuracy  = log_model.score(X=train_features,
	                           y=dataPeople["Buy"])
		print(accuracy)
		print(aux_acc)
		if accuracy>aux_acc:
			aux_acc=accuracy
			train_features_best = train_features
			
	#print("accuracy")
	#print(accuracy)

log_model = linear_model.LogisticRegression(solver='lbfgs')
log_model.fit(X = train_features_best, y = dataPeople["Buy"])
accuracy  = log_model.score(X=train_features_best, y=dataPeople["Buy"])
print(train_features_best)
print("Accuracy")
print(accuracy)
print("Intercección ")
print(log_model.intercept)
print("Coeficientes")
print(log_model.coef_)
print("Matriz de confusion")
aux_preds = log_model.predict(X= train_features_best)
tablePred=pd.crosstab(aux_preds,dataPeople["Buy"])
print (pd.crosstab(aux_preds,dataPeople["Buy"]))


