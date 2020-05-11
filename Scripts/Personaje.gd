tool
extends KinematicBody2D

var vida = 0
var posicao = Vector2()
const gravity = 9.8
const grav= Vector2(0,-1)
var caminar= true
var disparo  = false
var cooldown = false



# Variables trayectoria
export (int, 5, 15) var puntos_trayectoria = 8
export (float, .2, 1, 0.1) var separacion = .4
export (int, 10, 100) var impulso_trayectoria = 70
export (int, -90, 90) var angulo_trayectoria = 45
export var trayectoria_visible: bool = true

var bala = load("res://Escenas/Bala.tscn")
var trayectoria = load("res://Escenas/punto_trayectoria.tscn")
var impulso = 4

enum {
	ESTADO_QUIETO,
	ESTADO_TRANSFERIR,
	ESTADO_TOMADO,
	ESTADO_ARRASTRADO,
	ESTADO_RELEASED,
	ESTADO_LANZADO
	}

var estado = ESTADO_QUIETO

func _ready():
	$Trayectoria.position = $Pos_Bala.position

func _process(delta):
	for sp in $Trayectoria.get_children():
		sp.queue_free()
	if Engine.is_editor_hint() && trayectoria_visible:
		dibujar_trayectoria(Vector2(impulso_trayectoria * impulso,0).rotated(deg2rad(-angulo_trayectoria)))
	else:
		if estado == ESTADO_ARRASTRADO:
			var impul = ($Pos_Bala.position - get_global_mouse_position())
			dibujar_trayectoria(impul)
		
func _physics_process(delta):
	#corriendo todo el tiempo , el delta es para q no haya delay
	
	if Input.is_action_pressed("ui_right") and caminar:
		posicao.x = 100
		#$ para llamar un nodo children
		$Sprite.scale.x = 0.22
		$AnimationPlayer.play("Nueva Animación")
	elif Input.is_action_pressed("ui_left") and caminar:
		posicao.x = -100
		$Sprite.scale.x = -0.22
		$AnimationPlayer.play("Nueva Animación")
	else:
		posicao.x = 0
	
	posicao.y += gravity
	if Input.is_action_just_pressed("ui_up") and caminar:
		if(is_on_floor()):
			posicao.y = -500
	if Input.is_action_just_pressed("sacararma") and caminar and !disparo:
		$AnimationPlayer.play("sacarEscopeta")
		caminar=false
		disparo= true
	elif  Input.is_action_just_pressed("sacararma") and !caminar:
		caminar=true
		disparo=false
		$AnimationPlayer.play("Nueva Animación")
	posicao = move_and_slide(posicao,grav)
	
#### PARTE SOBRE LA BALA
	var velocidad_lineal
	var diferencia_de_posicion = $Pos_Bala.global_position - get_global_mouse_position()
	
	
	
	#if Input.is_action_just_pressed("disparar"):
	#	_disparar()
	
	

	if Input.is_action_just_released("lefft_mouse") and !caminar and disparo:
		print("released")
		#estado = ESTADO_TOMADO
		impulso = diferencia_de_posicion *0.06 #obtener_impulso()# diferencia_de_posicion *0.06
		estado = ESTADO_RELEASED

	match estado:
			ESTADO_TRANSFERIR:
				pass
			ESTADO_TOMADO:
				# velocidad_lineal = diferencia_de_posicion * delta * 0.3
				# velocidad_angular = -rotation * delta
				pass
			ESTADO_ARRASTRADO:
				var fuerza = get_global_mouse_position() - $Pos_Bala.global_position
				fuerza = fuerza.clamped(5000)
				velocidad_lineal = (fuerza + diferencia_de_posicion)
			ESTADO_RELEASED:
				velocidad_lineal = impulso#obtener_impulso() #impulso 
				#print("impulso")
				#print(impulso)
				if not cooldown:
					cooldown = true
					$explosion_cooldown.start()
		
					var newBala = bala.instance()
					newBala.velocidad_lineal = velocidad_lineal
					newBala.position= $Pos_Bala.global_position
					get_parent().add_child(newBala)
					estado = ESTADO_LANZADO
				
				
			ESTADO_LANZADO:
				pass

func _input(event):
	if event.is_action_pressed("lefft_mouse") and !caminar and disparo:
		estado = ESTADO_ARRASTRADO

#func _disparar():
#	if not cooldown:
#		cooldown = true
#		$explosion_cooldown.start()
#		
#		var newBala = bala.instance()
#		newBala.position= $Pos_Bala.global_position
#		get_parent().add_child(newBala)

func _on_explosion_cooldown_timeout():
	cooldown = false

func dibujar_trayectoria(impulso):
	var gravedad = ProjectSettings.get("physics/2d/default_gravity")
	for i in range(0,puntos_trayectoria):
		var t = i * separacion
		var x = impulso.x * t
		var y = (gravedad * t * t  ) + impulso.y * t
		dibujar_puntos(Vector2(x,y))
	
func dibujar_puntos(lugar):
	var sp = trayectoria.instance()
	sp.position = lugar
	$Trayectoria.add_child(sp)

#func obtener_impulso():
#	return($Pos_Bala.global_position - get_global_mouse_position()) * 4
