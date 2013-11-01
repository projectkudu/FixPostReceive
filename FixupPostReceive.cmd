@if "%_echo%" neq "1" @echo off

setlocal
set _SCRIPT=%~nx0
set _SCMURI=%~1
set _CURLEXE=%ProgramFiles(x86)%\git\bin\curl.exe
set _POSTRECEIVE=post-receive
set _POSTRECEIVEFILE=%~dp0post-receive

REM first parameter is the deploy uri with embedded cred
if "%_SCMURI%" equ "" (
  call :USAGE 
  goto :EOF
)

if NOT EXIST "%_POSTRECEIVEFILE%" (
  @echo "%_POSTRECEIVEFILE%" does not exists!
  goto :EOF
)
REM remove any after .net
set _SCMURI=%_SCMURI:.net=&rem.%
set _SCMURI=%_SCMURI%.net
set _VFSPOSTRECEIVE=%_SCMURI%/vfs/site/repository/.git/hooks/%_POSTRECEIVE%
set _VFSPOSTRECEIVEBAK=%_SCMURI%/vfs/site/repository/.git/hooks/%_POSTRECEIVE%.bak

if NOT EXIST "%_CURLEXE%" (
  @echo "%_CURLEXE%" does not exists! 
  goto :EOF
)

@echo.
@echo Backup the current %_POSTRECEIVE% to "%TMP%\%_POSTRECEIVE%.bak"
@call "%_CURLEXE%" -k "%_VFSPOSTRECEIVE%" -o "%TMP%\%_POSTRECEIVE%.bak"

@echo.
@echo Upload the "%TMP%\%_POSTRECEIVE%.bak"
@call "%_CURLEXE%" -k "%_VFSPOSTRECEIVEBAK%" -X PUT -T "%TMP%\%_POSTRECEIVE%.bak" 1>NUL 2>&1

@echo.
@echo Upload the "%_POSTRECEIVEFILE%"
@call "%_CURLEXE%" -k "%_VFSPOSTRECEIVE%" -X PUT -T "%_POSTRECEIVEFILE%" --header "If-Match: *"

@echo.
@echo Done successfully!

exit /b 0

:USAGE
@echo usage: %_SCRIPT% "<scm_uri>"
exit /b 0
 
REM testing