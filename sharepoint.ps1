#Admin Center & Site collection URL
$AdminCenterURL = "https://blackmangocapitalgroup-admin.sharepoint.com/"
$CSVPath = "C:\Temp\GroupsReport.csv"
$FolderName = "C:\Temp"
$FileName = "GroupsReport.csv"
 if (Test-Path $FolderName){

}
else
{
    New-Item -Path $FolderName -ItemType "directory"
   
}

if (Test-Path $CSVPath -PathType Leaf){
    Remove-Item $CSVPath
}
else
{
   
  
}
 New-Item $CSVPath -ItemType "file" -Force
#Connect to SharePoint Online
Connect-SPOService -url $AdminCenterURL -Credential (Get-Credential)
 
$GroupsData = @()
 
#Get all Site collections
Get-SPOSite -Limit ALL | ForEach-Object {
    Write-Host -f Yellow "Processing Site Collection:"$_.URL
  
    #get sharepoint online groups powershell
  
        $SiteGroups = Get-SPOSiteGroup -Site $_.URL 
    
        Write-host "Total Number of Groups Found:"$SiteGroups.Count
    
        ForEach($Group in $SiteGroups)
        {
          
            $Users =  Get-SPOUser -Site $_.URL -Limit All -Group $Group.Title 
            #Get-SPOSiteGroup -Site $SiteURL -Group $Group.Title 
            ForEach($spUser in $Users )
            {
               
               
               
                 $GroupsData += New-Object PSObject -Property @{
                'Site URL' = $_.URL
                'Group Name' = $Group.Title
                'Permissions' = $Group.Roles -join ","
                #'Users' =  $Group.Users -join "\n"
                'Users' =  $spUser.DisplayName 
                
             
                 }
               
            }

           
        }
    
}
#Export the data to CSV
$GroupsData | Export-Csv $CSVPath -NoTypeInformation
 
Write-host -f Green "Groups Report Generated Successfully!"