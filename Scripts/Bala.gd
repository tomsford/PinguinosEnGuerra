extends RigidBody2D

#var dir = 1
#var speed = 10
#const grav = 2

enum {
	ESTADO_QUIETO,
	ESTADO_TRANSFERIR,
	ESTADO_TOMADO,
	ESTADO_ARRASTRADO,
	ESTADO_RELEASED,
	ESTADO_LANZADO
	}

var estado = ESTADO_QUIETO
var velocidad_lineal
var pos_ini = position
var dp 
var impulso

func _integrate_forces(state):
	
#	var velocidad_ang = state.angular_velocity
#	var velocidad_lineal = state.linear_velocity
	var delta = 1 / state.step
	dp = position - pos_ini
	impulso = dp *0.06
#	print(velocidad_lineal * delta)
#	var diferencia_de_posicion = position - get_global_position()
#	match estado:
#		ESTADO_TRANSFERIR:
#			pass
#		ESTADO_TOMADO:
#			pass
#		ESTADO_ARRASTRADO:
#			var fuerza = get_global_mouse_position() - position
#			fuerza = fuerza.clamped(100)
#			velocidad_lineal = (fuerza + diferencia_de_posicion) * delta
#		ESTADO_RELEASED:
#			pass
#		ESTADO_LANZADO:
#			pass
	
	if dp.length() < impulso.length() / delta:
		pass
	else:
		state.linear_velocity = velocidad_lineal * delta
	#state.angular_velocity = velocidad_ang
	




var explosion = preload("res://Escenas/explosion.tscn")


func bang():
	var bang = explosion.instance()
	print("entro a bang")
	bang.position = global_position
	get_tree().get_root().add_child(bang)
	queue_free()
		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#func _process(delta):
	#var move = move_and_collide(Vector2(dir,speed*delta*grav))
	
#	if move != null:  #SIEMPRE QUE MOVE SEA != NULL ES PORQUE COLISIONO ENTONCES BORRO
#		self.queue_free()  

func _on_Bala_body_entered(body):
	bang()
