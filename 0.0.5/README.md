# PSCreds
A PowerShell module that allows for secure storage and access of credentials to use with
scripts, other modules and automation.

## Installation
It's recommended to install this module persistently so it loads for each PowerShell session
automatically.

1. `cd C:\Program Files\WindowsPowerShell\Modules`
2. `git clone git@github.com:giffgaff/it-pscreds.git PSCreds`
3. Restart any open PowerShell windows to use

## Saving credentials
1. Open up your PS terminal
2. `New-Creds -Name ImportantCreds`
3. Enter the username and password you'd like to save
4. A credentials file will be generated in your %APPDATA%\local directory or wherever you specified

### Examples

### Saving credentials globally
In most scenarios you're going to want to save credentials in a folder that the system or all users
can access to allow for scheduling and automation.

`New-Creds -Name ImportantCreds -Path C:\Creds`

## Using saved credentials
1. In your script or module create a variable to store the retrieved credentials (i.e. `$Creds = Read-Creds -Name ImportantCreds`)
2. You can then use the encrypted credentials in the same way you'd use credentials obtained via the
Get-Credential function

### Examples

#### Retrieving a password only
```
$Creds = Read-Creds -Name ImportantCreds
$Password = $Creds.GetNetworkCredential().Password
```

## How does it work?
PSCreds uses the native Get-Credential function to prompt for credentials on the command line. These are then encrypted and only usable on the machine they were entered on.

It then uses the Export-CliXml command to create and a file to store the encrypted credentials in, in a location of your choosing.

When it comes to using the creds, a simple `Import-CliXml` call is made to re-import the credentials and return them.

In your script or module you can use the credentials in the same way you'd use credentials stored with
the Get-Credential command.