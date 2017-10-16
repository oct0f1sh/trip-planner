from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
# from utils.mongo_json_encoder import JSONEncoder
from bson.objectid import ObjectId
from bson.json_util import dumps
import pdb
import bcrypt


app = Flask(__name__)
mongo = MongoClient('localhost', 27017)
app.db = mongo.trip_planner
app.bcrypt_rounds = 12
api = Api(app)


# Write Resources here
class User(Resource):
    def post(self):
        new_user = request.json
        user_collection = app.db.users
        result = user_collection.insert_one(new_user)
        user = user_collection.find_one({"_id": result.inserted_id})
        return user

    def get(self):
        hashed_auth = request.headers['Auth']
        #email = request.json['email']
        email = 'd@d.co'
        print(hashed_auth)

        user_collection = app.db.users
        user = user_collection.find_one({'email': email})

        if user is None:
            return ("Invalid email.", 401, None)

        if hashed_auth == user['auth']:
            return ("Logged in.", 200, None)
        else:
            return ("Incorrect login/password.", 401, None)

    def patch(self):
        updated_user = request.json
        user_collection = app.db.users
        user = user_collection.find_one(
            {'username': updated_user.get('username')})

        if user is None:
            return ("Invalid user.", 400, None)

        user_collection.update(
            {'username': updated_user.get('username')}, {'$set': updated_user})

        updated_user = user_collection.find_one(updated_user)
        return (updated_user, 200, None)

    def delete(self):
        username = request.json.get('username')
        user_collection = app.db.users
        user = user_collection.find_one({"username": username})

        # if no user is found with that username return with error
        if user is None:
            response = ("Invalid username.", 400, None)
            return response

        user_collection.remove({"username": username})
        response = ("Deleted successfully.", 200, None)
        return response


class Trip(Resource):
    def post(self):
        new_trip = request.json
        trip_collection = app.db.trips
        result = trip_collection.insert_one(new_trip)
        trip = trip_collection.find_one({"_id": ObjectId(result.inserted_id)})
        return trip

    def get(self, trip_id=None):
        trip_collection = app.db.trips

        # if url = /trips/
        if trip_id is None:
            trips = trip_collection.find({})

            if trips is None:
                response = "error"
                return (response, 404, None)
            else:
                return trips

        # if url = /trips/<trip_id>
        else:
            trip = trip_collection.find_one({"_id": ObjectId(trip_id)})
            return trip

    def patch(self, trip_id=None):
        trip_collection = app.db.trips
        trip = trip_collection.find_one({"_id": ObjectId(trip_id)})

        # if no trip is found with that ID return with error
        if trip is None:
            response = ("Invalid trip_id.", 400, None)
            return response

        new_trip = request.json
        trip_collection.update({"_id": ObjectId(trip_id)}, {'$set': new_trip})
        updated_trip = trip_collection.find_one({"_id": ObjectId(trip_id)})
        return (updated_trip, 200, None)

    def delete(self, trip_id=None):
        trip_collection = app.db.trips
        trip = trip_collection.find_one({"_id": ObjectId(trip_id)})

        # if no trip is found with that ID return with error
        if trip is None:
            response = ("Invalid trip_id.", 400, None)
            return response

        trip_collection.remove({"_id": ObjectId(trip_id)})
        response = ("Deleted successfully.", 200, None)
        return response


#  Add api routes here
api.add_resource(User, '/users/')
api.add_resource(Trip, '/trips/', '/trips/<string:trip_id>')


#  Custom JSON serializer for flask_restful
@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(dumps(data), code)
    resp.headers.extend(headers or {})
    return resp


if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
