extends Control

var scene_path_to_load

func _ready():
	if !ScriptGlobal.mutePrincipal:
		$MusicaFondo.play(ScriptGlobal.reproducir)
	$Menu/Jugar.grab_focus()
	for button in $Menu.get_children():
		button.connect("pressed",self,"_on_Button_pressed",[button.scene_to_load])

func _on_Button_pressed(scene_to_load):
#get_tree().change_scene(scene_to_load)
	scene_path_to_load = scene_to_load
	$CambioEscena.show()
	$CambioEscena.fade_in()
	#$CambioEscena.show()
	#$CambioEscena.Cambio_escena()

func _on_CambioEscena_fade_finished():
	if !ScriptGlobal.mutePrincipal:
			ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
	ScriptGlobal.goto_scene(scene_path_to_load)
#	get_tree().change_scene(scene_path_to_load)


func _on_Jugar_pressed():
	ScriptGlobal.partida_ready=true
	#scene_path_to_load = scene_to_load
	#$CambioEscena.show()
	#$CambioEscena.fade_in()
	
#func _on_Online_pressed(scene_to_load):
#	scene_path_to_load = scene_to_load
#	$CambioEscena.show()
#	$CambioEscena.fade_in()
#
#
#func _on_Ajustes_pressed(scene_to_load):
#	scene_path_to_load = scene_to_load
#	$CambioEscena.show()
#	$CambioEscena.fade_in()


func _on_Salir_pressed():
	get_tree().quit()


func _on_BotonMute_pressed():
	if !ScriptGlobal.mutePrincipal:
		ScriptGlobal.mutePrincipal = true
		ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
		$MusicaFondo.stop()
	else:
		ScriptGlobal.mutePrincipal = false
		$MusicaFondo.play(ScriptGlobal.reproducir)
