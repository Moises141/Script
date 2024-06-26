# Load the necessary assembly
Add-Type -AssemblyName System.Windows.Forms

# Function to create a hidden folder
function New-HiddenFolder {
    param (
        [string]$folderPath
    )
    
    if (-not (Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory | Out-Null
        (Get-Item -Path $folderPath).Attributes += 'Hidden'
    }
}

# Function to prompt the user and log the result
function Show-UserPromptAndWriteLog {
    param (
        [string]$changesDescription = "Unspecified changes were found.",
        [string]$logFilePath
    )
    
    $message = "The following changes were found during the integrity check:`n`n$changesDescription`n`nDo you want to allow these changes?"
    $title = "Integrity Check - Changes Found"

    $userChoice = [System.Windows.Forms.MessageBox]::Show(
        $message,
        $title,
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )
    
    $result = if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) { 
        "Changes allowed"
    } else {
        "Changes rejected"
    }
    
    # Log the result
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] User choice: $result"
    Add-Content -Path $logFilePath -Value $logMessage
    
    return $result
}

# Define the path for the hidden folder and log file
$hiddenFolderPath = "$env:USERPROFILE\IntegrityCheckLogs"
$logFilePath = "$hiddenFolderPath\IntegrityCheck.log"

# Create the hidden folder
New-HiddenFolder -folderPath $hiddenFolderPath

# Simulate finding changes (replace this with your actual integrity check logic)
$changesFound = @"
For more info, please check the logs or the checksum files.
"@

# Prompt the user and get the result
$result = Show-UserPromptAndWriteLog -changesDescription $changesFound -logFilePath $logFilePath

# Define paths for the checksum files and scripts
$originalChecksumsFile = "D:\\Playground\\checksums.txt"
$newChecksumsFile = "D:\\Playground\\new_checksums.txt"
$setupScript = "D:\\Setup.ps1"
$checkScript = "D:\\Check.ps1"

# Function to delete checksum files and run scripts
function Invoke-Changes {
    param (
        [string]$originalChecksums,
        [string]$newChecksums,
        [string]$setupScriptPath,
        [string]$checkScriptPath
    )
    
    # Delete checksum files
    if (Test-Path -Path $originalChecksums) {
        Remove-Item -Path $originalChecksums -Force
    }
    if (Test-Path -Path $newChecksums) {
        Remove-Item -Path $newChecksums -Force
    }
    
    # Run the Setup.ps1 script
    & $setupScriptPath
    Start-Sleep -Seconds 3
    & $setupScriptPath
    
    # Run the Check.ps1 script
    & $checkScriptPath
}

# Execute the changes if user allowed
if ($result -eq "Changes allowed") {
    Invoke-Changes -originalChecksums $originalChecksumsFile -newChecksums $newChecksumsFile -setupScriptPath $setupScript -checkScriptPath $checkScript
}

# Display the final message to the user
[System.Windows.Forms.MessageBox]::Show(
    "The integrity check process has completed. Result: $result`nCheck the log file for details.",
    "Integrity Check Complete",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Output the result to the console (optional)
Write-Host $result
