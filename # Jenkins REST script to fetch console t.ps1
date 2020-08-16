# Jenkins REST script to fetch console text for Jobs

$jenkins = 'http://guvcdbujenkin01:8080/jenkins/view/all/job/Sonata-Tests/job/MASTER/job/BART/job/ADVISOR_FEE_UK'   #Chaning Jenkins link will require change of API Tokens
$uri_job = "$($jenkins)/lastBuild/consoleText"

#AUTH tokens for Jenkins user
$pair = "a7gupta:118aafcdb81cd15bff2ec192a6325103da"   #Require API Token to be configured for user. POST APIs work only with API Token
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"

$outfile_console = "D:\Job_ConsoleText\console.log"
$outfile_consoleTimeStamps = "D:\Job_ConsoleText\consoleWithTime.log"

$consoleFile_withTimeStamps = Invoke-WebRequest -Uri http://guvcdbujenkin01:8080/jenkins/view/all/job/Sonata-Tests/job/MASTER/job/BART/job/ADVISOR_FEE_UK/7/console -Headers @{"Authorization" = $basicAuthValue} -OutFile $outfile_consoleTimeStamps
$consoleFile = Invoke-WebRequest -Uri $uri_job -Headers @{"Authorization" = $basicAuthValue} -OutFile $outfile_console


Write-Host $consoleFile
Write-Host $consoleFile_withTimeStamps

