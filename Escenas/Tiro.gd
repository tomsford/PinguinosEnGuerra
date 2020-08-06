extends Node2D

var gravity = -9.8
var num_of_points = 75
export (float,100) var strength = 30.0 setget set_strength
var aiming = false
var ver = false
var contacto = false

var cantSoltado = 0

var bloqueo = 0

func _input(event):
	if bloqueo <= 2:
		
		if event.is_action_pressed("lefft_mouse"):
			aiming = true
			ScriptGlobal.apuntando = true
			bloqueo += 1
		if event.is_action_released("lefft_mouse"):
			bloqueo += 1
			cantSoltado += 1
			if cantSoltado == 2:
				aiming = false
				ScriptGlobal.apuntando = false
				ver = true
			
				if $Bala != null:
					$Bala.visible = true
				$Line2D.visible = false #Comentar esta linea para probar linea en pc
				
				if ScriptGlobal.arma == 1:
					if !ScriptGlobal.mute:
						$RuidoBala.play()
				elif ScriptGlobal.arma == 2:
					if !ScriptGlobal.mute:
						$RuidoBazuca.play()
				if ScriptGlobal.arma == 3 : 
					$Bala/AnimationPlayer.play("molotovTirada") 
				elif ScriptGlobal.arma == 4 :
					$Bala/AnimationPlayer.play("bombaTirada")
				else:
					if ScriptGlobal.disparo == 1:
						if $Bala != null:
							$Bala/AnimationPlayer.play("caida")
					else:
						if $Bala != null:
							$Bala/AnimationPlayer.play("caidaIzq") #izquierda
				mover()
				cantSoltado = 0
			
	if aiming:
		if event is InputEventMouseMotion:
			self.strength += event.relative.x / 5.0

func mover():
	#var contacto = false
	
	var envioPuntos = PoolVector2Array()
	envioPuntos = $Line2D.points
	#print("puntos en linea")
	#print($Line2D.points)
	#print("puntos en envioPuntos")
	#print(envioPuntos)
	if Network.local_player_id == Network.last_movement_id:
		Network.sendInstanciarBala(envioPuntos)
	for point in $Line2D.points:
		#contacto = $Bala.get_contacto()
		#print(contacto)
		
		var t = Timer.new()
		t.set_wait_time(0.025)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		if !contacto:
			$Bala.position = point
		if contacto:
			$Line2D.points = []
			self.queue_free()


func _physics_process(delta):
	if Network.dispararBala:
		moverBalaEnemy(Network.lineaBala)
	else:
		#if !ver:
			#$Bala.visible = false
		if aiming:
			if ScriptGlobal.disparo == 1:
				$Pivot.rotation = $Pivot.global_position.angle_to_point(get_global_mouse_position()) + 5*PI/6
			else:
				$Pivot.rotation = $Pivot.global_position.angle_to_point(get_global_mouse_position()) + PI/6

func moverBalaEnemy(puntos):
	#var contacto = false
	#Network.sendInstanciarBala($Line2D.points)
	#print("PUNTOSSSSS")
	#print(puntos)
	Network.dispararBala = false
	
	for point in puntos:
		#contacto = $Bala.get_contacto()
		#print(contacto)
		
		var t = Timer.new()
		t.set_wait_time(0.025)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		if !contacto:
			$Bala.position = point
		if contacto:
			puntos = []
			self.queue_free()
			get_tree().get_nodes_in_group("enemigo")[0]._disparar()
			
			
	
	self.queue_free()
	#Network.sendCambiarTurno()

func calculate_trajectory():
	var points = []
	var total_air_time = 20.0
	var x_component
	if ScriptGlobal.disparo == 1:
		x_component = strength * cos($Pivot.rotation * -1.0)
	else: 
		x_component = strength * cos($Pivot.rotation * -1.0)
	var y_component = strength * sin($Pivot.rotation * -1.0)
	for point in num_of_points:
		var time = total_air_time * point / num_of_points
		var dx = time * x_component
		var dy = -1.0 * (time * y_component + 0.5 * gravity * time * time)
		
		points.append(Vector2(dx,dy))
	
	$Line2D.points = points

func set_strength(num):
	strength = num
	clamp(strength,0.0,100.0)
	
#	if $Pivot/TextureProgress:
#		$Pivot/TextureProgress.value = num
	
	calculate_trajectory()

func _on_Bala_body_entered(body):
	contacto = true
	bloqueo = 0

