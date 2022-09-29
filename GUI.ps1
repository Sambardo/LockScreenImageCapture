#region Load GUI Elements
Add-Type -AssemblyName PresentationCore,PresentationFramework

#Cleanup XAML options
$XAML= [XML](Get-Content -Path "$PSScriptRoot\GUI.xaml" -Raw)
$XAML.Window.RemoveAttribute('x:Class')
$XAML.Window.RemoveAttribute('xmlns:local')
$XAML.Window.RemoveAttribute('xmlns:d')
$XAML.Window.RemoveAttribute('xmlns:mc')
$XAML.Window.RemoveAttribute('mc:Ignorable')

#read XML as XAML
$XAMLreader = New-Object System.Xml.XmlNodeReader $XAML
$Rawform = [Windows.Markup.XamlReader]::Load($XAMLreader) 

#add XML namespace manager
$XmlNamespaceManager = [System.Xml.XmlNamespaceManager]::New($XAML.NameTable)
$XmlNamespaceManager.AddNamespace('x','http://schemas.microsoft.com/winfx/2006/xaml')

#Create hash table containing a representation of all controls
$GUI = @{}
$namedNodes = $XAML.SelectNodes("//*[@x:Name]",$XmlNamespaceManager)
$namedNodes | ForEach-Object -Process {$GUI.Add($_.Name, $Rawform.FindName($_.Name))}
#endregion Load GUI Elements

#region button code
$ButtonCode = {
    if($GUI["InputBox"].text){$name = $GUI["InputBox"].text}
    else{$name = "Image"}
    &"$PSScriptRoot\Get-LockScreenImage.ps1" -SavePath "$PSScriptRoot\$Name.jpg"
    $GUI["ImageBox"].Source = "$PSScriptRoot\$Name.jpg" 
}
$GUI["FetchButton"].add_Click($ButtonCode)

#endregion button code

#Show GUI
$Rawform.ShowDialog() 