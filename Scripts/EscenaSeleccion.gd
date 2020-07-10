extends Control

var scene_path_to_load

func _ready():
	pass

	
func _on_Atras_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")


func _on_CambioEscena_fade_finished():
	ScriptGlobal.goto_scene("res://Red/Lobby.tscn")


func _on_Amarillo_pressed():
	ScriptGlobal.pinguino = 1
	if ScriptGlobal.LAN:
		var data = {
			color = 1,
			nombre = ScriptGlobal.miNombre
		}
		Network.sendColor(data)
	$CambioEscena.show()
	$CambioEscena.fade_in()

func _on_Rosa_pressed():
	ScriptGlobal.pinguino = 2
	if ScriptGlobal.LAN:
		var data = {
			color = 2,
			nombre = ScriptGlobal.miNombre
		}
		Network.sendColor(data)
	$CambioEscena.show()
	$CambioEscena.fade_in()

func _on_Verde_pressed():
	ScriptGlobal.pinguino = 3
	if ScriptGlobal.LAN:
		var data = {
			color = 3,
			nombre = ScriptGlobal.miNombre
		}
		Network.sendColor(data)
	$CambioEscena.show()
	$CambioEscena.fade_in()
	

func _on_Gris_pressed():
	ScriptGlobal.pinguino = 4
	if ScriptGlobal.LAN:
		var data = {
			color = 4,
			nombre = ScriptGlobal.miNombre
		}
		Network.sendColor(data)
	$CambioEscena.show()
	$CambioEscena.fade_in()
