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
                
                # Get Object properties
                $ObjectProperties = ($Object | Get-Member -MemberType NoteProperty).name 
                
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
