# Get GPU's name from Windows environment
$gpuName = Get-WmiObject -Class Win32_VideoController | Select-Object -ExpandProperty Name

# Get CPU's name from Windows environment
$cpuName = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name

# Display GPU's and CPU's names
Write-Host "Current GPU: $gpuName"
Write-Host "Current CPU: $cpuName"

# Wait for 2 seconds
Start-Sleep -Seconds 2

Clear-Host

#Display message
Write-host "Searching for possible upgrades for components"

# Wait for 3 seconds
Start-Sleep -Seconds 3

# Open default web browser and search for GPU upgrade recommendations on Google
$googleGpuSearchQuery = "GPU upgrade recommendations for $gpuName"
$googleGpuSearchUrl = "https://www.google.com/search?q=$googleGpuSearchQuery"
Start-Process $googleGpuSearchUrl

# Wait for 3 seconds after the first search
Start-Sleep -Seconds 2

# Open default web browser and search for CPU upgrade recommendations on Google
$googleCpuSearchQuery = "CPU upgrade recommendations for $cpuName"
$googleCpuSearchUrl = "https://www.google.com/search?q=$googleCpuSearchQuery"
Start-Process $googleCpuSearchUrl
