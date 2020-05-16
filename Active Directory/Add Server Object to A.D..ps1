function _addToA.D. {
    [CmdLetBinding()]
    Param (
        [Parameter(Mandatory, Position=1)]
            [string] $PCName,
        [Parameter(Mandatory, Position=2)]
            [string] $domainName,
        [Parameter(Mandatory, Position=3)]
            [string] $Description,
        [Parameter(Mandatory, Position=4)]
            [string] $OU
    )
    
    #check first for an exisiting object
    try {
        Get-ADComputer $PC -Server $sDomain -ErrorAction Stop | Out-Null
        return "Present"
    } catch {
        try {
            New-ADComputer -Name $PCName -Description ($Description -replace "`n", " ") -Path $OU -ErrorAction Stop
            return "Success"
        } catch {
            return "Fail"
        }
    }
}

$serverName = "MyTestPC"
$domain = "mycompany.lab"
$description = "New 2016 Exchange Server"
$destinationOU = "OU=Prod,OU=Windows Server 2016,OU=Servers,OU=CORP,DC=mycompany,DC=lab"

switch (_addToA.D. -PCName $serverName `
                   -domainName $domain `
                   -Description $description `
                   -OU $destinationOU
        ) {
            "Present" {
                "$($serverName) object already exists in A.D."
            }
            "Success" {
                "$($serverName) object successfully added to A.D."
            }
            "Fail" {
                "Failed to add $($serverName) object to A.D. Error is $($Error)"
            }
        }