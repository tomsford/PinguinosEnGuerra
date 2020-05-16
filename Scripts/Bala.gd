extends RigidBody2D

var explosion = preload("res://Escenas/explosion.tscn")

# PARTE EXPLOSION BALA
func bang():
	visible = false
	var bang = explosion.instance()
	bang.position = global_position
	get_tree().get_root().add_child(bang)
	queue_free()
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bala_body_entered(body):
	bang()
