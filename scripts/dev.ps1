param([int]$Port = 0)
$ErrorActionPreference = 'Stop'
Push-Location (Split-Path $PSScriptRoot -Parent)
try {
    if ($Port -eq 0) {
        $Port = if ($env:ROJO_PORT) { [int]$env:ROJO_PORT } else { 34873 }
    }
    Write-Host "Serving this folder to Studio on port $Port. In Studio, open the Rojo plugin, set the port to $Port and click Connect."
    & rojo serve default.project.json --port $Port
} finally {
    Pop-Location
}
