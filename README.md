README

LinuxSysinfor.sh:

Copy the file to the telegraf installation directory (/etc/telegraf).
Create a file - proxy.conf - in the telegraf installation directory. proxy.conf file should contains two entries:
proxyhostaddress (either hostname or IP address)
proxyport number (default will be 2878)

Copy SysInfo.conf to the telegraf installation directory (/etc/telegraf)/telegraf.d)

restart the telegraf service - service telegraf restart

New metrics should start flowing:
ts("Linux.Host.Details.Count")
Use the following format:
Table
Point Tags = Custom - include "Hostname IPaddress OS Version"
Uncheck all other boxes

SysInfo.bat:
Copy the file to the telegraf installation directory (c:/PROGRA~1/Telegraf/).
Currently, windows batch file uses direct ingestion
Create a file - token.conf - in telegraf installation directory.
Copy WinSysInfo.conf to the telegraf installation directory

restart the telegraf service

New metrics should start flowing:
ts("win.Host.Details.Count")
Use the following format:
Table
Point Tags = Custom - include "Hostname IPaddress OS Version"
Uncheck all other boxes


