extends Node2D
export(PackedScene) var player
var caido = false

func _physics_process(delta):
	$RigidBody2D.position.x += 1
	
	if Input.is_action_pressed("caer") && !caido:
		var mob = player.instance()
		mob.position = $RigidBody2D/Position2D.global_position
		add_child(mob)
		caido = true
	
func _on_Button_pressed():
	get_tree().change_scene('res://Escenas/Menu/PantallaMenu.tscn')
