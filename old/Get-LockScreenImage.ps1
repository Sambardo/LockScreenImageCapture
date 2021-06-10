<#
.Synopsis
This script is used to grab the current lock screen image on windows and save it as a jpg

.Description
The lock screen image is stored in a weird location without a filetype. 
This registry key has SID subkeys based on the current user ID: "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\"
Inside that key, the last SID in the list will always contain the path to the image file in a value "LandscapeImage"

.Parameter SavePath
Allows providing a custom save path for the image file, but the default will be the desktop and use the name LockScreenDay-Month-Year.jpg
#>
param($SavePath = "~\Desktop\LockScreen$((Get-Date).ToString("dd-MM-yyyy")).jpg" )

$SID = [Security.Principal.WindowsIdentity]::GetCurrent().User.value
$Key = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\"
$Item = (dir "$Key\$SID")[-1]
$Path = $Item.GetValue("LandscapeImage")
Copy-Item -Path $Path -Destination "$SavePath"