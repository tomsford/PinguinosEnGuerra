extends Node
#CLIENT VARIABLES
const DEFAULT_PORT = 20222
var IP = "127.0.0.1"
var local_player_id = 1
var last_movement_id = 1
var mi_data ={
	buttons = [1,0,0,0,0,1,0,0,0,0,1,0]
}
#SERVER VARIABLES
#STRUCTURE DATA
var players = {}
var players_IDS =[]
var CANT_PLAYERS = 1
#PLAYERS FLAGS
var wait2=0
var wait3=0
var wait4=0


##players info
var miPos=Vector2()
var enemyPos = Vector2()
var ready1 =false
var ready2 =false
var posIniX=0
var posIniY=0
#CLIENT FUNCTIONS
#Cuando un cliente quiere conectarse al servidor
func connect_to_server(server_ip):# ORDER 01
# warning-ignore:return_value_discarded
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	OS.delay_msec(1000)
	peer.create_client(server_ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

#Cliente pudo conectarse al servidor
func _connected_to_server():# ORDER 02
	local_player_id = get_tree().get_network_unique_id()
	rpc('_add_player_first_data', local_player_id, mi_data)#Call to 03

remotesync func _start_from_client(p, ids):# ORDER 04
	players = p
	players_IDS = ids
	get_tree().get_nodes_in_group("Menu")[0]._on_Start_Scene()

func send_movement(data):
	if get_tree().has_network_peer():
		rpc('_get_movement', data) #Call to B

#SERVER FUNCTIONS
func create_server():# ORDER 00
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, CANT_PLAYERS)
	get_tree().set_network_peer(peer)
	#Add server as peer
	randomize()
	mi_data.buttons.shuffle()
	#Server network unique id will always be 1
	players[1] = mi_data
	players_IDS.append(1)

remote func _add_player_first_data(id, data):# ORDER 03
	if wait2 == 1 or wait3 == 1 or wait4 == 1:
		randomize()
		data.buttons.shuffle()
		players[id] = data
		players_IDS.append(id)
		if wait2 == 1:
			wait2=2
		if wait3 == 1:
			wait3=2
		if wait4 == 1:
			wait4=2
		get_tree().get_nodes_in_group("Menu")[0]._on_Players_ready()

func call_all_peers_start():
	rpc("_start_from_client",players,players_IDS)

remotesync func _get_movement(data):
	last_movement_id = get_tree().get_rpc_sender_id()
	#players[data.player].buttons[data.button] = data.newState
	if(data.player != local_player_id && posIniX==0 && posIniY==0):
		posIniX = data.posx
		posIniY= data.posy
		if data.piso && !ready2:
			ready2=true
			print ("cambie ready 2")
	if(data.player != local_player_id && ScriptGlobal.partida_ready):
		enemyPos=Vector2(data.posx,data.posy)
	#get_tree().get_nodes_in_group("movement_receiver")[0]._initialize()
	
