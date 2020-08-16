# Jenkins REST script to bulk update Jobs -- Replace method

$jenkins_base_url = 'http://guvcdbujenkin01:8080/jenkins/view/all/job/Sonata-Tests/job/MASTER/job/SCRUM/job/INDIA'   #Chaning Jenkins link will require change of API Tokens
$uri_jobNames = "$($jenkins_base_url)/api/xml?tree=jobs[name]"

#AUTH tokens for Jenkins user
$pair = "a7gupta:118aafcdb81cd15bff2ec192a6325103da"   #Require API Token to be configured for user. POST APIs work only with API Token
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"

$ConfigNew = "http://update-gur.bravurasolutions.local/%version%-Release/bravura-installer.jar"
$ConfigOld = "http://update.bravurasolutions.com/%version%-Release/bravura-installer.jar"

$ConfigOld1 = "e5d44edc-713c-4d86-b618-906e2690f173"
$ConfigNew1 = "6867f80c-9f6c-4578-b5b7-574c1a520abd"

#Fetch all jobs inside the folder and save it to xml type var
$AllJobResponse =  Invoke-WebRequest -Uri $uri_jobNames  -Headers @{"Authorization" = $basicAuthValue} -Method GET
[xml]$AllJobXML = $AllJobResponse
#Write-Host $AllJobResponse 

#Find total number of Jobs inside the folder
$JobList =  Select-Xml -Xml $AllJobXML -XPath "//name" | select-Object -ExpandProperty Node |  select-Object -ExpandProperty InnerText
Write-Host $JobList.Length


for($i=0;$i -le $JobList.Length;$i++){
    if ($JobList[$i].Length -ne 0){
        
        Write-Host "Job Name = $($JobList[$i])"
        $JobName = $JobList[$i]
    
    
        #Fetching Job XML
        $UpdatedConfigFile = "D:/Job_Config/$($JobName)_UpdatedConfigFile.xml"
        $UpdatedConfigFile1 = "D:/Job_Config/$($JobName)_UpdatedConfigFile1.xml"
        $TempConfigFile = "D:/Job_Config/$($JobName)_TempConfig.xml"
        $uri = "$($jenkins_base_url)/job/$($JobName)/config.xml" 
        $Configuration =  Invoke-WebRequest -Uri $uri  -Headers @{"Authorization" = $basicAuthValue} -Method GET -OutFile $TempConfigFile  
        Write-Host $Configuration
       
        $temp = Get-Content  $TempConfigFile
        $temp.replace($ConfigOld,$ConfigNew) | set-content  $UpdatedConfigFile -force
        $temp1 = Get-Content  $UpdatedConfigFile
        $temp1.replace($ConfigOld1,$ConfigNew1) | set-content  $UpdatedConfigFile1 -force
        
        $res =  Invoke-WebRequest -Uri $uri  -Headers @{"Authorization" = $basicAuthValue} -Method POST -InFile $UpdatedConfigFile1
        Write-Host $res

    }
}