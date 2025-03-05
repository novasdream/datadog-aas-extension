 param (
    [Parameter(Mandatory=$true)][string]$SubscriptionId,
    [Parameter(Mandatory=$true)][string]$ResourceGroup,
    [Parameter(Mandatory=$true)][string]$SiteName,
    [Parameter(Mandatory=$false)][string]$Extension="Datadog.AzureAppServices.DotNet",
    [Parameter(Mandatory=$false)][string]$DDApiKey="<not-set>",
    [Parameter(Mandatory=$false)][string]$DDSite="<not-set>",
    [Parameter(Mandatory=$false)][string]$DDEnv="<not-set>",
    [Parameter(Mandatory=$false)][string]$DDService="<not-set>",
    [Parameter(Mandatory=$false)][string]$DDVersion="<not-set>",
    [Parameter(Mandatory=$false)][string]$ExtensionVersion,
    [Parameter(Mandatory=$false)][Switch]$Remove
 )

$rawProfile = az webapp deployment list-publishing-profiles --name $SiteName --resource-group $ResourceGroup --output json

if ([string]::IsNullOrEmpty($rawProfile) -or $rawProfile -eq "[]") {
    Write-Output "No publishing profiles found. Exiting script."
    Write-Output "${publishProfile}"
    exit 1
}

$publishProfile = $rawProfile | ConvertFrom-Json

$Username=$publishProfile[0].userName
$Password=$publishProfile[0].userPWD


$rawAllSites = az webapp list --output json


$allSites = $rawAllSites | ConvertFrom-Json


			Foreach($webapp in @($allSites)) {
				
				$SiteName=$webapp.name
                Write-Host "[${SiteName}] Requesting stop."
			}


# .\extension\install-latest-extension.ps1 -SubscriptionId $SubscriptionId -ResourceGroup $ResourceGroup -SiteName $SiteName -DDApiKey $DDApiKey -DDSite $DDSite