#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#singleinstance force
#persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.


SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SplitPath, 1 , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	files :=""
	dirr=%OutDir%\*.*
	Loop %dirr%
		{
		files = %files%/%A_LoopFileName%
		}
clipboard = % files
exitapp



