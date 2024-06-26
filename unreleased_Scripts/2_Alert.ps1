# Load the necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define the message and title
$message = "Passed files Verification"
$title = "Integrity check"

# Create a message box to alert the user
[System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Create and show a balloon tip notification (requires PowerShell 5.0 or higher)
$balloon = New-Object System.Windows.Forms.NotifyIcon
$balloon.Icon = [System.Drawing.SystemIcons]::Information
$balloon.BalloonTipText = $message
$balloon.BalloonTipTitle = $title
$balloon.Visible = $true
$balloon.ShowBalloonTip(10000)

# Wait to ensure the user sees the notification
Start-Sleep -Seconds 2

# Dispose of the balloon to clean up resources
$balloon.Dispose()
