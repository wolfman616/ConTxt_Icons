#noEnv ; #warn
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
;				8==========D~ ~ ~ ~				;
;					Start	...		;]						;

assfags="C:\Windows\system32\rundll32.exe" shell32.dll,Control_RunDLL desk.cpl,screensaver,@screensaver
run %comspec% /C %assfags%,, hide

return,

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return