extends KinematicBody2D

var posicao = Vector2()
const gravity = 9.8
const grav= Vector2(0,-1)
var caminar= true
var disparo  = false
var cooldown = false
var cayo = false
var flipeo = 10
export var saltar = -350
export var desplazar = 100
export var balasBazuca = 0
export var potenciador = 0
export var tirosBombas = 0
export var vida = 200
var flipeoBombas = 10
var id = 0
var soyEnemy = false
var ready = false
var movimiento = Vector2()

var cayoEnemy = false
var disparoBomba = false
var cantB = 0

var bala = load("res://Escenas/Bala.tscn")
var balaBazuca = load("res://Escenas/BalaBazuca.tscn")
var balaMolotov = load("res://Escenas/BalaMolotov.tscn")
var balaBomba = load("res://Escenas/BalaBomba.tscn")


func _physics_process(delta):
	
	#ScriptGlobal.speed = "Speed = " + str(desplazar)
	#ScriptGlobal.tiros = "Tiros = " + str(tirosBombas)
	#ScriptGlobal.salto = "Salto = " + str(saltar)
	#ScriptGlobal.potenciador = "Potenciador = " + str(potenciador)
	#ScriptGlobal.balas = "Balas = " + str(balasBazuca)
	#ScriptGlobal.vida = "Vida = " + str(vida)
	
	if !soyEnemy :
		if !cayo:
			$AnimationPlayer.play("Caer")
			cayo = true
		
		movimiento = TouchGeneral._pad()
		if caminar && Network.last_movement_id == Network.local_player_id && ScriptGlobal.partida_ready: 
			if(!is_on_floor()):
				posicao.y += gravity
			if movimiento.y < 0 and is_on_floor():
				posicao.y = -350
			if movimiento.x < 0: #izquierda
				$Sprite.scale.x = -0.22
				ScriptGlobal.disparo = 2
				flipeo = -60
				scale.x = 0.6
				scale.y = 0.6
				flipeoBombas = 48
				$AnimationPlayer.play("Nueva Animación")
				posicao.x = movimiento.x
			elif movimiento.x > 0: #derecha
				$Sprite.scale.x = 0.22
				ScriptGlobal.disparo = 1
				flipeo = 10
				flipeoBombas = 10
				scale.x = 0.6
				scale.y = 0.6
				$AnimationPlayer.play("Nueva Animación")
				posicao.x = movimiento.x
			elif movimiento.x == 0 and movimiento.y == 0 and is_on_floor():
				posicao.x = 0
				posicao.y = 0
	
			_enviarMov() #PREGUNTAR BIEN DONDE PONERLO
			move_and_slide(posicao,grav)
		else:
			if(!is_on_floor()):
				posicao.y += gravity
				move_and_slide(posicao,grav)
		if !ready && is_on_floor() && Network.ready1 && ScriptGlobal.LAN:
			ready =true
			var data = {
			player = id,
			posx = global_position.x,
			posy = global_position.y,
			piso =ready
			}
			Network.send_movement(data)
			#Network.ready1 =true
		
	else:#maneja enemigo
		if !cayoEnemy:
			#print("ENTRA A CAER ENEMIGO")
			$Sprite.frame = 24
		if is_on_floor() && !cayoEnemy:
			cayoEnemy = true
		if !Network.dispararEnemy :
			posicao.x = Network.enemyPos.x
			posicao.y = Network.enemyPos.y
			posicao.y += gravity
			posicao = move_and_slide(posicao,grav)
			if Network.direccionEnemy == 1:
				$Sprite.scale.x = 0.22
			else:
				$Sprite.scale.x = -0.22 
			
			#if Network.escalaEnemy !=0 :
			#	$Sprite.scale.x=Network.escalaEnemy
			if cayoEnemy && Network.last_movement_id != Network.local_player_id:
				scale.x = 0.6#poner en el mensaje
				scale.y = 0.6
				$AnimationPlayer.play("Nueva Animación")
			Network.enemyPos.x=0
			Network.enemyPos.y=0
			Network.escalaEnemy=0
			disparo=false
		elif !disparo:
				print("tengo q disparar")
				match Network.armaEnemy:
					1:
						$AnimationPlayer.play("sacarEscopeta")
					2:
						$AnimationPlayer.play("sacarBazuca")
					3:
						$AnimationPlayer.play("cargarTiro")
					4:
						$AnimationPlayer.play("cargarTiro")
				disparo=true
		else:
			if Network.crearBala :
				disparoEnemigo()
	if ScriptGlobal.tocoRegalo :
		accionRegalo()
	
func _input(event):
	if event.is_action_released("lefft_mouse") && (ScriptGlobal.arma == 3 || ScriptGlobal.arma == 4) && disparoBomba == true:
		cantB += 1
		if cantB == 2 :
			$AnimationPlayer.play("Tirar")
			disparoBomba = false
			cantB = 0

