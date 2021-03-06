@if (@CodeSection == @Batch) @then
:: https://www.dostips.com/forum/viewtopic.php?f=3&t=5661


@echo off
setlocal EnableDelayedExpansion

if "%~1" equ "newCmd" goto newCmd

rem Multi-line menu with options selection via DOSKEY
rem Antonio Perez Ayala

rem Set title for AppActivate
title Select option

rem Define the options
set numOpts=0
for %%a in ("Calculator=calc" "Notepad=notepad" "Paint=mspaint" "Explorer=explorer") do (
   for /F "tokens=1,2 delims==" %%b in (%%a) do (
      set /A numOpts+=1
      set "option[!numOpts!]=%%b"
      set "app[%%b]=%%c"
   )
)
set /A numOpts+=1
set "option[!numOpts!]=Quit"


rem Options selection loop
:nextOpt
cmd /C "%~F0" newCmd
if errorlevel 1 goto nextOpt
goto :EOF


:newCmd

rem Clear previous doskey history
doskey /REINSTALL
rem Fill doskey history with menu options
cscript //nologo /E:JScript "%~F0" %numOpts%
for /L %%i in (1,1,%numOpts%) do set /P "="

cls
echo MULTI-LINE MENU WITH OPTIONS SELECTION
echo/
rem Send a F7 key to open the selection menu
cscript //nologo /E:JScript "%~F0"
rem Read the option
set /P "option=Select the desired option: "
echo/
set "continue=1"
if defined app[%option%] (
   start !app[%option%]!
) else (
   set "continue=0"
)
exit %continue%


@end

var wshShell = WScript.CreateObject("WScript.Shell"),
    envVar = wshShell.Environment("Process");

// Select the cmd.exe window
wshShell.AppActivate("Select option");
WScript.Sleep(300);

if ( WScript.Arguments.Length ) {
   // Send menu options to fill the menu
   var numOpts = parseInt(WScript.Arguments(0));
   for ( var i=1; i <= numOpts; i++ ) {
      wshShell.SendKeys(envVar("option["+i+"]")+"{ENTER}");
   }
} else {
   // Send a F7 to open the menu
   wshShell.SendKeys("{F7}");
}