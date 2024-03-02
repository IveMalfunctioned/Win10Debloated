@echo off
@setlocal DisableDelayedExpansion
if defined PROCESSOR_ARCHITEW6432 start %SystemRoot%\Sysnative\cmd.exe /c "%0 " &exit
set root=%cd%
set "u_path=%LocalAppData%\Microsoft"
set "s_path=%ProgramFiles(x86)%\Microsoft"
if /i %PROCESSOR_ARCHITECTURE%==x86 (if not defined PROCESSOR_ARCHITEW6432 (
  set "s_path=%ProgramFiles%\Microsoft"
  )
)


taskkill /im msedge.exe /f >NUL 2>&1
taskkill /im MicrosoftEdgeUpdate.exe /f >NUL 2>&1
taskkill /im identity_helper.exe /f >NUL 2>&1
sc stop "MicrosoftEdgeElevationService" >NUL 2>&1
sc stop "edgeupdate" >NUL 2>&1
sc stop "edgeupdatem" >NUL 2>&1

reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /v NoRemove /f 2>nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /v NoRemove /f 2>nul
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /v NoRemove /f 2>nul

for /D %%i in ("%u_path%\Edge SxS\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-sxs --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge Internal\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-internal --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge Dev\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-dev --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge Beta\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-beta --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\Edge\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%u_path%\EdgeWebView\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedgewebview --verbose-logging --force-uninstall --delete-profile
)

for /D %%i in ("%s_path%\EdgeWebView\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedgewebview --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge Beta\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-beta --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge Dev\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-dev --system-level --verbose-logging --force-uninstall --delete-profile
)
for /D %%i in ("%s_path%\Edge Internal\Application\*") do if exist "%%i\installer\setup.exe" (
start "" /w "%%i\installer\setup.exe" --uninstall --msedge-internal --system-level --verbose-logging --force-uninstall --delete-profile
)

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView" /f 2>nul

schtasks /delete /tn "MicrosoftEdgeUpdateTaskMachineCore" /f 2>nul
schtasks /delete /tn "MicrosoftEdgeUpdateTaskMachineUA" /f 2>nul
sc config "MicrosoftEdgeElevationService" start=disabled >NUL 2>&1
sc config "edgeupdate" start=disabled >NUL 2>&1
sc config "edgeupdatem" start=disabled >NUL 2>&1

takeown /f "C:\Windows\SystemApps\*MicrosoftEdge*" /a /r /d Y
icacls "C:\Windows\SystemApps\*MicrosoftEdge*" /grant Administrators:F /T /C
takeown /f "C:\Program Files\WindowsApps\*MicrosoftEdge*" /a /r /d Y
icacls "C:\Program Files\WindowsApps\*MicrosoftEdge*" /grant Administrators:F /T /C
takeown /f "C:\Program Files (x86)\Microsoft\Edge" /a /r /d Y
icacls "C:\Program Files (x86)\Microsoft\Edge" /grant Administrators:F /T /C
takeown /f "C:\Program Files (x86)\Microsoft\EdgeCore" /a /r /d Y
icacls "C:\Program Files (x86)\Microsoft\EdgeCore" /grant Administrators:F /T /C
takeown /f "C:\Program Files (x86)\Microsoft\EdgeUpdate" /a /r /d Y
icacls "C:\Program Files (x86)\Microsoft\EdgeUpdate" /grant Administrators:F /T /C
takeown /f "C:\Program Files (x86)\Microsoft\EdgeWebView" /a /r /d Y
icacls "C:\Program Files (x86)\Microsoft\EdgeWebView" /grant Administrators:F /T /C
sc delete "MicrosoftEdgeElevationService" >NUL 2>&1
sc delete "edgeupdate" >NUL 2>&1
sc delete "edgeupdatem" >NUL 2>&1
cd /d "C:\Windows\SystemApps\*MicrosoftEdge*" 2>nul && del /f /s /q * 2>nul
cd /d "C:\Program Files\WindowsApps\*MicrosoftEdge*" 2>nul && del /f /s /q * 2>nul
cd /d "C:\Program Files (x86)\Microsoft\Edge" 2>nul && del /f /s /q * 2>nul
cd /d "C:\Program Files (x86)\Microsoft\EdgeCore" 2>nul && del /f /s /q * 2>nul
cd /d "C:\Program Files (x86)\Microsoft\EdgeUpdate" 2>nul && del /f /s /q * 2>nul
cd /d "C:\Program Files (x86)\Microsoft\EdgeWebView" 2>nul && del /f /s /q * 2>nul

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\MSEdgeHTM" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\MSEdgeMHT" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\MSEdgePDF" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.htm" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.html" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.mht" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.mhtml" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.pdf" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.shtml" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.svg" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.webp" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.xht" /f 2>nul
reg delete "HKEY_CLASSES_ROOT\.xhtml" /f 2>nul

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.htm" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.html" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.mht" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.mhtml" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.pdf" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.svg" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.shtml" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.webp" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.xht" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.xhtml" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MSEdgeHTM" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MSEdgeMHT" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MSEdgePDF" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Clients\StartMenuInternet\Microsoft Edge" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main\EnterpriseMode" /v MSEdgePath /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MediaPlayer\ShimInclusionList\msedge.exe" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_microsoft-edge /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Clients\StartMenuInternet\Microsoft Edge" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}\Commands\on-os-upgrade" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\EventLog\Application\Edge" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\EventLog\Application\edgeupdate" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\EventLog\Application\edgeupdatem" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\Edge" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\edgeupdate" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\edgeupdatem" /f 2>nul

reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.htm" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mht" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mhtml" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pdf" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.shtml" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.svg" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.webp" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xht" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xhtml" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.htm /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.html /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.mht /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.mhtml /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.svg /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.webp /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.http /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.https /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.mailto /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.read /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.pdf /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\microsoft-edge" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\microsoft-edge-holographic" /f 2>nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /v "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" /f 2>nul

reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.htm" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mht" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mhtml" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pdf" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.shtml" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.svg" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.webp" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xht" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.xhtml" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.htm /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.html /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.mht /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.mhtml /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.svg /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.webp /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.http /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.https /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.mailto /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.read /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v MSEdgeHTM_.pdf /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\microsoft-edge" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\microsoft-edge-holographic" /f 2>nul
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /v "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" /f 2>nul
reg unload "hku\Default"

del /f /q "%AppData%\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge*.lnk" 2>nul
del /f /q "%SystemRoot%\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge*.lnk" 2>nul
del /f /q "%HOMEPATH%\Desktop\Microsoft Edge*.lnk" 2>nul
del /f /q "%USERPROFILE%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge*.lnk" 2>nul
del /f /q "%USERPROFILE%\Desktop\Microsoft Edge*.lnk" 2>nul
del /f /q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge*.lnk" 2>nul
cd /d "%root%"
WIMTweak.exe /o /l
WIMTweak.exe /o /c Microsoft-Windows-Internet-Browser-Package /r
WIMTweak.exe /h /o /l

reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v DoNotUpdateToEdgeWithChromium /t REG_DWORD /d 1 /f 1>nul