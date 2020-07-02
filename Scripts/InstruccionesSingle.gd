extends Control

func _ready():
	if !ScriptGlobal.mutePrincipal:
		$MusicaFondo.play(ScriptGlobal.reproducir)

func _physics_process(delta):
	if Input.is_action_just_pressed("espacio"):
		if !ScriptGlobal.mutePrincipal:
			ScriptGlobal.reproducir = $MusicaFondo.get_playback_position()
		ScriptGlobal.goto_scene("res://Escenas/MapaSinglePlayer.tscn")
