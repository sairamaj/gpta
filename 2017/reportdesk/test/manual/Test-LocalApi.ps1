$url = 'http://localhost:4000'


# get events
$eventsUrl = "$url/events"
$eventsUrl
$events = (Invoke-RestMethod $eventsUrl ).body | ConvertFrom-JSON
$eventId = $events.id
$eventId



# get programs with details ( GET /events/{id}/programdetails/
$programDetails = (Invoke-RestMethod "$url/events/$eventId/programdetails" ).body | ConvertFrom-JSON
#$programDetails
$participant = $programDetails | select -first 1 | select participants
$firstParticipant = ($participant.participants | select -first 1)
$participantId =  $firstParticipant.id

# post arrival info ( POST /participants/arrivalinfo

$arrivalinfourl = "$url/participants/arrivalinfo"
$arrivalinfourl
$postData = @"
{ "id": "$participantId", "status" : "1"}
"@

$postData
Invoke-RestMethod -Method POST -Uri $arrivalinfourl -Body $postData

# get participants arrival info ( GET /participants/arrivalinfo )
$arrivalInfoUrl = "$url/participants/arrivalinfo"
Invoke-RestMethod  $arrivalInfoUrl


 