#3. Hacer un endpoint que reciba una petición de tipo GET con el parámetro "categoría"
#  para que retorne las noticias correspondientes al parámetro dado.

from flask import Flask, jsonify
import json

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False

with open('noticias.json', encoding="utf8") as f:
   file = json.load(f)



@app.route('/getData/<name>')
def getData(name):
    res = [d for d in file if d['Categoría'] == name]
    print(json.dumps(res, ensure_ascii=False))
    return jsonify(success=True, data=res)

if __name__ == "__main__":
  app.run(host='localhost', port=8080, debug=True)