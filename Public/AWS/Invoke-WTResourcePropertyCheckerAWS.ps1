function Invoke-WTResourcePropertyCheckerAWS {
    [cmdletbinding()]
    param (
        [parameter(
            Mandatory = $false,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The file path to the JSON file(s) that will be imported"
        )]
        [string[]]$FilePath,
        [parameter(
            Mandatory = $false,
            ValueFromPipeLineByPropertyName = $true,
            ValueFromPipeLine = $true,
            HelpMessage = "The directory path(s) of which all JSON file(s) will be imported"
        )]
        [alias("DirectoryPath")]
        [psobject]$Path,
        [parameter(
            Mandatory = $false,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The property to use as the ID"
        )]
        [string]$PropertyID = "typeName",
        [parameter(
            Mandatory = $false,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The path to the property value to check within"
        )]
        [string]$PropertyPath = "properties",
        [parameter(
            Mandatory = $false,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The properties to check within the input object"
        )]
        [string[]]$PropertiesToCheck = "Tags",
        [parameter(
            Mandatory = $false,
            ValueFromPipeLineByPropertyName = $true,
            HelpMessage = "The AWS region to check resources for properties"
        )]
        [string]$AWSRegion = "eu-west-2"
    )
    Begin {
        try {
            # Function definitions
            $RootPath = "../../Private"
            $Functions = @(
                "$RootPath/Invoke-WTJsonImport.ps1",
                "$RootPath/Invoke-WTPropertyCheck.ps1"
            )
            
            # Function dot source
            foreach ($Function in $Functions) {
                . $Function
            }
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
    Process {
        try {

            # Build Parameters
            $Parameters = @{}
            if ($Path) {
                $Parameters.Add("Path", $Path)
            }
            elseif ($FilePath) {
                $Parameters.Add("FilePath", $FilePath)
            }
            else {
                
                # Variables
                $DirectoryName = "CloudformationSchema"
                $FileName = "$DirectoryName.zip"
                $Uri = "https://schema.cloudformation.$AWSRegion.amazonaws.com/$FileName"

                # Download and extract
                Invoke-WebRequest -Uri $Uri -OutFile $FileName
                Expand-Archive -Path $FileName
                $Parameters.Add("Path", $DirectoryName)
            }

            # Invoke import of JSON files and return object
            $InputObject = Invoke-WTJsonImport @Parameters
            
            # Invoke and return property check on object
            $OutputObject = Invoke-WTPropertyCheck -InputObject $InputObject `
                -PropertiesToCheck $PropertiesToCheck `
                -PropertyPath $PropertyPath `
                -PropertyID $PropertyID
            
            # Error checking
            if ($InputObject.count -eq $OutputObject.count) {
                Write-Host "Count totals equal, property checking has been successful"
                
                # Return object
                $OutputObject
            }
            else {
                $ErrorMessage = "Input object count does not equal output object count, property checking has not been successful"
                Write-Error $ErrorMessage
                throw $ErrorMessage
            }
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
    End {
        try {
            # Clean up
            if ($FileName) {
                Remove-Item -Path $DirectoryName -Recurse
                Remove-Item -Path $FileName
            }
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
}
