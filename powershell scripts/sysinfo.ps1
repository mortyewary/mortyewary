<#
.SYNOPSIS
    Gather system information
.DESCRIPTION
    This PowerShell script gathers system information
.EXAMPLE
    PS> .\sysinfo.ps1
    Gather system information
    List system information
    Computer Name:
    Operating System:
    Processor:
    Memory:
    Disk:
    System Information:
.LINK
    https://github.com/mortyewary/mortyewary
.NOTES
    Author: Waylon Neal
#>

# Gather system information
$computerInfo = Get-CimInstance -ClassName Win32_ComputerSystem
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$processorInfo = Get-CimInstance -ClassName Win32_Processor
$memoryInfo = Get-CimInstance -ClassName Win32_PhysicalMemory
$diskInfo = Get-CimInstance -ClassName Win32_DiskDrive

"System Information:" #List system information

"Computer Name: $($computerInfo.Name)"
"Operating System: $($osInfo.Caption)"
"Processor: $($processorInfo.Name)"
"Memory: $($memoryInfo.Capacity)"
"Disk: $($diskInfo.Model)"