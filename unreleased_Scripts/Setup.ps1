function Compare-FileChecksums {
    param(
        [string]$originalChecksumsFile,
        [string]$newChecksumsFile,
        [string]$matchAlertScriptPath = "D:\\2_Alert.ps1",
        [string]$mismatchAlertScriptPath = "D:\\Alert.ps1"
    )

    # Check if the original and new checksums files exist
    if (-not (Test-Path -Path $originalChecksumsFile)) {
        Write-Output "The original checksums file '$originalChecksumsFile' does not exist."
        return
    }
    if (-not (Test-Path -Path $newChecksumsFile)) {
        Write-Output "The new checksums file '$newChecksumsFile' does not exist."
        return
    }

    try {
        # Read the original checksums file
        $originalChecksums = Get-Content -Path $originalChecksumsFile | ForEach-Object {
            $line = $_ -split "\s+"
            [PSCustomObject]@{ FileName = $line[0]; Checksum = $line[1] }
        }

        # Read the new checksums file
        $newChecksums = Get-Content -Path $newChecksumsFile | ForEach-Object {
            $line = $_ -split "\s+"
            [PSCustomObject]@{ FileName = $line[0]; Checksum = $line[1] }
        }

        $mismatchFound = $false
        $mismatchedFiles = @()

        # Convert new checksums to a dictionary for quick lookup
        $newChecksumsDict = @{}
        foreach ($item in $newChecksums) {
            $newChecksumsDict[$item.FileName] = $item.Checksum
        }

        # Compare the original checksums with the new checksums
        foreach ($item in $originalChecksums) {
            if (-not $newChecksumsDict.ContainsKey($item.FileName)) {
                Write-Output "File '$($item.FileName)' listed in the original checksums does not exist in the new checksums."
                $mismatchFound = $true
                $mismatchedFiles += $item.FileName
            } else {
                # Checksum verification
                $newChecksum = $newChecksumsDict[$item.FileName]
                if ($newChecksum -ne $item.Checksum) {
                    Write-Output "Checksum mismatch for file '$($item.FileName)'. Original: $($item.Checksum), New: $newChecksum"
                    $mismatchFound = $true
                    $mismatchedFiles += $item.FileName
                }
                # Remove the file from the dictionary to track extra files later
                $newChecksumsDict.Remove($item.FileName)
            }
        }

        # Check for extra files in the new checksums not listed in the original checksums
        foreach ($file in $newChecksumsDict.Keys) {
            Write-Output "Extra file found: $file"
            $mismatchFound = $true
            $mismatchedFiles += $file
        }

        if ($mismatchFound) {
            Write-Output "Mismatch found: One or more files do not match the original checksums."

            # Run the mismatch alert script
            if (Test-Path -Path $mismatchAlertScriptPath) {
                Write-Output "Running mismatch alert script at '$mismatchAlertScriptPath'."
                & $mismatchAlertScriptPath
                # Wait for 2 seconds before closing the script
                Start-Sleep -Seconds 2
                exit
            } else {
                Write-Output "Mismatch alert script '$mismatchAlertScriptPath' not found."
            }
        } else {
            Write-Output "All files match the original checksums. No differences found."

            # Run the match alert script
            if (Test-Path -Path $matchAlertScriptPath) {
                Write-Output "Running match alert script at '$matchAlertScriptPath'."
                & $matchAlertScriptPath
                # Wait for 2 seconds before closing the script
                Start-Sleep -Seconds 2
                exit
            } else {
                Write-Output "Match alert script '$matchAlertScriptPath' not found."
            }
        }
    } catch {
        # Handle potential errors
        Write-Output "Error: $($_.Exception.Message)"
    }
}

# Define the path to the original checksums file and the new checksums file
$originalChecksumsFile = "D:\\Playground\\checksums.txt"
$newChecksumsFile = "D:\\Playground\\new_checksums.txt"

# Call the function to compare checksums
Compare-FileChecksums -originalChecksumsFile $originalChecksumsFile -newChecksumsFile $newChecksumsFile
