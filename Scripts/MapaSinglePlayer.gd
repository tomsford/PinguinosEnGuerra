extends Control

var activo = false
var cambio = false
var nivelSeteado = false

var escenaGano = "res://Escenas/EscenaNuevoNivel.tscn"
var enemigo = preload("res://Escenas/Enemigo.tscn")

func _ready():
	if !nivelSeteado:
		setearNivel()
	ScriptGlobal.update_puntos() #SE ACTUALIZA CUANDO CHOCA CON EL ENEMIGO, AHORA ESTA TIRO CUANDO CHOCA CON CUALQUIER COSA PA PROBAR
	ScriptGlobal.update_time()
	ScriptGlobal.update_vida()
	
	var newEnemy = enemigo.instance()
	get_tree().get_nodes_in_group("SinglePlayer")[0].add_child(newEnemy)
	newEnemy.global_position = Vector2(1221.49,518.754)
	var data = 1
	newEnemy.spawn = 1
	newEnemy.direccion(data)
	
#FUNCION SIN TOCAR ABAJO DEL TODO COMENTADA

func _physics_process(delta):
	if ScriptGlobal.vida <= 0:
		get_tree().paused = true
		print("muerto")
		get_tree().paused = false
		ScriptGlobal.goto_scene("res://Escenas/GameOver.tscn")

func _on_Derecha_pressed():
	$Pinguino._derecha()

func _on_Izquierda_pressed():
	$Pinguino._izquierda()

func _on_Saltar_pressed():
	$Pinguino._saltar()

func _on_Disparar_pressed():
	$Pinguino.dispararApretado = true
#	if(ScriptGlobal.tocoArma == true):
#		$Pinguino._disparar()

func _on_explosion_cooldown_timeout():
	$Pinguino.cooldown = false

func _on_Timer_timeout(): #TIEMPO DE LA PARTIDA
	if ScriptGlobal.tiempo > 0:
		ScriptGlobal.tiempo -= 1
		ScriptGlobal.update_time()
	else:
		get_tree().paused = true
		ScriptGlobal.nivel += 1
		get_tree().paused = false
		if ScriptGlobal.nivel > ScriptGlobal.NIVEL_MAXIMO:
			print("gano el juego")
			ScriptGlobal.goto_scene("res://Escenas/Victoria.tscn")
		else:
			ScriptGlobal.goto_scene(escenaGano)
		print("SE TERMINO EL TIEMPO") # AGREGAR EL CAMBIO DE ESCENA

