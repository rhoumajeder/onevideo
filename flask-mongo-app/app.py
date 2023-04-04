from flask import Flask, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)

# Connect to MongoDB
mongo_client = MongoClient('mongodb://mongo:27017/')
db = mongo_client['mydb']
data_collection = db['data']

# Insert some initial data
data_collection.insert_many([
    {'name': 'John', 'age': 25},
])

@app.route('/')
def index():
    data = list(data_collection.find())
    for doc in data:
        doc['_id'] = str(doc['_id'])
    return jsonify(data)

@app.route('/api/data', methods=['POST'])
def post_data():
    data = request.get_json()
    if data:
        data_collection.insert_one(data)
        return "success"
    else:
        return "failed"
        
        

@app.route('/d')
def delete_all_data():
    result = data_collection.delete_many({})
    return jsonify({'result': str(result.deleted_count) + ' records deleted'})
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
