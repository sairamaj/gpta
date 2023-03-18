$AdultCost = 14
$KidCost = 12
$recs = ConvertFrom-Csv (Get-content .\Y8WCA2R8VA86C-CSR-20220310000000-20220405235959-20220406214618.csv)
$recs = $recs |  Where-Object Description -eq 'Website Payment'
$NotMatched = @()

Function Get-AdultKidsCount {
    param(
        $Cost
    )

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

foreach ($rec in $recs ) {
    $Ratio = Get-AdultKidsCount -Cost $rec.Gross
    $AdultCount = $Ratio[0]
    $KidsCount = $Ratio[1]
    $TotalCalculatedCost = ($AdultCount * $AdultCost) + ($KidsCount * $KidCost)
    if ($TotalCalculatedCost -ne [int]($rec.Gross)) {
        $NotMatched += "$($rec.Name) $Cost : $($rec.Gross) and calculated Cost:$($TotalCalculatedCost) : Adults: $($AdultCount) Kids: $($KidsCount)"
    }

    $Email = $rec."From Email Address"
    $TransactionId = $rec."Transaction ID"
    "$($rec.Name),$($Email),$($TransactionId),$($AdultCount),$($KidsCount),$($rec.Gross)"
}

"----------------------------"
$NotMatched
"----------------------------"