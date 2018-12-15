; =-= Auto Update for Unturned =-=
;     =-=Made by Johnanater=-=

; Set variables from config
$servers = StringSplit ( IniRead("config.ini", "Config", "Servers", "ValueNotFound"), "," ) 
$saveMessage = IniRead("config.ini", "Config", "SaveMessage", "ValueNotFound")
$shutdownMessage = IniRead("config.ini", "Config", "ShutdownMessage", "ValueNotFound")
$shutdownTime = IniRead("config.ini", "Config", "ShutdownTime", "ValueNotFound")
$shutdownKickMessage = IniRead("config.ini", "Config", "ShutdownKickMessage", "ValueNotFound")

; Send the messages
For $s = 1 To $servers[0]
	If WinActivate($servers[$s]) Then
		Send("save{ENTER}", 0)
		Send("say """ & $saveMessage , 1 )
		Send("""{ENTER}", 0)
	EndIf
Next

Sleep($shutdownTime)

For $s = 1 To $servers[0]
	If WinActivate($servers[$s]) Then
		Send("save{ENTER}", 0)
		Send("say """ & $shutdownMessage , 1 )
		Send("""{ENTER}", 0)
		Send("shutdown 5 """ & $shutdownKickMessage & """{ENTER}", 0)
	EndIf
Next