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

var speedBoost=1
var jumpBoost=1

var cayoEnemy = false
var disparoBomba = false
var cantB = 0

var bala = load("res://Escenas/Bala.tscn")
var balaBazuca = load("res://Escenas/BalaBazuca.tscn")
var balaMolotov = load("res://Escenas/BalaMolotov.tscn")
var balaBomba = load("res://Escenas/BalaBomba.tscn")

func _ready():
	if soyEnemy:
		add_to_group("enemigo")

func _physics_process(delta):
	
	#ScriptGlobal.speed = "Speed = " + str(desplazar)
	#ScriptGlobal.tiros = "Tiros = " + str(tirosBombas)
	#ScriptGlobal.salto = "Salto = " + str(saltar)
	#ScriptGlobal.potenciador = "Potenciador = " + str(potenciador)
	#ScriptGlobal.balas = "Balas = " + str(balasBazuca)
	#ScriptGlobal.vida = "Vida = " + str(vida)
	
	if !soyEnemy :

		if ScriptGlobal.spawn:
			if position.x > 3750:
				position.x = 6148.86
				position.y = 464.902
			else:
				position.x = 50.083
				position.y = 554.572
			ScriptGlobal.preTurno=true
			ScriptGlobal.spawn = false
			if ScriptGlobal.turnosDanados>0 :
				ScriptGlobal.turnosDanados-=1

		if !cayo:
			$AnimationPlayer.play("Caer")
			cayo = true
		
		
		
		if cayo && ScriptGlobal.LAN:
			ScriptGlobal.posx = global_position.x
			ScriptGlobal.posy = global_position.y
			
		movimiento = TouchGeneral._pad()
		if caminar && Network.last_movement_id == Network.local_player_id && ScriptGlobal.partida_ready: 
			if(!is_on_floor()):
				posicao.y += gravity
			if movimiento.y < 0 and is_on_floor():
				posicao.y = -350*ScriptGlobal.salto
				if ScriptGlobal.desafio1==7 &&  !ScriptGlobal.completadoDesafio1:
					if ScriptGlobal.cantidadSaltosRecompensa<100:
						ScriptGlobal.cantidadSaltosRecompensa+=1
						ScriptGlobal.update_Recompensa1(String("Progreso: "+str(ScriptGlobal.cantidadSaltosRecompensa)+" /100."))
					if ScriptGlobal.cantidadSaltosRecompensa>=100 :
						ScriptGlobal.completadoDesafio1=true
				if ScriptGlobal.desafio2==7 && !ScriptGlobal.completadoDesafio2 :
					if ScriptGlobal.cantidadSaltosRecompensa<100:
						ScriptGlobal.cantidadSaltosRecompensa+=1
						ScriptGlobal.update_Recompensa2(String("Progreso: "+str(ScriptGlobal.cantidadSaltosRecompensa)+" /100."))
					if ScriptGlobal.cantidadSaltosRecompensa>=100 :
						ScriptGlobal.completadoDesafio2=true
						
						
			if movimiento.x < 0: #izquierda
				$Sprite.scale.x = -0.22
				ScriptGlobal.disparo = 2
				flipeo = -60
				scale.x = 0.6
				scale.y = 0.6
				flipeoBombas = 48
				$AnimationPlayer.play("Nueva Animación")
				posicao.x = movimiento.x*ScriptGlobal.speed
			elif movimiento.x > 0: #derecha
				$Sprite.scale.x = 0.22
				ScriptGlobal.disparo = 1
				flipeo = 10
				flipeoBombas = 10
				scale.x = 0.6
				scale.y = 0.6
				$AnimationPlayer.play("Nueva Animación")
				posicao.x = movimiento.x*speedBoost
			elif movimiento.x == 0 and movimiento.y == 0 and is_on_floor():
				posicao.x = 0
				posicao.y = 0
	
			_enviarMov() #PREGUNTAR BIEN DONDE PONERLO
			move_and_slide(posicao,grav)
		elif !caminar  && Network.last_movement_id != Network.local_player_id:
			caminar=true
			disparo=false
			$AnimationPlayer.play("Nueva Animación")
			if ScriptGlobal.LAN:
				var data= {
					disparo=false,
					arma=0
				}
				Network.sendDisparo(data)
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
		if ScriptGlobal.tocoRegalo :
			caminar=false
			accionRegalo()
	else:#maneja enemigo
		if !cayoEnemy:
			#print("ENTRA A CAER ENEMIGO")
			$Sprite.frame = 24
		if is_on_floor() && !cayoEnemy:
			cayoEnemy = true
		if cayoEnemy && Network.actualizarPosTurno && Network.Id_enemy==id :
			print("actulizo la pos del enemy")
			global_position.x = Network.posIniX
			global_position.y = Network.posIniY
			Network.actualizarPosTurno=false
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
	if !soyEnemy :
		print ("es mi turno actulizo HUD")
		match ScriptGlobal.regalo:
			1:
				print("especial")
				tirosBombas += 3
				ScriptGlobal.tiros += 3
				balasBazuca += 3
				ScriptGlobal.balas += 3
				vida += 20
				ScriptGlobal.vida += 20
			2:
				print("balas bombas")
				tirosBombas += 3
				ScriptGlobal.tiros += 3
			3:
				print("potenciador")
				potenciador += 10 
				ScriptGlobal.potenciador += 20
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
				speedBoost=1.25
				ScriptGlobal.speed=1.25
			7:
				print("salto")
				jumpBoost=1.2
				ScriptGlobal.salto=1.2
			8:
				print("balas bazuca")
				balasBazuca += 3
				ScriptGlobal.balas += 3
		
		
		ScriptGlobal.actualizadoHUD = false
		print("cambio TURNO POR EL REGALO")
		#Network.sendCambiarTurno()
		ScriptGlobal.preTurno=true
		
		##DESAFIO 1 
		if ScriptGlobal.desafio1==1:
			ScriptGlobal.cantRegalosRecompensa+=1
			var data=String("Progreso: " + str(ScriptGlobal.cantRegalosRecompensa) +" /3.")
			ScriptGlobal.update_Recompensa1(data)
		elif ScriptGlobal.desafio2==1:
			ScriptGlobal.cantRegalosRecompensa+=1
			var data=String("Progreso: " + str(ScriptGlobal.cantRegalosRecompensa) + " /3.")
			ScriptGlobal.update_Recompensa2(data)
		if ScriptGlobal.cantRegalosRecompensa==3 && ScriptGlobal.desafio1==1:
			ScriptGlobal.completadoDesafio1=true
		elif ScriptGlobal.cantRegalosRecompensa==3 && ScriptGlobal.desafio2==1:
			ScriptGlobal.completadoDesafio2=true
		
		## DESAFIO 2
		if ScriptGlobal.turnosDanados>0 :
				ScriptGlobal.turnosDanados-=1
	ScriptGlobal.tocoRegalo = false
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
		if not cooldown && is_on_floor():
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
#	elif  !caminar && !soyEnemy && Network.last_movement_id == Network.local_player_id:
#		caminar=true
#		disparo=false
#		$AnimationPlayer.play("Nueva Animación")
#		if ScriptGlobal.LAN:
#			var data= {
#				disparo=false,
#				arma=0
#			}
#			Network.sendDisparo(data)

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
			print("creo bala enemy")
		3:
			newBala = balaMolotov.instance()
			newBala.position = $Pos_Bomba.global_position + Vector2(flipeoBombas,0)

			print("creo bala enemy")
		4:
			newBala = balaBomba.instance()
			newBala.position= $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
			print("creo bala enemy")
	get_parent().add_child(newBala)

	Network.crearBala =false
	#Network.lineaBala= null
	disparo =false
	Network.dispararEnemy =false
	Network.armaEnemy = 0	



