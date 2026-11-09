$ErrorActionPreference = 'Stop'
Push-Location (Split-Path $PSScriptRoot -Parent)
try {
    if (-not (Test-Path -LiteralPath globalTypes.d.luau) -or -not (Test-Path -LiteralPath Packages)) {
        throw 'Project is not installed. Run ./scripts/install.ps1 first.'
    }
    $rawImages = Get-ChildItem -Path src -Recurse -Filter *.luau |
        Where-Object { $_.FullName -notmatch '[\\/]UIController[\\/]Kit[\\/]Image\.luau$' } |
        Select-String -Pattern 'create\s*\(?\s*"Image(Label|Button)"', 'Instance\.new\(\s*"Image(Label|Button)"'
    if ($rawImages) {
        $rawImages | ForEach-Object { Write-Host "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
        throw 'Raw ImageLabel or ImageButton found. Use UIController/Kit/Image.luau so aspect ratios stay locked.'
    }
    & stylua src
    if ($LASTEXITCODE -ne 0) { throw 'StyLua formatting failed' }
    & rojo sourcemap default.project.json --output sourcemap.json
    if ($LASTEXITCODE -ne 0) { throw 'Rojo sourcemap failed' }
    & luau-lsp analyze --definitions=globalTypes.d.luau --sourcemap=sourcemap.json ./src
    if ($LASTEXITCODE -ne 0) { throw 'Luau analysis failed' }
    New-Item -ItemType Directory -Force build | Out-Null
    & rojo build default.project.json --output build/code.rbxlx
    if ($LASTEXITCODE -ne 0) { throw 'Rojo build failed' }
} finally {
    Pop-Location
}
