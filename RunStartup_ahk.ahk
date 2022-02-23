#NoEnv
#singleinstance force
Desired=.ahk
OutDir:="C:\Users\ninj\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
SetWorkingDir %OutDir%  ; Ensures a consistent starting directory.
files :=""
Array := []
Loop %OutDir%\*.*
	Array.Push(A_LoopFileName)
Loop % Array.MaxIndex()
	{
	FOR_EVERY_FILE_IN_FOLDER:=Array[A_Index]
	if FoundPos := InStr(FOR_EVERY_FILE_IN_FOLDER, Desired , CaseSensitive := true, StartingPos := 1) {
		Nigger_Run:= Array[A_Index] 
		Run %Nigger_Run%
		sleep 50
	}
}