#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard

if winexist("ahk_exe sidebar.exe") {
	run C:\Apps\Kill.exe sidebar.exe,, hide
} else {
	SidebarPath:="C:\Program Files\Windows Sidebar\sidebar.exe"
	run % SidebarPath,, hide
}
return

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
settimer tooloff, -1700
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return

tooloff:
tooltip
return