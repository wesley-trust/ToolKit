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
        [psobject]$QueryResponse
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

            # Get Query properties
            $QueryProperties = ($QueryResponse | Get-Member -MemberType NoteProperty).name 
            
            foreach ($Query in $QueryResponse) {
                
                # Split out Query information by defined delimeter(s) and tag(s)
                $QueryPropertySplit = ($Query.$PropertyToTag.split($MajorDelimiter)).Split($MinorDelimiter)

                $TaggedQueryResponse = [ordered]@{}
                foreach ($Tag in $Tags) {

                    # If the tag exists in the display name, 
                    if ($QueryPropertySplit -contains $Tag) {

                        # Get the object index, increment by one to obtain the tag's value index
                        $TagIndex = $QueryPropertySplit.IndexOf($Tag)
                        $TagValueIndex = $TagIndex + 1
                        $TagValue = $QueryPropertySplit[$TagValueIndex]
                        
                        # Add tag to hashtable
                        $TaggedQueryResponse.Add($Tag, $TagValue)
                    }
                    else {
                        $TaggedQueryResponse.Add($Tag, $null)
                    }
                }
                            
                # Append all properties and return object
                foreach ($Property in $QueryProperties) {
                    $TaggedQueryResponse.Add("$Property", $Query.$Property)
                }

                [pscustomobject]$TaggedQueryResponse
            }
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
    End {
        
    }
}
