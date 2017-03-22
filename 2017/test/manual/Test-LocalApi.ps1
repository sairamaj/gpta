# $url = 'http://localhost:4000'
$url = 'https://rzkowjvkb0.execute-api.us-west-2.amazonaws.com/Prod'

# get events
$eventsUrl = "$url/events"
$eventsUrl
#$events = (Invoke-RestMethod $eventsUrl ).body | ConvertFrom-JSON
$events = (Invoke-RestMethod $eventsUrl )
$eventId = $events.id
$eventId
return


# get programs with details ( GET /events/{id}/programdetails/
$programDetails = (Invoke-RestMethod "$url/events/$eventId/programdetails" ).body | ConvertFrom-JSON
#$programDetails
$participant = $programDetails | select -first 1 | select participants
$firstParticipant = ($participant.participants | select -first 1)
$firstParticipant.id

# post arrival info ( POST /participants/{id}/arrivalinfo/{status}
$arrivalinfourl = "$url/participants/$($firstParticipant.id)/arrivalinfo/1"
$arrivalinfourl
Invoke-RestMethod -Method POST $arrivalinfourl

# get participants arrival info ( GET /participants/arrivalinfo )
$arrivalInfoUrl = "$url/participants/arrivalinfo"
Invoke-RestMethod  $arrivalInfoUrl


 