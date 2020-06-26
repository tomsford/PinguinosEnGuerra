extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicaFondo.play(ScriptGlobal.reproducir)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Salir_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")

func _on_SiguienteNivel_pressed():
	print("entra a siguiente nivel")
	ScriptGlobal.goto_scene("res://Escenas/publicidad.tscn")


func _on_Monedas_pressed():
	ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
	ScriptGlobal.goto_scene("res://Escenas/UtilizarMonedas.tscn")
