param(
    [string]$workshopId,
    [string]$changeNote,
    [string]$addonsDir,
	[string]$addonJson,
    [string]$garryBinDir
)

function Verify-Param {

    if (-not (Test-Path $addonsDir)) {
        throw "Couldn't find addons in directory $($addonsDir)"
    }
    if (-not (Test-Path $gmad)) {
        throw "Couldn't find 'gmad.exe' in garry's mod bin directory $($gmad)"
    }
    if (-not (Test-Path $gmpublish)) {
        throw "Couldn't find 'gmpublish.exe' in garry's mod bin directory $($gmpublish)"
    }
    if ((-not (Test-Path (Join-Path $addonJson "addon.json"))) -and (-not $noWorkshop)) {
        throw "Couldn't find 'addon.json' in current directory. Please create it to be used for the addon."
    }

}

function Extract-Addon-Contents {

    if (Test-Path "extracted-addon-content") { Remove-Item "extracted-addon-content" -Recurse -Force }
    New-Item -ItemType Directory -Name "extracted-addon-content" | Out-Null

    Set-Location $addonsDir

    Get-ChildItem -Directory |
        ForEach-Object {

            Write-Host "Processing addon $($_.Name)"

            $addonDir = $_.FullName

            Get-ChildItem -Path $addonDir -Directory |
                Where-Object { $_.Name -ne "lua" } |
                ForEach-Object {

                    $addonContentItemDir = $_.FullName

                    Write-Host "Extracting $($addonContentItemDir)"

                    Copy-Item -Path $addonContentItemDir -Destination (Join-Path $homeDir "extracted-addon-content") -Recurse -Force

            }
    }

    Set-Location $homeDir

}

function Prepare-Addon-Package {
    
    Copy-Item -Path (Join-Path $addonJson "addon.json") -Destination "extracted-addon-content" -Force

    if (Test-Path "out.gma") { Remove-Item "out.gma" -Force }

    $gmadArgs = @(
        "create",
        "-folder", "extracted-addon-content",
        "-out", "out.gma"
    )
    & $gmad @gmadArgs

    if ($LASTEXITCODE -ne 0 -or -not (Test-Path "out.gma")) {
        throw "Failed to create .gma (exit code $LASTEXITCODE)."
    }

}

function Update-Addon {

    $gmpublishArgs = @(
        "update",
        "-addon", "out.gma",
        "-id", $workshopId,
        "-changes", $changeNote
    )
    & $gmpublish @gmpublishArgs

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to update addon (exit code $LASTEXITCODE)."
    }

}

function Cleanup {

    if (-not $noWorkshop) {
        Remove-Item "extracted-addon-content" -Recurse -Force
        Remove-Item "out.gma" -Force
    }
}

$noWorkshop = $false

if (-not $workshopId) {
   $noWorkshop = $true
}

if (-not $changeNote) {
    $changeNote = "Updated content"
}

if (-not $addonsDir) {
    $addonsDir = "C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\addons"
}

if (-not $garryBinDir) {
    $garryBinDir = "C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\bin"
}

if (-not $addonJson) {
    $addonJson = "."
}

$gmad = Join-Path $garryBinDir "gmad.exe"
$gmpublish = Join-Path $garryBinDir "gmpublish.exe"
$homeDir = Get-Location

Write-Host "Gmod content addon updater v1.0"
Write-Host "Author: bobozee"
Write-Host ""


Write-Host "Checking configuration..."

Verify-Param

Write-Host "Valid configuration."


Write-Host "Extracting content from addons..."

Extract-Addon-Contents

Write-Host "Done extracting addon contents."

if (-not $noWorkshop) {

    Write-Host "Preparing addon package..."

    Prepare-Addon-Package

    Write-Host "Finished building addon package as out.gma"


    Write-Host "Uploading content addon..."

    Update-Addon

    Write-Host "Successfully updated addon."

}


Write-Host "Cleaning up..."

Cleanup

Write-Host "All done!"

Read-Host