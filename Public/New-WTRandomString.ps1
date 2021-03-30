function New-WTRandomString {
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specify the character length (maximum 256)"
        )]
        [ValidateRange(1, 256)]
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

            # Build the character sets
            if ($Simplified) {
                $CharacterSet = $LowerCase + $UpperCase
            }
            elseif ($Alphanumeric) {
                $CharacterSet = $LowerCase + $UpperCase + $Numbers
            }
            else {
                $CharacterSet = $LowerCase + $UpperCase + $Numbers + $Special
            }

            # For each character, randomise the set and return the first character
            $Object = foreach ($Character in 1..$CharacterLength){
                $RandomisedSet = $CharacterSet | Sort-Object { Get-Random }
                $RandomisedSet[0]
            }
            
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