extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if !ScriptGlobal.mutePrincipal:
		$MusicaFondo.play(ScriptGlobal.reproducir)

func _on_Salir_pressed():
	if !ScriptGlobal.mutePrincipal:
			ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")


func _on_Comenzar_pressed():
	if !ScriptGlobal.mutePrincipal:
			ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
	ScriptGlobal.goto_scene("res://Escenas/historiaSingle.tscn")

func _on_TextureButton_pressed():
	if !ScriptGlobal.mutePrincipal:
		ScriptGlobal.mutePrincipal = true
		ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
		$MusicaFondo.stop()
	else:
		ScriptGlobal.mutePrincipal = false
		$MusicaFondo.play(ScriptGlobal.reproducir)
