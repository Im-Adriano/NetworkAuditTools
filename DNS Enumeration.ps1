# File: DNS Enumeration.ps1
# Author: gjb1058
# Date: 10/1/19
$srcfile = $args[0]
$count=0
ForEach ($line in (Get-Content -Path $srcfile)) {
    #Inform the user what website we're testing, on what line
    Write-Host "line $count : $line"
    try {
        #Test the connection to the website domain name with a single packet. Select the resulting
        #IPv4 Address from the test. If we encounter an error, stop so we can catch it.
        $connect = Test-Connection -ComputerName $line -Count 1 -ErrorAction Stop | Select IPv4Address
        $destIP = $connect."IPv4Address" #Get the IPv4Address in pretty plaintext
        Write-Host -ForegroundColor Green "$line IPv4 Address: $destIP" #print
    }
    catch [System.Net.NetworkInformation.PingException] { #Catch the Error for no DNS name 
        Write-Host -ForegroundColor Red "No known IP Address for $line" #inform the user
    }
    $count=$count+1 #Increment Line Count
}