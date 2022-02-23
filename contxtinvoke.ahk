#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

Path := "C:\Users\ninj\DESKTOP\opusnew"
ShellContextMenu(Path, hWnd := 0)
return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
