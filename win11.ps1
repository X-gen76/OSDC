$CustomImageFile = "http://JRB-OSD/esd/win11pro21H2drivers.esd"; $Index = 1 # Windows 11 Image

function Show-Menu {
    param (
        [string]$Title = 'Select your image.'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Windows 10 Pro"
    Write-Host "2: Windows 11 Pro (All Drivers)"
    Write-Host "3: Windows 11 Pro "
    Write-Host "4: NUC7i7BNH Windows 10 Pro "
    Write-Host "Q: Press Q to quit."

    
}


do
 {
    Show-Menu
    $selection = Read-Host "Please select the image that you want to deploy"
    switch ($selection)
    {
    '1' {
    write-host 'You selected Windows 11 Pro (Generic) Image'
    $CustomImageFile = "http://JRB-OSD/esd/Win11Pro_Generic.esd"
    $selection = 'q'
    } '2' {
    write-host 'You selected Windows 11 Pro (All Drivers) Image'
    $CustomImageFile = "http://JRB-OSD/esd/Win11Pro_AllDrivers.esd"
    $selection = 'q'
    } '3' {
    write-host 'You selected NUC7i7BNH Windows 10 Pro'
    $CustomImageFile = "http://JRB-OSD/esd/NUC7i7BNH.esd"
    $selection = 'q'
    } '4' {
    write-host 'You selected Windows 10 Pro (Generic) Image'
    $CustomImageFile = "http://JRB-OSD/esd/Win10Pro_Generic.esd"
    $selection = 'q'
    
    } 'Q' {
    return
    }
    
    }
    
 }
 until ($selection -eq 'q')

# Set allowed ASCII character codes to Uppercase letters (65..90), 
$charcodes = 65..90

# Convert allowed character codes to characters
$allowedChars = $charcodes | ForEach-Object { [char][byte]$_ }

$LengthOfName = 10
# Generate computer name
$randomName = ($allowedChars | Get-Random -Count $LengthOfName) -join ""
 
Add-Type -AssemblyName Microsoft.VisualBasic
$ComputerName = [Microsoft.VisualBasic.Interaction]::InputBox('Computer Name', 'Computer Name', $randomName)
Write-Host "Computer will be renamed to $ComputerName once complete"
Write-Host -ForegroundColor Blue "Starting OSDCloud ZTI"

Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine

if ((Get-MyComputerModel) -match 'Virtual') {

Write-Host -ForegroundColor Green "Setting the Display Resolution to 1600x"

Set-DisRes 1600

}

Write-Host -ForegroundColor Green "Importing OSD PowerShell Module"

#Import-Module OSD -RequiredVersion 22.5.10.1 -Force #Import specific version
Import-Module OSD

######################
# Build variables
######################
    #=======================================================================
    # Create Hashtable
    #=======================================================================
    $Global:StartOSDCloud = $null
    $Global:StartOSDCloud = [ordered]@{
        DriverPackUrl = $null
        DriverPackName = "None"
        DriverPackOffline = $null
        DriverPackSource = $null
        Function = $MyInvocation.MyCommand.Name
        GetDiskFixed = $null
        GetFeatureUpdate = $null
        GetMyDriverPack = $null
        ImageFileOffline = $null
        ImageFileName = $null
        ImageFileSource = $null
        ImageFileTarget = $null
        ImageFileUrl = $CustomImageFile
        IsOnBattery = Get-OSDGather -Property IsOnBattery
        Manufacturer = $Manufacturer
        OSBuild = $OSBuild
        OSBuildMenu = $null
        OSBuildNames = $null
        OSEdition = $OSEdition
        OSEditionId = $null
        OSEditionMenu = $null
        OSEditionNames = $null
        OSLanguage = $OSLanguage
        OSLanguageMenu = $null
        OSLanguageNames = $null
        OSLicense = $null
        OSImageIndex = $Index
        Product = "none"
        Screenshot = $null
        SkipAutopilot = $SkipAutopilot
        SkipODT = $true
        TimeStart = Get-Date
        updateFirmware = $false
        ZTI = $true
    }


#Start OSDCloud ZTI the RIGHT way

Write-Host -ForegroundColor Blue "Start OSDCloud"

#Start-OSDCloud -OSLanguage en-gb -OSBuild 21H2 -OSEdition Pro -ZTI -SkipAutopilot 
#Start-OSDCloud -ImageFileUrl $CustomImageFile -ImageIndex $Index -ZTI -firmware -SkipAutopilot -SkipODT
#Start-OSDCloud -ImageFileUrl $CustomImageFile -ImageIndex $Index -firmware -SkipAutopilot -SkipODT

Invoke-OSDCloud

#Restart from WinPE
Write-Host "Savings computer name to file"
#Set-Content -Path "C:\osdcloud\computername.txt" -Value $ComputerName

# Output name to C:\temp
if (-not (Test-Path -Path "C:\temp")) {
    New-Item -ItemType Directory -Path "C:\temp"
}
Set-Content -Path "C:\temp\computername.txt" -Value $ComputerName

Write-Host -ForegroundColor Blue "Restarting in 20 seconds!"

Start-Sleep -Seconds 20

wpeutil reboot
