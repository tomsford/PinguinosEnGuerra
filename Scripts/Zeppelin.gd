extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _chauCam():
	$Camera2D.clear_current()
	get_parent().get_node("CameraP").make_current()
