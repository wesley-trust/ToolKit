function Invoke-WTPropertyTagging {
    [cmdletbinding()]
    param (
        [parameter(
            Mandatory = $true,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The tags to be evaluated"
        )]
        [string[]]$Tags,
        [parameter(
            Mandatory = $true,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The property to tag within the input object"
        )]
        [string]$PropertyToTag,
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
            
            # Variables
            $MajorDelimiter = ";"
            $MinorDelimiter = "-"
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
    Process {
        try {
            
            foreach ($Object in $InputObject) {
                
                # Remove any existing tags to prevent duplicate tags
                foreach ($Tag in $Tags) {
                    $Object.PSObject.Properties.Remove("$Tag")
                }

                # Get Object properties
                $ObjectProperties = ($Object | Get-Member -MemberType NoteProperty).name 
                
                # Check if the property exists in the list of the object's properties
                if ($PropertyToTag -in $ObjectProperties) {
                    
                    # Split out Object information by defined delimiter(s) and tag(s)
                    $ObjectPropertySplit = ($Object.$PropertyToTag.split($MajorDelimiter)).Split($MinorDelimiter)

                    $TaggedInputObject = [ordered]@{}
                    foreach ($Tag in $Tags) {

                        # If the tag exists in the display name, 
                        if ($ObjectPropertySplit -contains $Tag) {

                            # Get the object index, increment by one to obtain the tag's value index
                            $TagIndex = $ObjectPropertySplit.IndexOf($Tag)
                            $TagValueIndex = $TagIndex + 1
                            $TagValue = $ObjectPropertySplit[$TagValueIndex]
                        
                            # Add tag to hashtable
                            $TaggedInputObject.Add($Tag, $TagValue)
                        }
                        else {
                            $TaggedInputObject.Add($Tag, $null)
                        }
                    }

                    # Append all properties and return object
                    foreach ($Property in $ObjectProperties) {
                        $TaggedInputObject.Add("$Property", $Object.$Property)
                    }

                    [pscustomobject]$TaggedInputObject
                }
                else {
                    $ErrorMessage = "The property to tag '$PropertyToTag', does not exist in the input object"
                    Write-Error $ErrorMessage
                }
            }
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
