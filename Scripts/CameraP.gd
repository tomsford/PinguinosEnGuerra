extends Camera2D

var speed = 10.0


func _ready():
	pass # Replace with function body.

func _process(delta):
	
	var inpx = (int(Input.is_action_pressed("cam_der"))
					- int(Input.is_action_pressed("cam_izq")))
	
	var inpy = (int(Input.is_action_pressed("cam_down"))
					- int(Input.is_action_pressed("cam_up")))
	
	position.x = lerp(position.x, position.x + inpx * speed, speed * delta)
	position.y = lerp(position.y, position.y + inpy * speed, speed * delta)
	
	pass
