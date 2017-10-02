Stop-AzureRmVM -Name "MO-VM" -ResourceGroupName "MO1-RG"

$vm = Get-AzureRmVm -Name "MO-VM" -ResourceGroupName "MO1-RG"

# Get info for the back end subnet
$myVnet = Get-AzureRmVirtualNetwork -Name "MO1-Prod-VNet" -ResourceGroupName "MO1-RG"
$backEnd = $myVnet.Subnets|?{$_.Name -eq 'OOB-Tier-Subnet'}

# Create a virtual NIC
$myNic3 = New-AzureRmNetworkInterface -ResourceGroupName "myResourceGroup" `
    -Name "myNic3" `
    -Location "EastUs" `
    -SubnetId $backEnd.Id

# Get the ID of the new virtual NIC and add to VM
$nicId = (Get-AzureRmNetworkInterface -ResourceGroupName "MO1-RG" -Name "MO1-NIC-OOB1").Id
Add-AzureRmVMNetworkInterface -VM $vm -Id $nicId | Update-AzureRmVm -ResourceGroupName "MO1-RG"

# List existing NICs on the VM and find which one is primary
$vm.NetworkProfile.NetworkInterfaces

# Set NIC 0 to be primary
$vm.NetworkProfile.NetworkInterfaces[0].Primary = $true
$vm.NetworkProfile.NetworkInterfaces[1].Primary = $false

# Update the VM state in Azure
Update-AzureRmVM -VM $vm -ResourceGroupName "MO1-RG"

Start-AzureRmVM -ResourceGroupName "MO1-RG" -Name "MO-VM" 