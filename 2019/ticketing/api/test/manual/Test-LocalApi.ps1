# post checkin
$postData = @"
{ "id": "4JD86706CH762711V", "adults" : "1", "kids" : "2"}
"@

Invoke-RestMethod -Method Post -Uri http://localhost:4000/tickets/checkins -Body $postData
Invoke-RestMethod -Method Get -Uri http://localhost:4000/tickets/checkins