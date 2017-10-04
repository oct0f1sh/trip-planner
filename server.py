from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from utils.mongo_json_encoder import JSONEncoder
from bson.objectid import ObjectId
import bcrypt


app = Flask(__name__)
mongo = MongoClient('localhost', 27017)
app.db = mongo.local
app.bcrypt_rounds = 12
api = Api(app)


# Write Resources here
class User(Resource):
    def post(self):
        new_myobject = request.json
        myobject_collection = app.db.users
        result = myobject_collection.insert_one(new_myobject)
        myobject = myobject_collection.find_one({"_id": ObjectId(result.inserted_id)})
        return myobject

    def get(self, myobject_id):
        myobject_collection = app.db.users
        myobject = myobject_collection.find_one({"_id": ObjectId(myobject_id)})

        if myobject is None:
            response = "error"
            return (response, 404, None)
        else:
            return myobject


#  Add api routes here
api.add_resource(User, '/users')


#  Custom JSON serializer for flask_restful
@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp


if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
