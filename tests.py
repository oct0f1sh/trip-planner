import server
import unittest
import json
import bcrypt
import base64
from pymongo import MongoClient


class TripPlannerTestCase(unittest.TestCase):
    def setUp(self):
        self.app = server2.app.test_client()
        server2.app.config['TESTING'] = True
        mongo = MongoClient('localhost', 27107)
        global db
        db = mongo.local
        server2.app.db = db
        db.drop_collection('users')

    def testCreateUser(self):
        self.app.post(
            '/users',
            data=json.dumps(dict(
            password="test",
            email="dunc@dunc.co"
            )), content_type='application/json'
        )

        response = self.app.get(
            '/users',
            query_string=dict(email="dunc@dunc.co")
        )

        response_json = json.loads(response.data.decode())

        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