func _on_BotonPausa_pressed():
	if get_tree().paused == false:
		get_tree().paused = true
		$MenuPausa/Efecto.interpolate_property($MenuPausa/Botones,"rect_position",$MenuPausa/Botones.rect_position,$MenuPausa/Botones.rect_position+Vector2(750,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
		$MenuPausa/Efecto.start()

func _on_Continuar_pressed():
	if get_tree().paused == true:
		get_tree().paused = false
		$MenuPausa/Efecto.interpolate_property($MenuPausa/Botones,"rect_position",$MenuPausa/Botones.rect_position,$MenuPausa/Botones.rect_position-Vector2(750,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
		$MenuPausa/Efecto.start()

func _on_Salir_pressed():
	if get_tree().paused == true:
		get_tree().paused = false
		ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")

func _on_BotonArmas_pressed():
	
	if get_tree().paused == false:
		get_tree().paused = true
		$MenuArmas/Efecto.interpolate_property($MenuArmas/Botones,"rect_position",$MenuArmas/Botones.rect_position,$MenuArmas/Botones.rect_position+Vector2(1000,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
		$MenuArmas/Efecto.start()
	else:
		get_tree().paused = false
		$MenuArmas/Efecto.interpolate_property($MenuArmas/Botones,"rect_position",$MenuArmas/Botones.rect_position,$MenuArmas/Botones.rect_position-Vector2(1000,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
		$MenuArmas/Efecto.start()


func _on_Bazuca_pressed():
	if get_tree().paused == true:
		get_tree().paused = false
		$MenuArmas/Efecto.interpolate_property($MenuArmas/Botones,"rect_position",$MenuArmas/Botones.rect_position,$MenuArmas/Botones.rect_position-Vector2(1000,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
		$MenuArmas/Efecto.start()
		ScriptGlobal.disparo_SP = true
		ScriptGlobal.arma = 2
		ScriptGlobal.explosion = 45
		$CanvasLayer/Arma.frame = 1
		$Recargar.play()
		$Pinguino/AnimationPlayer.play("Sacar_Bazuca")

func _on_Escopeta_pressed():
		if get_tree().paused == true:
			get_tree().paused = false
			$MenuArmas/Efecto.interpolate_property($MenuArmas/Botones,"rect_position",$MenuArmas/Botones.rect_position,$MenuArmas/Botones.rect_position-Vector2(1000,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
			$MenuArmas/Efecto.start()
			ScriptGlobal.disparo_SP = true
			ScriptGlobal.arma = 1
			ScriptGlobal.explosion = 40
			$CanvasLayer/Arma.frame = 0
			$Recargar.play()
			$Pinguino/AnimationPlayer.play("Sacar_escopeta")
			

func _on_Molotov_pressed():
	if get_tree().paused == true:
			get_tree().paused = false
			$MenuArmas/Efecto.interpolate_property($MenuArmas/Botones,"rect_position",$MenuArmas/Botones.rect_position,$MenuArmas/Botones.rect_position-Vector2(1000,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
			$MenuArmas/Efecto.start()
			ScriptGlobal.disparo_SP = true
			ScriptGlobal.arma = 3
			ScriptGlobal.explosion = 45
			$CanvasLayer/Arma.frame = 2
			$Pinguino/AnimationPlayer.play("cargarTiro")

func _on_Bomba_pressed():
	if get_tree().paused == true:
			get_tree().paused = false
			$MenuArmas/Efecto.interpolate_property($MenuArmas/Botones,"rect_position",$MenuArmas/Botones.rect_position,$MenuArmas/Botones.rect_position-Vector2(1000,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
			$MenuArmas/Efecto.start()
			ScriptGlobal.disparo_SP = true
			ScriptGlobal.arma = 4
			ScriptGlobal.explosion = 45
			$CanvasLayer/Arma.frame = 3
			$Pinguino/AnimationPlayer.play("cargarTiro")

func setearNivel():
	match ScriptGlobal.nivel:
		1:
			$Fondo.frame = 0
		2:
			$Fondo.frame = 1
			ScriptGlobal.velocidad = 70
		3:
			$Fondo.frame = 2
			ScriptGlobal.velocidad = 100
		4:
			$Fondo.frame = 3
			ScriptGlobal.velocidad = 50
			$Spawn2/Timer.start(7)
		5:
			$Fondo.frame = 4
			ScriptGlobal.velocidad = 70
			$Spawn2/Timer.start(7)
		6:
			$Fondo.frame = 5
			ScriptGlobal.velocidad = 100
			$Spawn2/Timer.start(7)
	ScriptGlobal.tiempo = ScriptGlobal.tiempoPorNivel
	nivelSeteado = true
	ScriptGlobal.disparo = 1



#FUNCION PROCESS COMO ESTABA ANTES QUE EMPIECE A TOCAR
#func _physics_process(delta):
#if (ScriptGlobal.puntos >= 5 and !activo):
#		$Spawn2/Timer.start(7)
#		activo = true
#	if ScriptGlobal.puntos >= 10:
#		ScriptGlobal.velocidad = 75
#	if ScriptGlobal.puntos >= 20:
#		ScriptGlobal.velocidad = 100
#
#	if (ScriptGlobal.puntos % 5 == 0) and ScriptGlobal.puntos != 0:
#		if !cambio:
#			ScriptGlobal.tiempo += 20
#			#ScriptGlobal.update_time()
#			cambio = true
#	else: 
#		cambio = false

