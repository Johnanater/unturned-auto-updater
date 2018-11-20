; =-= Auto Update for Unturned =-=
;     =-=Made by Johnanater=-=

; Set variables from config
$servers = StringSplit ( IniRead("config.ini", "Config", "Servers", "ValueNotFound"), "," ) 
$serverDir = IniRead("config.ini", "Config", "Directory", "ValueNotFound")
$serverLnks = StringSplit(IniRead("config.ini", "Config", "ServerLnks", "ValueNotFound"), ",")

; Start the servers
For $s = 1 To $serverLnks[0]
	Run(@ComSpec & ' /c ' & 'cd /d ' & $serverDir & ' & ' & 'start ' & $serverLnks[$s], @TempDir, @SW_HIDE)
Next