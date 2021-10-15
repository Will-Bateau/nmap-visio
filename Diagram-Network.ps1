function New-VisioNetworkDiagram {
<#
.SYNOPSIS
This function utlilizes the nmap function, a parser-converter function,
 and a diagramming function to create network diagrams in Vision programmatically.

.DESCRIPTION
1. Requires Vision installation on system
2. Runs the nmap function
3. Imports the corresponding XML file and converst to CSV
4. (Future TODO:) Update data warehouse with information
5. Use data to generate Visio diagram programatically

.PARAMETER nmapSubnet
This is the IP subnet that requires scanning

.PARAMETER workingDirectory
(Optional) The path for the exported XML from nmap, the CSV from the conversion, and the Visio diagram itself

.INPUTS
This function requires an IP subnet and (optional) working directory

.OUTPUTS
This function ouputs the exported XML from nmap, the CSV from the conversion, and the Visio diagram itself

.EXAMPLE
Usage: New-VisioNetworkDiagram -nmapSubnet 192.168.2.0/24 -workingDirectory C:\Visio

.LINK
For further information, please visit the repository located at:
http://github.com/DTIG-US/nmap-visio.git

.NOTES

#>

#region Parameters

#region Passed in parameters
Param ($nmapSubnet, $workingDirectory)
#endregion

#endregion

#region Visio PowerShell module
# Install Warning
Write-Host @"
    The following script requires Microsoft Visio to be installed.
    Does the local machine have Visio installed?
"@

# Installation
$visioInstallPresence = Read-Host "Please enter Y or N"

    if ($visioInstallPresence = "y") {
        Write-Host "Installing PowerShell Visio module..." -ForegroundColor Green
        Install-Module -Name Visio
    }
    else {
        Write-Host "Please execute this script from a system with Visio installed." -ForegroundColor Red
        Write-Host "The script is exiting now." -ForegroundColor Red
    }
#endregion

#region Run nmap
#run nmap scan for each subnet
    foreach ($subnet in $nmapSubnet)
    {
        $filename = "Network"
        $nmapfile = $filename  + ".xml"
        nmap -P 20,21,22,23,25,3389,80,443,8080 -PE -R 192.168.2.1 -p 20,21,22,23,25,3389,80,443,8080 -oX $nmapfile --no-stylesheet -A -v $subnet

        $csvfilename = $filename  + ".csv"
        .\parse-nmap.ps1 $nmapfile | select ipv4, status, hostname, fqdn | Export-Csv $csvfilename
    }

# Code Snippet from aperturescience.su

}