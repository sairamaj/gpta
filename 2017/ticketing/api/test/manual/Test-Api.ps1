# post checkin
$postData = @"
{ "id": "A12", "adults" : "1", "kids" : "2"}
"@

Invoke-RestMethod -Method Post -Uri https://parfmou7ta.execute-api.us-west-2.amazonaws.com/Prod/tickets/checkins -Body $postData
Invoke-RestMethod -Method Get -Uri https://parfmou7ta.execute-api.us-west-2.amazonaws.com/Prod/tickets/checkins