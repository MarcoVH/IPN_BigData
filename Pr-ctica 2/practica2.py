import csv, json, sys

#1. Leer el archivo "TodasLasNoticias.csv" y pasarlo a un archivo JSON.
# El objeto contendrá una lista con un diccionario por cada posición,
# donde cada diccionario tendrá cinco llaves:
#I Fecha, II Título, III url IV Descripción, V Categoría

fieldnames = ["Fecha","Título","url","Descripción", "Categoría"]
csvFile = open('TodasLasNoticias.csv', 'r', encoding='UTF8')
csvReader = csv.DictReader(csvFile, fieldnames=fieldnames)

#2. Guardar el archivo JSON con el nombre "noticias.json"

jsonf = open('noticias.json','w', encoding = "utf8")
data = json.dumps([r for r in csvReader], ensure_ascii=False)
jsonf.write(data)
csvFile.close()
jsonf.close()
