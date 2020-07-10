extends Control

func _ready():
	$AnimationPlayer.play("animInstrucciones")

func _physics_process(delta):
	if Input.is_action_just_pressed("espacio"):
		ScriptGlobal.goto_scene("res://Red/InfoRegalos.tscn")
