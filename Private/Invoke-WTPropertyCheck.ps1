function Invoke-WTPropertyCheck {
    [cmdletbinding()]
    param (
        [parameter(
            Mandatory = $true,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The property to use as the ID"
        )]
        [string]$PropertyID,
        [parameter(
            Mandatory = $true,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The path to the property value to check within"
        )]
        [string]$PropertyPath,
        [parameter(
            Mandatory = $true,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The properties to check within the input object"
        )]
        [string[]]$PropertiesToCheck,
        [parameter(
            Mandatory = $true,
            ValueFromPipeLineByPropertyName = $true,
            ValueFromPipeLine = $true,
            HelpMessage = "The input object"
        )]
        [alias("QueryResponse")]
        [psobject]$InputObject
    )
    Begin {
        try {
            
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
    Process {
        try {
            
            $CheckedInputObjects = foreach ($Object in $InputObject) {

                # Get Object properties
                $ObjectProperties = ($Object.$PropertyPath | Get-Member -MemberType NoteProperty).name

                # Create object and add unique identifier
                $CheckedInputObject = [ordered]@{}
                $CheckedInputObject.Add($PropertyID, $Object.$PropertyID)
                
                # Check if the properties exist in the list of the object's properties
                foreach ($Property in $PropertiesToCheck) {
                    if ($Property -in $ObjectProperties) {

                        # Add tag to hashtable
                        $CheckedInputObject.Add($Property, $true)
                    }
                    else {
                        $CheckedInputObject.Add($Property, $false)
                    }
                }

                # Create object
                [pscustomobject]$CheckedInputObject
            }

            # Return objects
            Write-Host "All objects have been processed for properties, with a count of $($CheckedInputObjects.count)"
            $CheckedInputObjects
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
    End {
        try {

        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
}
