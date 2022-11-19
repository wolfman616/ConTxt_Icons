dims:="ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "
dfile="S:\IN\- Torrents\The Fly (1986) [1080p]\The.Fly.1986.1080p.BluRay.x264.YIFY.mp4"
MsgBox % ComObjCreate("WScript.Shell").Exec(dims dfile).StdOut.ReadAll()
