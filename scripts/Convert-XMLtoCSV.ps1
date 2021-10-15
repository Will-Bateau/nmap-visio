

$subnets = "192.168.2.0/24"
#run nmap scan for each subnet
foreach ($subnet in $subnets)
{
    $filename = "Network"
    $nmapfile = $filename  + ".xml"
    nmap -P 20,21,22,23,25,3389,80,443,8080 -PE -R 192.168.2.1 -p 20,21,22,23,25,3389,80,443,8080 -oX $nmapfile --no-stylesheet -A -v $subnet

    $csvfilename = $filename  + ".csv"
    .\parse-nmap.ps1 $nmapfile | select ipv4, status, hostname, fqdn | Export-Csv $csvfilename
}

# Code Snippet from aperturescience.su