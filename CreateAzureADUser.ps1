		param (
		[Parameter(Mandatory=$true)]
			[string] $firstname,
			
		[Parameter(Mandatory=$true)]
			[string] $lastname,
			
		[Parameter(Mandatory=$true)]
			[string] $City,
			
		[Parameter(Mandatory=$true)]
			[string] $Office,

		[Parameter(Mandatory=$true)]
			[string] $Country,

		[Parameter(Mandatory=$true)]
			[string] $Department,		

       [Parameter(Mandatory=$true)]
			[string] $Password,

		[Parameter(Mandatory=$true)]
					$Mobilephone,
		
	[Parameter(Mandatory=$true)]
					$Officenumber
	)

$DisplayName = $firstname + ' ' + $lastname
$UserName = $DisplayName
$UserPrincipalName = $firstname + '.' + $lastname + '@Yourdomain.xx'
$UPN = $UserPrincipalName
$Mobilephone = $Mobilephone.ToString()
$Officenumber = $Officenumber.ToString()

$login = Get-AutomationPSCredential -Name 'AzureAdminCredentials'

Connect-MsolService -Credential $login

New-MsolUser -UserPrincipalName $UPN `
-DisplayName $UserName `
-ForceChangePassword $false `
-StrongPasswordRequired $true `
-Password $Password `
-FirstName $firstname `
-LastName $lastname `
-City $City `
-Office $Office `
-Department $Department `
-Country $Country `
-PhoneNumber $Officenumber `
-MobilePhone $Mobilephone