call .\deploy-dependencies.bat
copy .\OVIMEUI\Release\OVIMEUI.dll %WINDIR%\system32\
copy .\OVIME\Release\ovime.ime %WINDIR%\system32\
copy .\OVPreferences\Release\OVPreferences.exe %WINDIR%\OpenVanilla\
copy .\OVPreferences\Release\OVPreferences.exe.manifest %WINDIR%\OpenVanilla\
copy ..\..\Modules\OVIMTobacco\Release\OVIMTobacco.dll %WINDIR%\OpenVanilla\Modules\
pause