# $url = 'http://localhost:4000'
$url = 'https://rzkowjvkb0.execute-api.us-west-2.amazonaws.com/Prod'

# get events
$eventsUrl = "$url/events"
$eventsUrl
#$events = (Invoke-RestMethod $eventsUrl ).body | ConvertFrom-JSON
$events = (Invoke-RestMethod $eventsUrl )
$eventId = $events.id


# get programs with details ( GET /events/{id}/programdetails/
$programDetailsUrl = "$url/events/$eventId/programs"
$programDetailsUrl
$programDetails = (Invoke-RestMethod $programDetailsUrl)
'------------------'
$programDetails
'-------------------'
return


$participant = $programDetails | select -first 1 | select participants
$firstParticipant = ($participant.participants | select -first 1)
$firstParticipant.id

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


 