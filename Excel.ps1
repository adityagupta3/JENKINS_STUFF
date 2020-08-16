$line = "D:\Job_ConsoleText\console.log"

$compLine = Select-String -Path $line -Pattern '[execute.install]' -SimpleMatch  

Write-Host $compLine

$time = $compLine.Substring(142,4)
Write-Host $time