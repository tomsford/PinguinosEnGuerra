extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Network.readyMapa && Network.readyMapa2 :
		get_tree().paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
