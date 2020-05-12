extends RigidBody2D

enum {
	ESTADO_QUIETO,
	ESTADO_ARRASTRADO,
	ESTADO_RELEASED,
	ESTADO_LANZADO
	}
	
var disparo = true
var estado = ESTADO_QUIETO
var dif_de_posicion = position - get_global_mouse_position()
var impulso = null

func _integrate_forces(state):
	if (estado != ESTADO_QUIETO):
		var velocidad_ang = state.angular_velocity
		var velocidad_lineal = state.linear_velocity
		var delta = 1 / state.step
		dif_de_posicion = position - get_global_mouse_position()
		if Input.is_action_just_released("lefft_mouse") and disparo:
			disparo = false
			visible = true
			estado = ESTADO_RELEASED
			impulso = dif_de_posicion *0.06 #obtener_impulso()# diferencia_de_posicion *0.06
		match estado:
			ESTADO_ARRASTRADO:
				var fuerza = get_global_mouse_position() - position
				velocidad_lineal = (fuerza + dif_de_posicion) * delta
			ESTADO_RELEASED:
				if dif_de_posicion.length() < impulso.length():
					estado = ESTADO_LANZADO
				else:
					velocidad_lineal = impulso * delta
			ESTADO_LANZADO:
				pass 
		state.linear_velocity = velocidad_lineal
		state.angular_velocity = velocidad_ang
	else:
		set_can_sleep(true)


func _input(event):
	if event.is_action_pressed("lefft_mouse") and disparo:
		set_can_sleep(false)
		estado = ESTADO_ARRASTRADO


# PARTE EXPLOSION BALA

var explosion = preload("res://Escenas/explosion.tscn")

func bang():
	var bang = explosion.instance()
	bang.position = global_position
	get_tree().get_root().add_child(bang)
	queue_free()
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bala_body_entered(body):
	bang()
