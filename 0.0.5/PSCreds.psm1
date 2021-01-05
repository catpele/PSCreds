<#
    PowerShell Config and Credential Manager

    .SYNOPSIS
    Stores configuration and/or credentials for re-use with other PowerShell modules or scripts

    .DESCRIPTION
    Stores configuration and/or credentials for re-use with other PowerShell modules or scripts

#>

function New-Creds {
    <#
        .SYNOPSIS
        Securely stores a password in a local file

        .DESCRIPTION
        Securely stores a password cached in a local file. This file can only be decrypted on
        the same machine where this command was run.

        .PARAMETER Name
        The name of the file/service.

        .PARAMETER Path
        The path for the directory where the file will be stored. This should be specified
        without a trailing backslash.

        .EXAMPLE
        New-Creds -Name SMTP-Service -Path "C:\Scripts\Credentials"
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [string]
        $Path
    )

    # If no path is specified then it stores the credential file in the user's %APPDATA%
    if (!$Path) {
        [string] $Path = [System.IO.Path]::Combine(
            [Environment]::GetFolderPath('LocalApplicationData'),
            "Microsoft",
            "PowerShellCredentials",
            "$Name"
        )
    }
    else {
        $Path = "$Path\$Name"
    }

    $null = New-Item -Path $Path -Force
    $Message = 'Please provide your key/password/token in the password field.'
    $Credential = Get-Credential -Message $Message
    $Credential | Export-CliXml -Path $Path
    Write-Output "Creating credential file in $Path..."

}

function Read-Creds {
    <#
        .SYNOPSIS
        Read in the credentials stored in a file.

        .DESCRIPTION
        Read in the credentials stored in a file.

        .PARAMETER Name
        The name of the file/service.

        .PARAMETER Path
        The folder where the credentials file is stored.

        .EXAMPLE
        Read-Creds -Path "C:\Scripts\Credentials\SMTP-Service.creds"
    #>
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [string]
        $Name,

        [string]
        $Path
    )

    if (!$Path) {
        [string] $Path = [System.IO.Path]::Combine(
            [Environment]::GetFolderPath('LocalApplicationData'),
            "Microsoft",
            "PowerShellCredentials",
            "$Name"
        )
    }
    else {
        $Path = "$Path\$Name"
    }

    $Credential = Import-CliXml -Path $Path
    return $Credential
}
