# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/novasdream/datadog-aas-extension/refs/heads/master/management-scripts/install-extension-with-publishing-profile.ps1" -OutFile "install-extension-with-publishing-profile.ps1"
param (
    [Parameter(Mandatory = $true)][string]$SubscriptionId,
    [Parameter(Mandatory = $true)][string]$ResourceGroup
)

$rawAllSites = az webapp list --subscription $SubscriptionId -g $ResourceGroup --output json

$allSites = $rawAllSites | ConvertFrom-Json

Foreach ($webapp in @($allSites)) {

    if ($webapp.kind -eq "app") {
        $SiteName = $webapp.name
        Write-Host "Setting DD_DBM_PROPAGATION_MODE [${SiteName}]"
        az webapp config appsettings set -n ${SiteName} -g $ResourceGroup --settings DD_DBM_PROPAGATION_MODE=full | Out-Null
    }
}