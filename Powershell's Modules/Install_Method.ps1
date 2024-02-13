# Check if Winget is installed
function Test-WingetInstalled {
    $wingetInstalled = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetInstalled) {
        Write-Host "Winget is installed on this system."
    } else {
        Write-Host "Winget is not installed on this system."
    }
}

# Check if Chocolatey is installed
function Test-ChocolateyInstalled {
    $chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue
    if ($chocoInstalled) {
        Write-Host "Chocolatey is installed on this system."
    } else {
        Write-Host "Chocolatey is not installed on this system."
    }
}

# Main script
Write-Host "Checking for package managers on this Windows environment..."

Test-WingetInstalled
Test-ChocolateyInstalled

# Prompt user to press any key to close
Write-Host ""
Write-Host "Press any key to close this window..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
