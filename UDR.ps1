#Link to UDR
#https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-create-udr-arm-ps

##Create the UDR for the front-end subnet
$route = New-AzureRmRouteConfig -Name RouteToBackEnd `
-AddressPrefix 192.168.2.0/24 -NextHopType VirtualAppliance `
-NextHopIpAddress 192.168.0.4

#Create a route table named UDR-FrontEnd in the westus region that contains the route
$routeTable = New-AzureRmRouteTable -ResourceGroupName TestRG -Location westus `
-Name UDR-FrontEnd -Route $route

#Create a variable that contains the VNet where the subnet is. In our scenario, the VNet is named TestVNet.
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName TestRG -Name TestVNet

#Associate the route table created above to the FrontEnd subnet
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name FrontEnd `
-AddressPrefix 192.168.1.0/24 -RouteTable $routeTable

#Save the new subnet configuration in Azure
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

##Create the UDR for the back-end subnet

$route = New-AzureRmRouteConfig -Name RouteToFrontEnd `
-AddressPrefix 192.168.1.0/24 -NextHopType VirtualAppliance `
-NextHopIpAddress 192.168.0.4

#Create a route table named UDR-BackEnd in the uswest region that contains the route created above
$routeTable = New-AzureRmRouteTable -ResourceGroupName TestRG -Location westus `
-Name UDR-BackEnd -Route $route

#Associate the route table created above to the BackEnd subnet
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name BackEnd `
-AddressPrefix 192.168.2.0/24 -RouteTable $routeTable

#Save the new subnet configuration in Azure.
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

##Enable IP forwarding on FW1 

$nicfw1 = Get-AzureRmNetworkInterface -ResourceGroupName TestRG -Name NICFW1

$nicfw1.EnableIPForwarding = 1
Set-AzureRmNetworkInterface -NetworkInterface $nicfw1