@if (@code == @batch) @then
@echo off
setlocal EnableDelayedExpansion
rem newline character for final IP list, taken from stackoverflow.com
(set \n=^
%==%
)

set ipInFile=%1
set ipOutFile=%2

rem Validating args
if "%ipInFile%"=="" (
    echo Invlaid agruments.
    echo Usage: pinger.bat [inputFile] [outputFile]
    exit 1
)
    
if "%ipOutFile%"=="" (
    echo Invlaid agruments.
    echo Usage: pinger.bat [inputFile] [outputFile]
    exit 1
)

if not exist %ipInFile% (
   echo Specified input file does not exist: %ipInFile%
   exit 1    
)

rem Scrapping IPs to temp.txt
cscript //nologo //E:jscript %0 %*

if (not exist temp.txt) (
    echo No IPs were found in %ipInFile%
    exit 1
) else (
    set ipInFile=temp.txt
)

set ipStatusList=

echo Checking IPs...
for /f "tokens=*" %%a in (%ipInFile%) do (
  ping %%a | find "TTL=">nul
  if errorlevel 1 (
      set ipStatusList=!ipStatusList!%%a is up!\n!
  ) else (
      set ipStatusList=!ipStatusList!%%a is up!\n!
  )
)

del temp.txt

rem Printing results
echo !ipStatusList!
echo !ipStatusList! > %ipOutFile% 
echo Results saved to %ipOutFile%!
goto :eof
@end

var fileSysObj = new ActiveXObject("Scripting.FileSystemObject");
var ipInFileDir = WScript.Arguments(0);

try {
    // Scrapping Ips
    var ipInFile = fileSysObj.OpenTextFile(ipInFileDir, 1, "True");
    // Regular expression taken from stackoverflow.com
    var ips = ipInFile.ReadAll().match(/(?:(?:25[0-5]|2[0-4]\d|[01]?\d?\d{1})\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d?\d{1})/g);

    if (ips == null)
        WScript.Quit(1);

    // Writing scrapped IPs to temp file
    ipInFile = fileSysObj.OpenTextFile("temp.txt", 2, "True");
    
    for (var i = 0; i < ips.length; i++)
       ipInFile.WriteLine(ips[i]);
} catch (err) {
    WScript.Quit(1);
} finally {
    if (ipInFile != null) 
        ipInFile.close();
}
