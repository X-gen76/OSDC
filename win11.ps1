# Custom Image URL
$CustomImageFile = "http://JRB-OSD/esd/win11pro21H2drivers.esd"; $Index = 1 # Windows 11 Image
function Show-Menu {
    param (
        [string]$Title = 'Select your Image'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Windows 10 Pro (Generic)"
    Write-Host "2: Windows 11 Pro (All Drivers)"
    Write-Host "3: Windows 11 Pro (Generic)"
    
}
