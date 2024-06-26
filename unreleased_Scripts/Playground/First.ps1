# This script lists the programs installed on the system as shown in the Control Panel

# Define the registry paths to check for installed programs
$registryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
)

# Initialize an array to hold the program information
$programs = @()
# Iterate through each registry path
foreach ($path in $registryPaths) {
    # Get all the subkeys in the current registry path
    $subkeys = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
    foreach ($subkey in $subkeys) {
        # Get the properties of the subkey
        $program = Get-ItemProperty -Path $subkey.PSPath -ErrorAction SilentlyContinue
        # Check if the program has a DisplayName property
        if ($program.DisplayName) {
            # Create a custom object for the program
            $programInfo = [PSCustomObject]@{
                Name = $program.DisplayName
                Version = $program.DisplayVersion
                Publisher = $program.Publisher
                InstallDate = $program.InstallDate
            }
            # Add the program information to the array
            $programs += $programInfo
        }
    }
}

# Display the list of installed programs
$programs | Sort-Object Name | Format-Table -AutoSize