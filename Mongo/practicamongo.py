import pymongo
from pymongo import MongoClient
import json

client = MongoClient('localhost', 27017,username='root',password='Cic1234*',authSource="admin")
db = client["test"]
collection = db["data"]

data = db.data.find()
docs = data.count()
 
cols={}
for document in data:
	for key in document:
		if key in cols:
			cols[key]+=1
		else 
			cols[key]=1

a = {k: (v*100)/docs for k, v in cols.iteritems()}

print("Total de documentos:")
print(docs)
print(json.dumps(a, indent=1))