func _on_explosion_cooldown_timeout():
	cooldown = false

func accionRegalo():
	print(ScriptGlobal.regalo)
	match ScriptGlobal.regalo:
		1:
			print("especial")
		2:
			print("balas bombas")
			tirosBombas += 3
			ScriptGlobal.tiros += 3
		3:
			print("potenciador")
			potenciador += 10 
			ScriptGlobal.potenciador += 1 
		4:
			print("vida + 20")
			vida += 20
			ScriptGlobal.vida += 20
		5:
			print("vida + 10")
			vida += 10
			ScriptGlobal.vida += 10
		6:
			print("speed")
			desplazar += 20
			ScriptGlobal.speed += 1
		7:
			print("salto")
			saltar -= 50
			ScriptGlobal.salto += 1
		8:
			print("balas bazuca")
			balasBazuca += 3
			ScriptGlobal.balas += 3
		9:
			print("puente")
	
	ScriptGlobal.tocoRegalo = false
	ScriptGlobal.actualizadoHUD = false

func _disparar():
	scale.x = 0.6
	scale.y = 0.6
	if caminar and !disparo && !soyEnemy && ScriptGlobal.partida_ready && Network.last_movement_id == Network.local_player_id && is_on_floor() && ScriptGlobal.tocoArmaPrimeraVez:
		match ScriptGlobal.arma:
			1:
				$AnimationPlayer.play("sacarEscopeta")
			2:
				$AnimationPlayer.play("sacarBazuca")
			3:
				$AnimationPlayer.play("cargarTiro")
			4:
				$AnimationPlayer.play("cargarTiro")
		
		caminar=false
		disparo= true
		if ScriptGlobal.LAN :
			var data= {
				disparo=true,
				arma = ScriptGlobal.arma
			}
			Network.sendDisparo(data)
		if not cooldown:
			cooldown = true
			$explosion_cooldown.start()
			var newBala
			match ScriptGlobal.arma:
				1:
					newBala = bala.instance()
					newBala.position= $Pos_Bala.global_position + Vector2(flipeo,0)
				2:
					newBala = balaBazuca.instance()
					newBala.position= $Pos_Bala.global_position + Vector2(flipeo,0)
					ScriptGlobal.balas -= 1
				3:
					newBala = balaMolotov.instance()
					newBala.position = $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
					ScriptGlobal.tiros -= 1
					disparoBomba = true
				4:
					newBala = balaBomba.instance()
					newBala.position= $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
					ScriptGlobal.tiros -= 1
					disparoBomba = true
			ScriptGlobal.actualizadoHUD = false
			get_parent().add_child(newBala)
			#Esto mas adelante no va a pasar nunca, ya que despues de disparar cambiaria el turno o habria otra senal que le deje caminar
	elif  !caminar && !soyEnemy && Network.last_movement_id == Network.local_player_id:
		caminar=true
		disparo=false
		$AnimationPlayer.play("Nueva Animación")
		if ScriptGlobal.LAN:
			var data= {
				disparo=false,
				arma=0
			}
			Network.sendDisparo(data)

func _enviarMov():
	if ready && ScriptGlobal.partida_ready :
			var data = {
			player = id,
			posx = posicao.x,
			posy = posicao.y,
			escala = $Sprite.scale.x, 
			direccion = ScriptGlobal.disparo
			}
			Network.send_movement(data)

func disparoEnemigo():
	scale.x = 0.6
	scale.y = 0.6
	var newBala
	match Network.armaEnemy:
		1:
			newBala = bala.instance()
			newBala.position= $Pos_Bala.global_position + Vector2(flipeo,0)
			print("creo bala enemy")
		2:
			newBala = balaBazuca.instance()
			newBala.position= $Pos_Bala.global_position + Vector2(flipeo,0)
			ScriptGlobal.balas -= 1
			print("creo bala enemy")
		3:
			newBala = balaMolotov.instance()
			newBala.position = $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
			ScriptGlobal.tiros -= 1
			print("creo bala enemy")
		4:
			newBala = balaBomba.instance()
			newBala.position= $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
			ScriptGlobal.tiros -= 1
			print("creo bala enemy")
	get_parent().add_child(newBala)
	
	
	
	#for point in Network.lineaBala:
	#	var t = Timer.new()
	#	t.set_wait_time(0.025)
	#	t.set_one_shot(true)
	#	self.add_child(t)
	#	t.start()
	#	yield(t, "timeout")
	#	if !newBala.contacto:
	#		$Bala.position = point
	#	if newBala.contacto:
	#		Network.lineaBala = []
	#		self.queue_free()
	
	Network.crearBala =false
	#Network.lineaBala= null
	disparo =false
	Network.dispararEnemy =false
	Network.armaEnemy = 0	



