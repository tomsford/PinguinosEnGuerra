extends KinematicBody2D

var vida = 0
var posicao = Vector2()
const gravity = 9.8
const grav= Vector2(0,-1)
var caminar= true
var disparo  = false
var cooldown = false
var cayo = false
var flipeo = 10

var bala = load("res://Escenas/Bala.tscn")
var balaBazuca = load("res://Escenas/BalaBazuca.tscn")

func _physics_process(delta):
	if !cayo:
		$AnimationPlayer.play("Caer")
		cayo = true
	if Input.is_action_pressed("ui_right") and caminar:
		posicao.x = 100
		#$ para llamar un nodo children
		$Sprite.scale.x = 0.22
		flipeo = 10

		$AnimationPlayer.play("Nueva Animación")
	elif Input.is_action_pressed("ui_left") and caminar:
		posicao.x = -100
		$Sprite.scale.x = -0.22
		flipeo = -100

		$AnimationPlayer.play("Nueva Animación")
	else:
		posicao.x = 0
	posicao.y += gravity
	if Input.is_action_just_pressed("ui_up") and caminar:
		if(is_on_floor()):
			posicao.y = -350
	if Input.is_action_just_pressed("sacararma") and caminar and !disparo:
		if ScriptGlobal.arma == 1:
			$AnimationPlayer.play("sacarEscopeta")
		else:
			$AnimationPlayer.play("sacarBazuca")
		
		caminar=false
		disparo= true
		if not cooldown:
			cooldown = true
			$explosion_cooldown.start()
			var newBala
			if ScriptGlobal.arma == 1:
				newBala = bala.instance()
			else:
				newBala = balaBazuca.instance()
				
			newBala.position= $Pos_Bala.global_position + Vector2(flipeo,0)
			get_parent().add_child(newBala)
	#Esto mas adelante no va a pasar nunca, ya que despues de disparar cambiaria el turno o habria otra senal que le deje caminar
	elif  Input.is_action_just_pressed("sacararma") and !caminar:
		caminar=true
		disparo=false
		$AnimationPlayer.play("Nueva Animación")
	posicao = move_and_slide(posicao,grav)
	

func _on_explosion_cooldown_timeout():
	cooldown = false

