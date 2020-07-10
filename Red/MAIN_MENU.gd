extends Control
#BUTTONS FROM MAIN PANEL
func _on_Create_pressed():
	$"Main Panel".visible = false
	$"SERVER PANEL".visible = true

func _on_Join_pressed():
	$"Main Panel".visible = false
	$"CLIENT PANEL".visible = true
	UDP._listen_udp() #Start to Listen for server
	set_process(true)

# warning-ignore:unused_argument
func _process(delta):
	var ip = UDP._wait_for_udp_message()
	if ip != null:
		$"CLIENT PANEL/VBoxContainer/Status".text = "SERVIDOR ENCONTRADO"
		Network.IP = ip
		$"CLIENT PANEL/VBoxContainer/START CLIENT".disabled = false
		set_process(false)

#BUTTONS FROM SERVER PANEL
func _on_Cant_Players2_pressed():
	_startServer(1)
func _on_Cant_Players3_pressed():
	#aqui se pondra la opcion de comercializacion
	#_startServer(2)
	pass
func _on_Cant_Players4_pressed():
	#aqui se pondra la opcion de comercializacion
	#_startServer(3)
	pass
func _startServer(cant_players):
	$"SERVER PANEL".visible = false
	if cant_players <3:
		$"PLAYERS PANEL/VBoxContainer/Player4_Status".queue_free()
	if cant_players <2:
		$"PLAYERS PANEL/VBoxContainer/Player3_Status".queue_free()
	$"PLAYERS PANEL".visible = true
	Network.CANT_PLAYERS = cant_players
	Network.create_server()

#BUTTONS FROM CLIENT PANEL
func _on_START_CLIENT_pressed():
	Network.connect_to_server(Network.IP)
	$"CLIENT PANEL/VBoxContainer/START CLIENT".disabled = true

#BUTTONS FROM PLAYERS PANEL
func _on_Player2_Status_pressed():
	Network.wait2 = 1
	UDP._broadcast_udp()
	$"PLAYERS PANEL/VBoxContainer/Player2_Status".text = "ESPERANDO"

func _on_Player3_Status_pressed():
	Network.wait3 = 1
	UDP._broadcast_udp()
	$"PLAYERS PANEL/VBoxContainer/Player3_Status".text = "ESPERANDO"

func _on_Player4_Status_pressed():
	Network.wait4 = 1
	UDP._broadcast_udp()
	$"PLAYERS PANEL/VBoxContainer/Player4_Status".text = "ESPERANDO"

func _on_Players_ready():
	if Network.wait2 == 2:
		$"PLAYERS PANEL/VBoxContainer/Player2_Status".text = "PREPARADO"
		$"PLAYERS PANEL/VBoxContainer/Player2_Status".disabled = true
	if Network.wait3 == 2:
		$"PLAYERS PANEL/VBoxContainer/Player3_Status".text = "PREPARADO"
		$"PLAYERS PANEL/VBoxContainer/Player3_Status".disabled = true
	if Network.wait4 == 2:
		$"PLAYERS PANEL/VBoxContainer/Player4_Status".text = "PREPARADO"
		$"PLAYERS PANEL/VBoxContainer/Player4_Status".disabled = true
	if Network.players_IDS.size()==Network.CANT_PLAYERS +1: #EVERYTHING OK
		$"PLAYERS PANEL/VBoxContainer/START SERVER".text = "LISTOS!"
		$"PLAYERS PANEL/VBoxContainer/START SERVER".disabled = false

func _on_START_SERVER_pressed():
	Network.call_all_peers_start()

func _on_Start_Scene():
	ScriptGlobal.goto_scene("res://Escenas/EscenaSeleccion.tscn")
	#print(get_tree().change_scene("res://Escenas/Menu/Instrucciones.tscn"))
	ScriptGlobal.LAN =true


func _on_BotonAtras_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")


func _on_LineEdit_text_entered(new_text):
	$"Main Panel/VBoxContainer/HBoxContainer".visible = false
	$"Main Panel/VBoxContainer/Create".visible = true
	$"Main Panel/VBoxContainer/Join".visible = true


func _on_LineEdit_text_changed(new_text):
	ScriptGlobal.miNombre = new_text
	print(ScriptGlobal.miNombre)
