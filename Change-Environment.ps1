#grab the env
$env = Get-AzureRmEnvironment -Name "AzureUSGovernment"
 
#setup ARM
$acc = Add-AzureRmAccount -EnvironmentName $env 
$sub = Set-AzureRmContext -SubscriptionId $acc.Context.Subscription.SubscriptionId  