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
var Id_enemy=0
var posIniX=0
var posIniY=0
var actualizarPosTurno=false
var dispararEnemy=false
var armaEnemy=0
var crearBala=false
var lineaBala
var escalaEnemy
var dispararBala = false
var direccionEnemy = 0

var readyMapa = false
var readyMapa2 = false
var crearArmas = false
var posArmas = []
var posArmasD = []
var crearRegalos = false
var posRegalos = []
var posRegalosD = []

var colorEnemy = 1

####DAnOS
var id_lastimado=0
var llegoDano=false
var dano=0
var vida_enemy=200
var actualizar_vida_enemy=false



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
	print("ID = = = = = = ")
	print(local_player_id)
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
		#escalaEnemy=data.escala
		direccionEnemy = data.direccion
	#get_tree().get_nodes_in_group("movement_receiver")[0]._initialize()
	
func sendDisparo(data):
	rpc("getDisparo",data)
remote func getDisparo(data):
	if Network.last_movement_id != Network.local_player_id:
		print("tiene q disparar enemy (network)")
		dispararEnemy = data.disparo
		armaEnemy = data.arma
	
func sendCambiarTurno():
	if get_tree().has_network_peer():
		rpc("cambiarTurno")
		var data = {
			id = local_player_id,
			posx=ScriptGlobal.posx,
			posy=ScriptGlobal.posy
		}
		rpc ("get_posFija",data)

remotesync func cambiarTurno():
	var last = Network.players_IDS.find(Network.last_movement_id)
	if last == CANT_PLAYERS:
		last = 0
	else:
		last +=1
	last_movement_id=Network.players_IDS[last]	 
	ScriptGlobal.tiempoMultiJugador =20
		
func sendInstanciarBala(data):
	if ScriptGlobal.LAN:
		rpc("instanciarBala",data)

remote func instanciarBala(data):
	
	print ("instanciar bala network")
	crearBala =true
	lineaBala = data
	dispararBala = true

func send_armas(data):
	if get_tree().has_network_peer():
		rpc("get_armas", data) #Call to B
		print("entra a mandar armas")

remote func get_armas(data):
	print("llegan las armas")
	posArmas = data.posiciones
	posArmasD = data.posicionesD
	crearArmas = true

func send_regalos(data):
	if get_tree().has_network_peer():
		rpc("get_regalos", data) #Call to B
		print("entra a mandar regalos")

remote func get_regalos(data):
	posRegalos = data.posiciones
	posRegalosD = data.posicionesD
	print("llegan los regalos")
	crearRegalos = true
remote func send_ListoMapa():
	if get_tree().has_network_peer():
		rpc("get_ListoMapa") #Call to B
		
remote func get_ListoMapa():
	if Network.players_IDS[0] == Network.local_player_id :
			Network.readyMapa2 = true
	else :
			Network.readyMapa = true

func sendColor(data):
	rpc("getColor",data)
remote func getColor(data):
	colorEnemy = data.color
	ScriptGlobal.nombreEnemy = data.nombre

remote func get_posFija(data):
	Id_enemy=data.id
	posIniX=data.posx
	posIniY=data.posy
	actualizarPosTurno=true
func send_Dano(data):
	if get_tree().has_network_peer():
		rpc("get_dano", data) #Call to B
remote func get_dano(data):
	if data.id != Network.local_player_id:
		id_lastimado=data.id
		llegoDano=true
		dano=data.dano

func send_cambioVida(data):
	if get_tree().has_network_peer():
		rpc("get_cambioVida", data) #Call to B
		
remote func get_cambioVida(data):
	vida_enemy=data.vida
	actualizar_vida_enemy=true
