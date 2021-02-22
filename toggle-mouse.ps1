# Andrew Gaston 2021-02-21
# Written so that I can force myself to use the keyboard more heavily.
# Helpful sources:
# https://www.reddit.com/r/windows/comments/9k8nsp/is_there_a_way_to_disable_mouse_movement_with_a/
# https://stackoverflow.com/questions/64311594/checking-for-enabled-disabled-pnp-devices-in-powershell

# To do this manually:
# 1. Press windows key
# 2. Type in device manager
# 3. Tab
# 4. Down arrow until you get to the Mice and other pointing devices menu
# 5. Right arrow
# 6. Down arrow to find the device you want
# 7. Press enter on the device.
# 8. Press tab until you get to the top menu row, then right arrow over to Driver
# 9. Press tab until you get to the Enable Device/Disable device button
# 10. Press enter

param([switch]$Elevated, [switch]$disable, [switch]$enable)

if ($enable -and $disable){
    Write-Host 'Exiting script: Conflicting flags'
    return
}

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# force script to run with admin priveleges
# https://superuser.com/questions/108207/how-to-run-a-powershell-script-as-administrator
if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        Write-Warning 'Exiting script: Could not elevate to admin'
        return
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

Write-Host 'Script running with admin privileges'

foreach ($device in Get-PnpDevice -Class "Mouse"){
    if ($device -and ($device.Status -ne "Unknown")) {
        if ($disable)
        {
            if ($device.Status -eq 'OK'){
                Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
                Write-Host 'Disabled device'
            }
        }
        elseif ($enable) 
        {
            Enable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false
            Write-Host 'Enabled device'
        }
        else 
        {
            # Toggle based on current state
            switch ($device.Status) {
                'OK'    { Write-Host 'Disabled device'; Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false; break }
                default { Write-Host 'Enabled device';  Enable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false }
            }
        }
    }
}