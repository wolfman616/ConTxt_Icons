#noenv
;#persistent
o:=comobjcreate("Shell.Application")
file=%1%
splitpath,file,file,directory
if errorlevel
	exitapp
SetWorkingDir %A_ScriptDir% 
od:=o.namespace(directory)
of:=od.parsename(file)
loop,286
	{
	if (PseudoArray%a_index%:=((append:=od.getdetailsof(of,a_index))?a_index " - " od.getdetailsof("",a_index) ": " append "":""))
		{
		PseudoArray:=PseudoArray%a_index%
		if a_index=1
			Pendage:=PseudoArray
		else
			Pendage=%Pendage%`n%PseudoArray%
		}
	}
FileAppend, % Pendage, %file%.txt
run, "%file%.txt"
FileDelete, %Result%
Return

/* 
#noenv
#persistent
o:=comobjcreate("Shell.Application")
Args=%1%
global arg:=args
if errorlevel
	Traytip Error Getting Dets,% errorlevel
else {
	SetWorkingDir %A_ScriptDir% 
	Deets:=filedetails(Arg)
	FileAppend, % Deets, %file%.txt
	Result="%file%.txt"
	Run, %Result%
	FileDelete, %Result%
}
Return

filedetails(file) {
splitpath,file,filename,directory
od:=o.namespace(directory)
of:=od.parsename(filename)
loop,286
	{
	if (PseudoArray%a_index%:=((append:=od.getdetailsof(of,a_index))?a_index " - " od.getdetailsof("",a_index) ": " append "":""))
		{
		PseudoArray:=PseudoArray%a_index%
		if a_index=1
			Pendage:=PseudoArray
		else
			Pendage=%Pendage%`n%PseudoArray%
		}
	}
Return Pendage
}
 */