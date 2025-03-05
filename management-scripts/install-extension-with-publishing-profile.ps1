# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/novasdream/datadog-aas-extension/refs/heads/master/management-scripts/install-extension-with-publishing-profile.ps1" -OutFile "install-extension-with-publishing-profile.ps1"
param (
    [Parameter(Mandatory = $true)][string]$SubscriptionId,
    [Parameter(Mandatory = $true)][string]$ResourceGroup,
    # [Parameter(Mandatory=$true)][string]$SiteName,
    [Parameter(Mandatory = $false)][string]$Extension = "Datadog.AzureAppServices.DotNet",
    [Parameter(Mandatory = $false)][string]$DDApiKey = "<not-set>",
    [Parameter(Mandatory = $false)][string]$DDSite = "<not-set>",
    [Parameter(Mandatory = $false)][string]$DDEnv = "<not-set>",
    [Parameter(Mandatory = $false)][string]$DDService = "<not-set>",
    [Parameter(Mandatory = $false)][string]$DDVersion = "<not-set>",
    [Parameter(Mandatory = $false)][string]$ExtensionVersion,
    [Parameter(Mandatory = $false)][Switch]$Remove
)

$rawAllSites = az webapp list -g $ResourceGroup --output json

$allSites = $rawAllSites | ConvertFrom-Json

Foreach ($webapp in @($allSites)) {

    if ($webapp.kind -eq "app") {
        $SiteName = $webapp.name
        Write-Host "Detected windows app service [${SiteName}]"
        Write-Host "Trying to install"

        $rawProfile = az webapp deployment list-publishing-profiles --name $SiteName --resource-group $webapp.resourceGroup --output json

        if ([string]::IsNullOrEmpty($rawProfile) -or $rawProfile -eq "[]") {
            Write-Output "No publishing profiles found."
            return
        }

        # $publishProfile = $rawProfile | ConvertFrom-Json

        # $Username = $publishProfile[0].userName
        # $Password = $publishProfile[0].userPWD

        # .\extension\install-latest-extension.ps1 -SubscriptionId $SubscriptionId -ResourceGroup $ResourceGroup -SiteName $SiteName -DDApiKey $DDApiKey -DDSite $DDSite
    }
}