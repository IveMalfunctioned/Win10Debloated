Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & "C:\Program Files (x86)\Microsoft\Edge\uninstall\uninstall.cmd" & Chr(34), 0
Set WshShell = Nothing