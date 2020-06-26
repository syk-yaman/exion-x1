Set sh = CreateObject("WScript.Shell")
WScript.Sleep 8*1000
sh.AppActivate "window title"
sh.SendKeys "{F12}"