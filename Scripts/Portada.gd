extends Control


func _ready():
	$MusicaFondo.play(8.0)
	

func _physics_process(delta):
	$Label/AnimationPlayer.play("Presiona_para_seguir")
	if Input.is_action_just_pressed("espacio"):
		$CambioEscena.show()
		$CambioEscena.fade_in()

func _on_CambioEscena_fade_finished():
	ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")
#	//get_tree().change_scene("res://Escenas/Menu/PantallaMenu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
