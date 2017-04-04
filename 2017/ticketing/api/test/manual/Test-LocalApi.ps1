# post checkin
$postData = @"
{ "id": "1245", "adults" : "1", "kids" : "2"}
"@

Invoke-RestMethod -Method Post -Uri http://localhost:4000/tickets/checkins -Body $postData
Invoke-RestMethod -Method Get -Uri http://localhost:4000/tickets/checkins