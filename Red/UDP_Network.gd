extends Node
#Variables UDP
var _udp = PacketPeerUDP.new()
const UDP_PORT = 5555
const UDP_KEY = "clavedemiaplicacion"
var UDP_CLIENT=""

#FUNCIONES UDP
#CLIENT SIDE
func _listen_udp(): 
	_udp.listen(UDP_PORT)
	
func _wait_for_udp_message():
	while _udp.get_available_packet_count() > 0:
		var clave = _udp.get_var()
		var _ip = _udp.get_packet_ip()
		var port = _udp.get_packet_port()
		if UDP_CLIENT == "" and clave == UDP_KEY:# 
			# New real Client 
			UDP_CLIENT = _ip + ":" + str(port)
			print("UDP SERVER FOUND AT "+UDP_CLIENT)
			#I found de IP! ;)
			return _ip
	return null
#SERVER SIDE
func _broadcast_udp():
	_udp.set_broadcast_enabled(true) # Necessary from Godot 3.2
	_udp.set_dest_address("255.255.255.255",UDP_PORT)
	_udp.put_var(UDP_KEY)
