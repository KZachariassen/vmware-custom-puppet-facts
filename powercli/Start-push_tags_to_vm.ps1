[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    $vcenter
)

write-host "Loading VMware.VimAutomation.Core module..."
Import-Module VMware.VimAutomation.Core -ErrorAction Stop
Write-Host "Connecting to vcenter on $vcenter..."
$VIServer = Connect-VIServer $vcenter
Write-Host "Connected to $vcenter"

$vmHosts = (Get-VMHost).Name

ForEach ($vmHost in $vmHosts)
{
    Start-Job -FilePath $PSScriptRoot\push_tags_to_vm.ps1 -ArgumentList $vcenter $vmHost -Name "Updating vm's on $vmHost"
}

#Wait for all jobs
Get-Job | Wait-Job
