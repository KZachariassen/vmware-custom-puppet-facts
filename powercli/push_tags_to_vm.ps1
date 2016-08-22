[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    $vcenter,
    [Parameter(Mandatory=$True)]
    $vmHost
)

write-host "Loading VMware.VimAutomation.Core module..."
Import-Module VMware.VimAutomation.Core -ErrorAction Stop
Write-Host "Connecting to vcenter on $vcenter..."
$VIServer = Connect-VIServer $vcenter
Write-Host "Connected to $vcenter..."


#Get vm's from host
$_vmHost = Get-VMHost -Name $vmHost
$vms = ($_vmHost | Get-VM)

foreach($vm in $vms){
    $vmhost = Get-VMHost -Name $vm.VMHost.Name
    $vmhostDetails = ($vmhost | Select-Object @{Name = 'esx_Host_Name';Expression={$_.Name}}, @{Name = 'esx_Host_Manufacturer';Expression={$_.Manufacturer}}, @{Name = 'esx_Host_Model';Expression={$_.Model}}, @{ Name= 'esx_Host_Version';Expression={$_.Version}}, @{ Name= 'esx_Host_Build';Expression={$_.Build}},  @{ Name= 'esx_Host_Cluster';Expression={$_.Parent.Name}})
    $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec

    foreach($vmhostDetail in $vmhostDetails.PSObject.Properties){
        $extra = New-Object VMware.Vim.optionvalue
        $key = $vmhostDetail.Name
        $value = $vmhostDetail.Value
        $extra.Key="guestinfo.$key"
        $extra.Value=$value
        $vmConfigSpec.extraconfig += $extra

    }
    $vmv = (get-view –viewtype VirtualMachine –filter @{“Name”=$vm.Name})
    $vmv.ReconfigVM($vmConfigSpec)

    Write-Host "Details added: $vmhostDetails"
}
