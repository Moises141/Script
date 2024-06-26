# Function to install Chocolatey
function Install-Chocolatey {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Chocolatey has been successfully installed."
}

# Function to install Winget
function Install-Winget {
    Write-Host "Installing Windows Package Manager (Winget)..."
    
    $wingetReleasesApiUrl = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    
    # Function to download the latest Winget release asset
    function Get-LatestWingetInstaller {
        param ([string]$releasesApiUrl)
        $response = Invoke-RestMethod -Uri $releasesApiUrl -Headers @{ "User-Agent" = "PowerShell Script" }
        $installerUrl = $response.assets | Where-Object { $_.name -match "msixbundle" } | Select-Object -ExpandProperty browser_download_url
        return $installerUrl
    }
    
    $latestWingetInstallerUrl = Get-LatestWingetInstaller -releasesApiUrl $wingetReleasesApiUrl
    $installerPath = "$env:USERPROFILE\Downloads\wingetInstaller.msixbundle"
    
    Invoke-WebRequest -Uri $latestWingetInstallerUrl -OutFile $installerPath
    Add-AppxPackage -Path $installerPath
    
    Write-Host "Winget has been successfully installed."
}

# Function to check if an application is installed
function Test-Installation {
    param ([string]$command)
    return Get-Command $command -ErrorAction SilentlyContinue
}

# Main function to start the script
function Main {
    $wingetInstalled = Test-Installation "winget"
    $chocoInstalled = Test-Installation "choco"

    if ($wingetInstalled -and $chocoInstalled) {
        Write-Host "Both Winget and Chocolatey are installed."
    } elseif ($wingetInstalled) {
        Write-Host "Winget is installed."
    } elseif ($chocoInstalled) {
        Write-Host "Chocolatey is installed."
    } else {
        Write-Host "Neither Winget nor Chocolatey is installed."
        $choice = Read-Host "Would you like to install Chocolatey (C) or Winget (W)? Enter C or W"
        
        switch ($choice.ToUpper()) {
            'C' {
                Install-Chocolatey
            }
            'W' {
                Install-Winget
            }
            default {
                Write-Host "Invalid choice. Exiting script."
            }
        }
    }
}

Main
