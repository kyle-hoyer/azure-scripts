#grab the env
$env = Get-AzureRmEnvironment -Name "AzureUSGovernment"
 
#setup ARM
$acc = Add-AzureRmAccount -EnvironmentName $env 
$sub = Set-AzureRmContext -SubscriptionId $acc.Context.Subscription.SubscriptionId  


# Obtain VM reference and check Availability Set #

$RGname = "magat-resource-group"
$VMName = “evm-ms2012-vm01”

$VirtualMachine = Get-AzureRmVM -ResourceGroupName $RGname -Name $VMName

# Obtain NIC, subnet and VNET references: #

$NIC = Get-AzureRmNetworkInterface -Name "evm-ms2012-vm0186" -ResourceGroupName $RGname

$NIC.IpConfigurations[0].PrivateIpAddress # ‘10.0.0.6’

$VNET = Get-AzureRmVirtualNetwork -Name "NPS-Network" -ResourceGroupName "NPS"

$Subnet2 = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name "NPS"

$NIC.IpConfigurations[0].Subnet.Id = $Subnet2.Id

Set-AzureRmNetworkInterface -NetworkInterface $NIC

