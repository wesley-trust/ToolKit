function New-WTRandomString {
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specify the character length (maximum 92)"
        )]
        [ValidateRange(1, 92)]
        [int]
        $CharacterLength = 12,
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specify whether to use alphabetic characters only"
        )]
        [switch]
        $Simplified,
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specify whether to use alphabetic and numeric characters only"
        )]
        [switch]
        $Alphanumeric
    )

    Begin {
        try {
            
            # Variables
            $LowerCase = ([char[]](97..122))
            $UpperCase = ([char[]](65..90))
            $Numbers = ([char[]](48..57))
            $Special = ([char[]](33..47))
        }
        catch {
            Write-Error -Message $_.Exception
            throw $_.exception
        }
    }
    
    Process {
        try {

            # Update length to reflect array start position
            $CharacterLength = $CharacterLength - 1
            
            # If simplified is specified
            if ($Simplified) {
                $CharacterSet = $LowerCase + $UpperCase
            }
            elseif ($Alphanumeric) {
                $CharacterSet = $LowerCase + $UpperCase + $Numbers
            }
            else {
                $CharacterSet = $LowerCase + $UpperCase + $Numbers + $Special
            }

            # Randomise set
            $RandomisedSet = $CharacterSet | Sort-Object { Get-Random }
            
            # Specify length of object from randomised set
            $Object = $RandomisedSet[0..$CharacterLength]

            # Randomise object
            $Object = $Object | Sort-Object { Get-Random }
            
            # Join objects to form string
            $RandomString = $Object -join ""
            
            # Return string
            $RandomString
        }
        Catch {
            Write-Error -Message $_.exception
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