<#
.SYNOPSIS
    "Deploys" the sandbox page as a local container. Run by the self-hosted runner in the deploy jobs.
#>
param(
    [Parameter(Mandatory)] [ValidateSet('stg', 'prod')] [string] $Environment,
    [Parameter(Mandatory)] [ValidatePattern('^[0-9a-f]{40}$')] [string] $Commit
)

$ErrorActionPreference = 'Stop'
$port = @{ stg = 8091; prod = 8092 }[$Environment]
$name = "release-sandbox-b-$Environment"

docker build --build-arg "COMMIT=$Commit" --build-arg "ENVIRONMENT=$Environment" -t "${name}:$Commit" (Join-Path $PSScriptRoot '..')
if ($LASTEXITCODE -ne 0) { throw 'docker build failed' }

docker rm -f $name 2>$null | Out-Null
docker run -d --name $name --restart unless-stopped -p "127.0.0.1:${port}:80" "${name}:$Commit" | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'docker run failed' }

# Health check: the page must show the commit just deployed.
foreach ($attempt in 1..10) {
    Start-Sleep -Seconds 1
    try {
        if ((Invoke-WebRequest "http://127.0.0.1:$port/" -UseBasicParsing).Content -match $Commit) {
            "Deployed $Commit to ${Environment}: http://localhost:$port/"
            exit 0
        }
    }
    catch { }
}
throw "$Environment did not serve commit $Commit after deploying."
