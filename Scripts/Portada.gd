extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	$Label/AnimationPlayer.play("Presiona_para_seguir")
	if Input.is_action_just_pressed("sacararma"):
		$CambioEscena.show()
		$CambioEscena.fade_in()

func _on_CambioEscena_fade_finished():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")
#	//get_tree().change_scene("res://Escenas/Menu/PantallaMenu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
