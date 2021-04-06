param($SavePath = "~\Desktop\LockScreen$((Get-Date).ToString("dd-MM-yyyy")).jpg" )

$SID = [Security.Principal.WindowsIdentity]::GetCurrent().User.value
$Key = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\"
$Item = (dir "$Key\$SID")[-1]
$Path = $Item.GetValue("landscapeImage")
Copy-Item -Path $Path -Destination "$SavePath"