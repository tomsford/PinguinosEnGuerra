extends Control

func _ready():
	$Label/AnimationPlayer.play("Victoria")
	$firework2/AnimationPlayer.play("firework2")
	$AudioStreamPlayer.play(0.20)
	
func _physics_process(delta):
	#$Label/AnimationPlayer.play("Presiona_para_seguir")
	if Input.is_action_just_pressed("espacio"):
		#Ir a la escena que llega con la familia y despues
		#Ir a la escena que diga el puntaje final
		ScriptGlobal.reproducirV = $AudioStreamPlayer.get_playback_position()
		if !ScriptGlobal.LAN:
			ScriptGlobal.goto_scene("res://Escenas/EscenaFinal.tscn")
		else:
			ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")

