extends Area2D

func _on_Area2D_body_entered(body):
	if body.get_name() == 'RigidBody2D':
		var camara = body.get_cam()
		CamaraGeneral._zeppelinFin(camara)
		Network.ready1=true
		body.visible = false
		
