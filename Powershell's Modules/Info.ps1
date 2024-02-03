# Display GPU and CPU clock speeds
$gpuInfo = Get-WmiObject -Class Win32_VideoController | Select-Object AdapterRAM, CurrentRefreshRate
$cpuInfo = Get-WmiObject -Class Win32_Processor | Select-Object CurrentClockSpeed

Write-Host "GPU Clock Speed: $($gpuInfo.CurrentRefreshRate) MHz"
Write-Host "CPU Clock Speed: $($cpuInfo.CurrentClockSpeed) MHz"

# Display RAM size and frequency
$ramInfo = Get-WmiObject -Class Win32_PhysicalMemory
$ramFrequency = $ramInfo[0].ConfiguredClockSpeed  # Assuming all RAM modules have the same frequency
$ramSizeGB = ($ramInfo | Measure-Object -Property Capacity -Sum).Sum / 1GB

Write-Host "RAM Size: $($ramSizeGB) GB"
Write-Host "RAM Frequency: $ramFrequency MHz"

# Display storage size
$storageInfo = Get-WmiObject -Class Win32_DiskDrive
$totalStorageSizeGB = [math]::Round(($storageInfo | Measure-Object -Property Size -Sum).Sum / 1GB, 2)

Write-Host "Total Storage Size: $totalStorageSizeGB GB"

# Display subtotal of storage sizes between drives
$driveSubtotals = $storageInfo | Group-Object -Property DeviceID | ForEach-Object {
    $driveSizeGB = [math]::Round(($_.Group | Measure-Object -Property Size -Sum).Sum / 1GB, 2)
    "Drive $($_.Name): $driveSizeGB GB"
}

Write-Host "Subtotal Storage Sizes:"
$driveSubtotals

# Wait for user input to close the script
Read-Host "Press Enter to exit"
