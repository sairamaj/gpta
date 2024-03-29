import requests
import json
from datetime import datetime
from datetime import timezone

url = 'https://j142kxxeal.execute-api.us-west-2.amazonaws.com/Prod/tickets'

def test_get():
    response = requests.get(url)
    assert response.status_code == 200

def test_post_tickets():
    ticket1 = { 
                "id" : "1",
                "name": "test",
                "adults": "2",
                "kids" :"1"
    }
    tickets = [ticket1]
    response = requests.post(url,json.dumps(tickets))
    assert response.status_code == 200

def test_get_checkins():
    response = requests.get(url + '/checkins')
    assert response.status_code == 200
    
def test_post_checkins():
    user = {
        "id" : "1111",
        "adults" : 1,
        "kids" : 2,
        "updatedAt" : datetime.now(tz=timezone.utc).strftime('%m/%d/%Y, %H:%M:%S')
    }
    response = requests.post(url + '/checkins',json.dumps(user))
    assert response.status_code == 200

def test_get_summary():
    response = requests.get(url + '/summary')
    assert response.status_code == 200

         