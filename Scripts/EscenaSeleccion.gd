extends Control

var scene_path_to_load

func _ready():
	pass

	
func _on_Atras_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")


func _on_CambioEscena_fade_finished():
	ScriptGlobal.goto_scene("res://Escenas/Mapa1.tscn")


func _on_Amarillo_pressed():
	ScriptGlobal.pinguino = 1
	$CambioEscena.show()
	$CambioEscena.fade_in()

func _on_Rosa_pressed():
	ScriptGlobal.pinguino = 2
	$CambioEscena.show()
	$CambioEscena.fade_in()

func _on_Verde_pressed():
	ScriptGlobal.pinguino = 3
	$CambioEscena.show()
	$CambioEscena.fade_in()
	

func _on_Gris_pressed():
	ScriptGlobal.pinguino = 4
	$CambioEscena.show()
	$CambioEscena.fade_in()
