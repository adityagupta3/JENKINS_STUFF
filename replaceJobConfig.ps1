$jenkins_base_url = 'http://guvcdbujenkin01:8080/jenkins'   #Chaning Jenkins link will require change of API Tokens
$pair = "a7gupta:118aafcdb81cd15bff2ec192a6325103da"   #Require API Token to be configured for user. POST APIs work only with API Token
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$uri = "http://guvcdbujenkin01:8080/jenkins/job/Sonata-Tests/job/MASTER_GGN/job/z_POC_Jenkins/job/PriorityTesting/job/Test/api/xml?tree=jobs[name]"
$AllJobResponse =  Invoke-WebRequest -Uri $uri  -Headers @{"Authorization" = $basicAuthValue} -Method GET
#Write-Host $AllJobResponse 
#Updating Publisher Tags
$ConfigNew = 'http://update-gur.bravurasolutions.com/%version%-Release/bravura-installer.jar&#xd;'
$ConfigOld = "http://update.bravurasolutions.com/%version%-Release/bravura-installer.jar&#xd;"

#Changing Labels
$LabelNew = '<assignedNode>JACOCO</assignedNode>'

# Getting names of jobs
[xml]$AllJobNode = $AllJobResponse
$JobList =  Select-Xml -Xml $AllJobNode -XPath "//name" | select-Object -ExpandProperty Node |  select-Object -ExpandProperty InnerText
Write-Host $JobList.Length

#Fetch Jobs 
$uri = "$($jenkins_base_url)/job/Sonata-Tests/job/MASTER_GGN/job/z_POC_Jenkins/job/PriorityTesting/job/Test/api/xml?tree=jobs[name]"
$AllJobResponse =  Invoke-WebRequest -Uri $uri  -Headers @{"Authorization" = $basicAuthValue} -Method GET

for($i=0;$i -le $JobList.Length;$i++){
    if ($JobList[$i].Length -ne 0){
        
        Write-Host "Job Name = $($JobList[$i])"
        $JobName = $JobList[$i]
    
    
        #Fetching Job XML
        $UpdatedConfigFile = "D:/Job_Config/$($JobName)_UpdatedConfigFile.xml"
        $TempConfigFile = "D:/Job_Config/$($JobName)_TempConfig.xml"
        $uri = "$($jenkins_base_url)/job/Sonata-Tests/job/MASTER_GGN/job/z_POC_Jenkins/job/PriorityTesting/job/Test/job/$($JobName)/config.xml" 
        $Configuration =  Invoke-WebRequest -Uri $uri  -Headers @{"Authorization" = $basicAuthValue} -Method GET -OutFile $TempConfigFile  
        Write-Host $Configuration
       
        $temp = Get-Content  $TempConfigFile
        $temp.replace($ConfigOld,$ConfigNew) | set-content  $UpdatedConfigFile -force
        
        $res =  Invoke-WebRequest -Uri $uri  -Headers @{"Authorization" = $basicAuthValue} -Method POST -InFile $UpdatedConfigFile
        Write-Host $res

       
        # $ConfigContent = Get-Content $TempConfigFile 
       # Write-Host $ConfigContent
        
       
        #$LabelOld = "<assignedNode>(.*?)</assignedNode>"
        #$NewConfigContent =   Replace($ConfigContent,$ConfigOld,$ConfigNew)
       # $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        #[System.IO.File]::WriteAllLines($UpdatedConfigFile, $NewConfigContent, $Utf8NoBomEncoding)    
        # $ConfigContent = Get-Content $TempConfigFile 
   # Write-Host $ConfigContent

    }
}