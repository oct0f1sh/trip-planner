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


def authenticate_user(f):
    def wrapper(*args, **kwargs):
        auth_user = request.authorization
        password = auth_user.password.encode('utf-8')
        print(password)

        user_collection = app.db.users
        user = user_collection.find_one({'email': auth_user.username})

        if user is None:
            return ("Invalid email.", 401, None)

        if bcrypt.checkpw(password, user['password']):
            print('user {} authenticated'.format(auth_user.username))
            return f(*args, **kwargs)
        else:
            return ("Incorrect login/password.", 401, None)
    return wrapper

# Write Resources here
class User(Resource):
    def post(self):
        print(request)
        json_user = request.json
        print(json_user)
        password = json_user['password'].encode('utf-8')
        user_collection = app.db.users

        exists = user_collection.find_one({'email': json_user['email']})
        if exists is None:
            user_dict = {'email': json_user['email'],
                         'password': bcrypt.hashpw(password, bcrypt.gensalt(app.bcrypt_rounds))}
            result = user_collection.insert_one(user_dict)
            user = user_collection.find_one({"_id": result.inserted_id})
            del user['password']
            return (user, 201, None)
        else:
            return ("Email in use", 401, None)

    @authenticate_user
    def get(self):
        user_collection = app.db.users
        user = user_collection.find_one({'email': request.authorization.username})

        if user is None:
            return (None, 400, None)
        else:
            del user['password']
            return (user, 200, None)

    @authenticate_user
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

    @authenticate_user
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
    @authenticate_user
    def post(self):
        new_trip = request.json
        trip_collection = app.db.trips

        user_collection = app.db.users
        user = user_collection.find_one({'email': request.authorization.username})

        result = trip_collection.insert_one(new_trip)
        trip = trip_collection.find_one({"_id": ObjectId(result.inserted_id)})
        return trip

    @authenticate_user
    def get(self, trip_id=None):
        trip_collection = app.db.trips

        user_collection = app.db.users
        # user = user_collection.find_one({'email': request.authorization.username})

        # if url = /trips/
        if trip_id is None:
            trips = trip_collection.find({'owner': request.authorization.username})

            if trips is None:
                response = "No content found"
                return (response, 204, None)
            else:
                return trips

        # if url = /trips/<trip_id>
        else:
            trip = trip_collection.find_one({"_id": ObjectId(trip_id)})
            return trip

    @authenticate_user
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

    @authenticate_user
    def put(self, trip_id=None):
        trip_collection = app.db.trips
        new_waypoint = request.json['waypoint']
        trip = trip_collection.find_one({"_id": ObjectId(trip_id)})


        if trip is None:
            return ('Invalid trip_id', 400, None)
        else:
            trip_collection.update({"_id": ObjectId(trip_id)}, {'$push': {'waypoints': new_waypoint}})

        updated_trip = trip_collection.find_one({"_id": ObjectId(trip_id)})

        return (updated_trip, 200, None)

    @authenticate_user
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
    # Turn this on in debug mode to get detailed information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
