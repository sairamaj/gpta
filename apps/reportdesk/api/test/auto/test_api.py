import requests
import json

url = 'https://6omqvlx5rg.execute-api.us-west-2.amazonaws.com/Prod'

# GET: /events
def test_events_get():
    response = requests.get(f'{url}/events')
    assert response.status_code == 200

# GET: /participants/arrivalinfo
def test_participants_get():
    response = requests.get(f'{url}/participants/arrivalinfo')
    print(f'participants/arrivalinfo: {response.content}')
    assert response.status_code == 200

# POST: 
def test_participants_post():
    participant = { 
                "id" : "1",
                "status": "1"
    }
    response = requests.post(f'{url}/participants/arrivalinfo',json.dumps(participant))
    assert response.status_code == 200
