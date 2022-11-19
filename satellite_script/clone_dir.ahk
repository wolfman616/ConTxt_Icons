#noEnv ; #warn
sendMode Input

clsidTHISpc:="::{20d04fe0-3aea-1069-a2d8-08002b30309d}"
	slash := "\"

Thread, NoTimers
FileSelectFolder, destpath, %clsidTHISpc% , 4, % " fuck off "
Thread, NoTimers, false
if !destpath
	exitapp
	
SplitPath, 1 ,OutFileName, OutDir
StringLen, L, destpath
if L < 4
	slash := ""
a = "%1%" "%destpath%%slash%%OutFileName%" /COPYall /S /SL /XJD   ;/XJD :: eXclude Junction points and symbolic links for Directories.
msgbox copying %1%\ to "%destpath%%slash%%OutFileName%\"
ifmsgbox ok,{
	runwait %comspec% /C robocopy %a%,,hide
	msgbox done
}
return

