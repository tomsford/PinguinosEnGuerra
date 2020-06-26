extends Control

func _ready():
	$MusicaFondo.play(ScriptGlobal.reproducir)

func _physics_process(delta):
	if Input.is_action_just_pressed("espacio"):
		ScriptGlobal.goto_scene("res://Escenas/MapaSinglePlayer.tscn")
