param(
    [parameter(Mandatory=$True)]
    $FileName,
    [parameter(Mandatory=$True)]
    $FilterAfterDate
)
$AdultCost = 30
$AdultMembership = 40
$KidMembership = 20
$KidCost = 15


$recs = ConvertFrom-Csv (Get-content $FileName)
#$recs
# foreach ($rec in $recs ) {
#     "$($rec.Date),$($rec."Item Title"),$($rec.Gross)"
# }

$recs = $recs |  Where-Object Date -ge $FilterAfterDate
#return
$NotMatched = @()

Function Get-AdultKidsCount {
    param(
        $Cost
    )

    if([int]($Cost) -eq $AdultMembership){
        (1,0)
        return
    }
    if([int]($Cost) -eq $KidMembership){
        (0,1)
        return
    }

    $AdultCount = [int][Math]::Floor($rec.Gross / $AdultCost)
    $Remaining = $rec.Gross - ($AdultCount * $AdultCost)
    $KidsCount = [int][Math]::Floor($Remaining / $KidCost)

    $TotalCalculatedCost = ($AdultCount * $AdultCost) + ($KidsCount * $KidCost)
    $MaxTries = 3
    $Current = 1
    #Write-Host "Total: $TotalCalculatedCost Cost: $Cost"
    while ( ($TotalCalculatedCost -ne $Cost) -and ($MaxTries -ge $Current) ) {
        # reduce adults and increase kids
        $Current++
        $AdultCount--
        $Remaining = $rec.Gross - ($AdultCount * $AdultCost)
        $KidsCount = [int][Math]::Floor($Remaining / $KidCost)
        $TotalCalculatedCost = ($AdultCount * $AdultCost) + ($KidsCount * $KidCost)
        #Write-Host "Inside: Total: $TotalCalculatedCost Cost: $Cost"
    }

    ($AdultCount, $KidsCount)
}

$FinalRecords = @()
foreach ($rec in $recs ) {
    $Ratio = Get-AdultKidsCount -Cost $rec.Gross
    $AdultCount = $Ratio[0]
    $KidCount = $Ratio[1]
    <#$TotalCalculatedCost = ($AdultCount * $AdultCost) + ($KidsCount * $KidCost)
    if ($TotalCalculatedCost -ne [int]($rec.Gross)) {
        $NotMatched += "$($rec.Name) $Cost : $($rec.Gross) and calculated Cost:$($TotalCalculatedCost) : Adults: $($AdultCount) Kids: $($KidsCount)"
    }
    #>

    $Email = $rec."From Email Address"
    $TransactionId = $rec."Transaction ID"
    $Description = $rec."Item Title"
    $Member = $Description -like "*Membership*"
    #"$($rec.Name),$($Email),$($TransactionId),$($AdultCount),$($KidsCount),$($rec.Gross),$($Description),$($Member)"
    
    $rec | Add-Member -NotePropertyName AdultCount -NotePropertyValue $AdultCount
    $rec | Add-Member -NotePropertyName KidCount -NotePropertyValue $KidCount
}

$ids = @()
foreach($distictRecord in ($recs | sort Name | group Name) )
{
    $Id = ""
    $Adults = 0
    $Kids = 0
    $Email = ""
    $Total = 0
    $Member = $False
    foreach($entry in $distictRecord.Group){
        $Id += $entry."Transaction ID"    
        $Id += " "
        $Adults += [int]($entry."AdultCount")
        $Kids += [int]($entry."KidCount")
        $Email = $entry."From Email Address"
        $Total += [int]($entry.Gross)
        $Description = $entry."Item Title"
        $Member = $Description -like "*Membership*"
    }
    "$($distictRecord.Name),$($Email),$($Id),$($Adults),$($Kids),$($Total),$($Member)"
}


"----------------------------"
#$NotMatched
"----------------------------"