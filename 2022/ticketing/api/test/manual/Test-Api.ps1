# post checkin
$updatedAt = [DateTime]::UtcNow

$postData = @"
{ "id": "A12", "adults" : "1", "kids" : "2", "updatedAt" : "$updatedAt"}
"@

$url  ='https://c6hqh0tjcl.execute-api.us-west-2.amazonaws.com/Prod/tickets'
Invoke-RestMethod -Method Post -Uri "$($url)/checkins" -Body $postData
Invoke-RestMethod -Method Get -Uri "$($url)/checkins"