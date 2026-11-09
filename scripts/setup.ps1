$ErrorActionPreference = 'Stop'
Push-Location (Split-Path $PSScriptRoot -Parent)
try {
    $problems = New-Object System.Collections.Generic.List[string]

    function Test-Tool([string]$Name, [string]$Fix, [bool]$Required) {
        if (Get-Command $Name -ErrorAction SilentlyContinue) {
            Write-Host "[ok]      $Name"
        } elseif ($Required) {
            Write-Host "[missing] $Name"
            $problems.Add("Install $Name. $Fix")
        } else {
            Write-Host "[missing] $Name (only needed for UI work)"
        }
    }

    Test-Tool 'git' 'Get it from https://git-scm.com/downloads' $true
    Test-Tool 'rokit' 'Get it from https://github.com/rojo-rbx/rokit and restart the terminal' $true
    Test-Tool 'python' 'Python 3 with Pillow and numpy (pip install pillow numpy)' $false
    Test-Tool 'node' 'Node 22 or newer from https://nodejs.org' $false

    if (Get-Command git -ErrorAction SilentlyContinue) {
        if (-not (git config user.name) -or -not (git config user.email)) {
            Write-Host '[missing] git identity'
            $problems.Add('Run: git config --global user.name "Your Name" and git config --global user.email "you@example.com"')
        } else {
            Write-Host "[ok]      git identity ($(git config user.name))"
        }
    }

    if ($problems.Count -gt 0) {
        Write-Host ''
        Write-Host 'Fix these, then run ./scripts/setup.ps1 again:'
        $problems | ForEach-Object { Write-Host "  - $_" }
        exit 1
    }

    ./scripts/install.ps1
    ./scripts/check.ps1
    Write-Host ''
    Write-Host 'Code tools are ready. Still to do by hand, once (see docs/getting-started.md):'
    Write-Host '  - Install the Rojo plugin in Studio'
    Write-Host '  - Create your own test place in Creator Hub'
    Write-Host '  - Run ./scripts/dev.ps1 and connect Studio'
} finally {
    Pop-Location
}
