<#
.DESCRIPTION
    Azure Automation runbook to stop resources
.NOTES
    Author: https://github.com/ph17k
#>

try {
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error "Failed to connect to Azure: $_"
    throw $_
}

# Stop Virtual Machines
Write-Output "Stopping virtual machines..."
$vms = Get-AzVM
foreach ($vm in $vms) {
    try {
        Write-Output "Stopping VM: $($vm.Name)"
        Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait
    }
    catch {
        Write-Error "Failed to stop VM $($vm.Name): $_"
    }
}

# Stop App Services
Write-Output "Stopping app services..."
$webapps = Get-AzWebApp
foreach ($webapp in $webapps) {
    try {
        Write-Output "Stopping app service: $($webapp.Name)"
        Stop-AzWebApp -ResourceGroupName $webapp.ResourceGroup -Name $webapp.Name
    }
    catch {
        Write-Error "Failed to stop app service $($webapp.Name): $_"
    }
}

# Stop Container Instances
Write-Output "Stopping container instances..."
$containers = Get-AzContainerGroup
foreach ($container in $containers) {
    try {
        Write-Output "Stopping container instance: $($container.Name)"
        Stop-AzContainerGroup -ResourceGroupName $container.ResourceGroupName -Name $container.Name
    }
    catch {
        Write-Error "Failed to stop container instance $($container.Name): $_"
    }
}

Write-Output "Resource stopping operations have been initiated."
