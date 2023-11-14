#NoEnv
SetBatchLines, -1
#Include, C:\Users\avons\Code\AHK_Ergodox\Lib\Socket.ahk
global port := config.tcp_server.port

gosub, startserver
return

startserver:
rip := getIP()
OutputDebug, % rip ":" port
Server := new SocketTCP()
Server.OnAccept := Func("OnAccept")
Server.Bind([rip, port])
Server.Listen()
return

getIP() {
	objWMIService := ComObjGet("winmgmts:\\.\root\cimv2")
	colItems := objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration WHERE IPEnabled = True")._NewEnum
	while colItems[objItem]
		loop,4 
	    if (objItem.IPAddress[0] == A_IPAddress%a_index%) and !(objItem.DefaultIPGateway[0] = 0)
			return A_IPAddress%a_index%
	return
}

OnAccept(Server) {
	Sock := Server.Accept()
	ServerLoop(Sock)
    ExitApp
}

ServerLoop(Sock) {
	while (true){
		message := Sock.RecvText()
		if (message) {
			OutputDebug, % message
		}
		Sleep, 100
	}
	Sock.Disconnect()
}