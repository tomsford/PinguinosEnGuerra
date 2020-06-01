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


var bala = load("res://Escenas/Bala.tscn")
var balaBazuca = load("res://Escenas/BalaBazuca.tscn")
var balaMolotov = load("res://Escenas/BalaMolotov.tscn")
var balaBomba = load("res://Escenas/BalaBomba.tscn")

func _physics_process(delta):
	
	$VBoxContainer/Speed.text = "Speed = " + str(desplazar)
	$VBoxContainer/Tiros.text = "Tiros = " + str(tirosBombas)
	$VBoxContainer/Salto.text = "Salto = " + str(saltar)
	$VBoxContainer/Potenciador.text = "Potenciador = " + str(potenciador)
	$VBoxContainer/Balas.text = "Balas = " + str(balasBazuca)
	$VBoxContainer/Vida.text = "Vida = " + str(vida)
	
	if !soyEnemy:
		if !cayo:
			$AnimationPlayer.play("Caer")
			cayo = true
		posicao.x = 0	
		posicao.y += gravity
		posicao = move_and_slide(posicao,grav)
		Network.miPos=posicao
		if !ready && is_on_floor() && Network.ready1:
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
		posicao.x = Network.enemyPos.x
		posicao.y = Network.enemyPos.y
		posicao.y += gravity
		posicao = move_and_slide(posicao,grav)
		scale.x = 0.6
		scale.y = 0.6
		$AnimationPlayer.play("Nueva Animación")
		Network.enemyPos.x=0
		Network.enemyPos.y=0
	
	if ScriptGlobal.tocoRegalo :
		accionRegalo()
	
func _input(event):
	if event.is_action_released("lefft_mouse") && (ScriptGlobal.arma == 3 || ScriptGlobal.arma == 4) :
		$AnimationPlayer.play("Tirar")

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
		3:
			print("potenciador")
			potenciador += 10 
		4:
			print("vida + 20")
			vida += 20
		5:
			print("vida + 10")
			vida += 10
		6:
			print("speed")
			desplazar += 20
		7:
			print("salto")
			saltar -= 50
		8:
			print("balas bazuca")
			balasBazuca += 3
		9:
			print("puente")
	
	ScriptGlobal.tocoRegalo = false

func _derecha():
	if caminar && !soyEnemy && ScriptGlobal.partida_ready:
		posicao.x = 100
		$Sprite.scale.x = 0.22
		flipeo = 10
		scale.x = 0.6
		scale.y = 0.6
		$AnimationPlayer.play("Nueva Animación")
	posicao = move_and_slide(posicao,grav)
	Network.miPos=posicao
	_enviarMov()
	
func _izquierda():
	if caminar && !soyEnemy && ScriptGlobal.partida_ready:
		posicao.x = -100
		$Sprite.scale.x = -0.22
		flipeo = -100
		scale.x = 0.6
		scale.y = 0.6
		$AnimationPlayer.play("Nueva Animación")
	posicao = move_and_slide(posicao,grav)
	Network.miPos=posicao
	_enviarMov()
	
func _arriba():
	if caminar && !soyEnemy && ScriptGlobal.partida_ready:
		if(is_on_floor()):
			posicao.y = -350
	Network.miPos=posicao
	_enviarMov()
	
func _disparar():
	if caminar and !disparo && !soyEnemy && ScriptGlobal.partida_ready:
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
				3:
					newBala = balaMolotov.instance()
					newBala.position= $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
				4:
					newBala = balaBomba.instance()
					newBala.position= $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
		
					
			get_parent().add_child(newBala)
			#Esto mas adelante no va a pasar nunca, ya que despues de disparar cambiaria el turno o habria otra senal que le deje caminar
	elif  !caminar:
		caminar=true
		disparo=false
		$AnimationPlayer.play("Nueva Animación")

func _enviarMov():
	if ready && ScriptGlobal.partida_ready :
			var data = {
			player = id,
			posx = posicao.x,
			posy = posicao.y,
			piso =ready
			}
			Network.send_movement(data)
