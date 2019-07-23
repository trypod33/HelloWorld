#PowerShell

Clear

function Get-SystemStats ($ComputerName=$ENV:ComputerName) {

if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
    $ComputerSystem = Get-WmiObject -ComputerName $ComputerName -Class Win32_operatingsystem -Property CSName, TotalVisibleMemorySize, FreePhysicalMemory
    $MachineName = $ComputerSystem.CSName
    $FreePhysicalMemory = ($ComputerSystem.FreePhysicalMemory) / (1mb)
    $TotalVisibleMemorySize = ($ComputerSystem.TotalVisibleMemorySize) / (1mb)
    $TotalVisibleMemorySizeR = “{0:N2}” -f $TotalVisibleMemorySize
    $TotalFreeMemPerc = ($FreePhysicalMemory/$TotalVisibleMemorySize)*100
    $TotalFreeMemPercR = “{0:N2}” -f $TotalFreeMemPerc
    $CPULoad = Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average
    $CPULoadAverage = $CPULoad.Average

# print the machine details:
    “System ID: $MachineName”
    “RAM: $TotalVisibleMemorySizeR GB”
    “Free Physical RAM Memory: $TotalFreeMemPercR %”
    "CPU Current Load: $CPULoadAverage %"
    " "
    "Available Drives Total size and Free Space"
    gwmi win32_logicaldisk | Format-Table -AutoSize DeviceId, @{n="Size";e={[math]::Round($_.Size/1GB,2)}},@{n="FreeSpace";e={[math]::Round($_.FreeSpace/1GB,2)}}

Exit

} }

Clear | Get-SystemStats
