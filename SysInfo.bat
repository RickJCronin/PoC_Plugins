@echo off

::set token
set /p Token=<c:/PROGRA~1/Telegraf/token.conf

::parse the VER command 
   FOR /F "tokens=4,*" %%G IN ('ver') DO SET version=%%G 
   :: show the result 
   :: echo %version%
   set version=%version:] =%
   :: echo %version%

set _cmda=systeminfo
FOR /F "tokens=2* delims=:" %%H IN ('%_cmda% ^|find "OS Name"') DO SET _osName=%%H 
   :: show the result 
   set _osName=%_osName: =%
   rem echo Tagged OS is %_osName%



rem echo Starting to get IP information
set _cmdb=ipconfig
FOR /F "tokens=2* delims=:" %%H IN ('%_cmdb% ^|find "IPv4"') DO SET _IPadd=%%H 
   :: show the result
   set _IPadd=%_IPadd: =%
   rem echo IP Address is %_IPadd%

set _cmdc=hostname
FOR /F "tokens=1* delims=:" %%J IN ('%_cmdc%') DO SET _Host=%%J
rem echo  Hostname is :%_Host%

set _Metric=RjC.Host.Details.count 1 host=%_Host% OS=%str% IPaddress=%_IPadd%

rem echo "Metric is:"%_Metric%



echo win.Host.Details.count 1 host=%_Host% IPaddress=%_IPadd% OS=%_osName% Hostname=%_Host% Version=%version% | curl -H "Authorization: Bearer %Token%" --data @- https://demo.wavefront.com/report?f=graphite_v2