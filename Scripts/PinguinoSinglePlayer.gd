extends KinematicBody2D

var posicao = Vector2()
const gravity = 9.8
const grav= Vector2(0,-1)
var flipeo = 0
var cooldown = false
var flipeoBombas = 10
var armapordefecto= true
var bala = load("res://Escenas/Bala.tscn")
var balaBazuca = load("res://Escenas/BalaBazuca.tscn")
var balaMolotov = load("res://Escenas/BalaMolotov.tscn")
var balaBomba = load("res://Escenas/BalaBomba.tscn")

var dispararApretado = false

func _physics_process(delta):
	posicao.x = 0
	posicao.y += gravity
	
	if is_on_floor():
		ScriptGlobal.mostrarDisparo = true
	else: 
		ScriptGlobal.mostrarDisparo = false
	
	move_and_slide(posicao,grav)
	if armapordefecto:
		ScriptGlobal.tocoArma = true
		ScriptGlobal.disparo_SP = true
		ScriptGlobal.arma = 1
		ScriptGlobal.explosion = 40
		if !ScriptGlobal.mute:
			get_tree().get_nodes_in_group("recargar")[0].play()
		$AnimationPlayer.play("Sacar_escopeta")
		armapordefecto = false
#	if Input.is_action_pressed("lefft_mouse") and is_on_floor() and !ScriptGlobal.apuntando && ScriptGlobal.disparoSinglePlayer :
#			#if dispararApretado: 
#			_disparar()
#			#	dispararApretado = false
	if !ScriptGlobal.disparoSinglePlayer:
		_disparar()

func _derecha():
	print("derecha")
	$Sprite.scale.x = 0.22
	flipeo = 10
	flipeoBombas = 10
	ScriptGlobal.disparo = 1
	
func _izquierda():
	$Sprite.scale.x = -0.22
	flipeo = -100
	flipeoBombas = 48
	print("izquierda")
	ScriptGlobal.disparo = 2

func _saltar():
	if is_on_floor():
		posicao.y = -500
		move_and_slide(posicao,grav)

func _disparar():
		#if not cooldown:
			cooldown = true
			$explosion_cooldown.start()
			var newBala = null
			if !ScriptGlobal.balaActiva: #hasta que no se libere la bala no puedo crear otra
				match ScriptGlobal.arma:
					1:
						newBala = bala.instance()
						newBala.position= $Pos_Bala.global_position + Vector2(flipeo,0)
					2:
						newBala = balaBazuca.instance()
						newBala.position= $Pos_Bala.global_position + Vector2(flipeo,0)
					3:
						newBala = balaMolotov.instance()
						newBala.position = $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
					4:
						newBala = balaBomba.instance()
						newBala.position= $Pos_Bomba.global_position + Vector2(flipeoBombas,0)
				get_parent().add_child(newBala)
				ScriptGlobal.balaActiva=true
