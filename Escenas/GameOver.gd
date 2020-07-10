extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label/AnimationPlayer.play("GameOver")
	if !ScriptGlobal.LAN:
		$Puntuacion.text = "Puntuacion Final: " + str(ScriptGlobal.puntos)
func _physics_process(delta):
	#$Label/AnimationPlayer.play("Presiona_para_seguir")
	if Input.is_action_just_pressed("espacio"):
		ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")

