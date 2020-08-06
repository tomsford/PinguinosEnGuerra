extends Control

var playerA = preload("res://Escenas/PersonajeAmarillo.tscn")
var playerR = preload("res://Escenas/PersonajeRosa.tscn")
var playerV = preload("res://Escenas/PersonajeVerde.tscn")
var player = preload("res://Escenas/Personaje.tscn")

var escopeta = preload("res://Escenas/Escopeta.tscn")
var bazuca = preload("res://Escenas/Bazuca.tscn")
var molotov = preload("res://Escenas/Molotov.tscn")
var bomba = preload("res://Escenas/Bomba.tscn")

var regaloAmarillo = preload("res://Escenas/RegaloAmarillo.tscn")
var regaloAzul = preload("res://Escenas/RegaloAzul.tscn")
var regaloNaranja = preload("res://Escenas/RegaloNaranja.tscn")
var regaloRojo = preload("res://Escenas/RegaloRojo.tscn")
var regaloRosa = preload("res://Escenas/RegaloRosa.tscn")
var regaloVerde = preload("res://Escenas/RegaloVerde.tscn")
var regaloVerdeAgua = preload("res://Escenas/RegaloVerdeAgua.tscn")
var regaloVioleta = preload("res://Escenas/RegaloVioleta.tscn")
var regaloGris = preload("res://Escenas/RegaloGris.tscn")

var yacreeenemy=false
var enemy=null

var caido = false
var seteadoArmas = false
var seteadoArmasD = false
var seteadoRegalos = false
var seteadoRegalosD = false

var TodoListo = false

var listoJugador = false
var numerosArmas = []
var numerosArmasD = []
var numerosRegalos = []
var numerosRegalosD = []

var setTimer=false
var comenzoPreturno=false

###Desafios
var finDesafio1=false
var findesafio2=false


var posicionesArmas = { #Armas izquierda
						"a" : Vector2(1311.225,295.707),
						"b" : Vector2(1576.033,295.891),
						"c" : Vector2(119.513,580.499),
						"d" : Vector2(462.227,582.89),
						"e" : Vector2(2000.807,485.683),
						"f" : Vector2(2437.03,580.499),
						"g" : Vector2(2245.697,166.917),
						"h" : Vector2(2968.271,101.868)}

var posicionesArmasD = { 
						"a" : Vector2(6148.86,464.902),
						"b" : Vector2(5399.028,582.045),
						"c" : Vector2(5023.32,231.626),
						"d" : Vector2(4782.001,582.767),
						"e" : Vector2(4524.408,323.856),
						"f" : Vector2(4193.02,132.362),
						"g" : Vector2(3591.019,581.856),
						"h" : Vector2(4026.754,455.723)}

var posicionesRegalosIzquierda = { 
						"b" : Vector2(2892.866,294.838),
						"c" : Vector2(2606.408,102.396),
						"d" : Vector2(2605.791,582.579),
						"e" : Vector2(2174.028,582.29),
						"f" : Vector2(1773.111,134.362),
						"g" : Vector2(1775.723,358.443),
						"h" : Vector2(1517.643,486.754),
						"i" : Vector2(1315.957,582.612),
						"j" : Vector2(1165.344,294.696),
						"k" : Vector2(857.557,582.252),
						"l" : Vector2(837.731,102.431),
						"m" : Vector2(238.839,295.28)}

var posicionesRegalosD = { 
						"b" : Vector2(6022.533,581.454),
						"c" : Vector2(6092.789,102.61),
						"d" : Vector2(5572.345,580.53),
						"e" : Vector2(5134.176,293.963),
						"f" : Vector2(4540.431,581.454),
						"g" : Vector2(4556.214,198.748),
						"h" : Vector2(4333.052,133.115),
						"i" : Vector2(4202.333,325.465),
						"j" : Vector2(3820.186,581.704),
						"k" : Vector2(3658.119,420.894),
						"l" : Vector2(3418.789,517.631),
						"m" : Vector2(3438.263,134.452)}

func _ready():
	#$CanvasLayer/HUD_Enemy/nombreEne.text = ScriptGlobal.nombreEnemy
	if Network.players_IDS[0] != Network.local_player_id:
		$RigidBody2D.scale.x = -1
		$RigidBody2D.position.x = 6750.701
		$ControlListo.rect_position.x = 5120
		$ControlEsperando.rect_position.x = 5120
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var eleccion1=rng.randi_range(1,8)
	var eleccion2=rng.randi_range(1,8)
	while eleccion1==eleccion2:
		eleccion2= rng.randi_range(1,8)
	ScriptGlobal.desafio1=eleccion1
	ScriptGlobal.desafio2=eleccion2
	print("random 1", eleccion1)
	print("random 2", eleccion2)
	if ScriptGlobal.desafio1 !=0 && ScriptGlobal.desafio2!=0:
		establecer_Objetivos(eleccion1,eleccion2)
	
func _physics_process(delta):
	
	var mob
	
	if ScriptGlobal.LAN && ScriptGlobal.tiempoMultiJugador == 0 && Network.last_movement_id==Network.local_player_id && !ScriptGlobal.preTurno:
		ScriptGlobal.preTurno=true
		print ("SE TERMINO EL TIEMPO, CAMBIA TURNO")
		if ScriptGlobal.turnosDanados>0 :
				ScriptGlobal.turnosDanados-=1
		#Network.sendCambiarTurno()
		
	if Network.llegoDano:
		ScriptGlobal.vida-=Network.dano
		Network.llegoDano=false	
		ScriptGlobal.actualizadoHUD=false
		
	if Network.actualizar_vida_enemy:
		$CanvasLayer/HUD_Enemy/Vida_Enemy.text=String(Network.vida_enemy)
		Network.actualizar_vida_enemy=false
	
	if ScriptGlobal.preTurno && !comenzoPreturno:
		print ("tengo q arrancar el timer: PreTurno")
		$pre_Turno.start()
		comenzoPreturno=true
	
	if ScriptGlobal.vida<=0:
		ScriptGlobal.goto_scene("res://Escenas/GameOver.tscn")
	
	if Network.vida_enemy<=0:
		ScriptGlobal.goto_scene("res://Escenas/Victoria.tscn")
	
	comprobarDisparo()
	
	if ScriptGlobal.tocoArma:
		match ScriptGlobal.arma:
			1:
				$CanvasLayer/HUD.frame = 0
			2:
				$CanvasLayer/HUD.frame = 1
			3:
				$CanvasLayer/HUD.frame = 2
			4:
				$CanvasLayer/HUD.frame = 3
	
	if !ScriptGlobal.actualizadoHUD :
		actualizarHUD()
	
	if !seteadoArmas && !seteadoArmasD && !seteadoRegalos && !seteadoRegalosD && Network.players_IDS[0] == Network.local_player_id :
		setearArmas()
		setearRegalos()
		setearArmasD()
		setearRegalosD()
	
	if !seteadoArmas && !seteadoArmasD && Network.crearArmas:
		setearArmasDelServer()
		setearArmasDelServerD()
	
	if !seteadoRegalos && !seteadoRegalosD && Network.crearRegalos:
		setearRegalosDelServer()
		setearRegalosDelServerD()
	
	if TodoListo && Network.players_IDS[0] == Network.local_player_id:
		$RigidBody2D.position.x += 3
	else :
		verificarTodoListo()

	if TodoListo && Network.players_IDS[0] != Network.local_player_id:
		$RigidBody2D.position.x -= 3
	else :
		verificarTodoListo()
	if ScriptGlobal.LAN && Network.ready1 && Network.ready2 && caido && !yacreeenemy :
		match Network.colorEnemy:
			1:
				enemy = playerA.instance()
			2:
				enemy = playerR.instance()
			3:
				enemy = playerV.instance()
			4:
				enemy = player.instance()
		enemy.soyEnemy = true
		
		if Network.players_IDS[0]==Network.local_player_id: 
			enemy.id = Network.players_IDS[1]#cambiar, mal para segundo player
		else:
			enemy.id = Network.players_IDS[0]
		
		#enemy.position = Vector2(Network.posIniX,Network.posIniX)
		enemy.global_position.x = Network.posIniX
		enemy.global_position.y = Network.posIniY
		add_child(enemy)
		yacreeenemy = true
		print ("CREE ENEMIGO CON POSICION en X:")
		print (Network.posIniX)
		print ("CREE ENEMIGO CON POSICION en Y:")
		print (Network.posIniY)
		ScriptGlobal.partida_ready = true
		$CanvasLayer/HUD_Enemy/nombreEne.text = String("Enemigo: "+str(ScriptGlobal.nombreEnemy))
		print("Mi enemigo es: ",ScriptGlobal.nombreEnemy)
	if ScriptGlobal.LAN && ScriptGlobal.partida_ready :
		if !setTimer:
			print("ARRANCA EL TIEMPO")
			$Timer.start()
			setTimer = true
		if Network.last_movement_id == Network.local_player_id: #My turn
			$CanvasLayer/TurnoSprite/AnimatedSprite.play("esTuTurno")
			CamaraGeneral.cambioTurno(get_tree().get_nodes_in_group("camara")[1])
		else:
			$CanvasLayer/TurnoSprite/AnimatedSprite.play("NoEsTuTurno")
			CamaraGeneral.cambioTurno(get_tree().get_nodes_in_group("camara")[2])
		$CanvasLayer/TurnoSprite.visible = true
		
	if ScriptGlobal.completadoDesafio1 && !finDesafio1:
		establecer_Recompensas1(ScriptGlobal.desafio1)
		
	
	if ScriptGlobal.completadoDesafio2 && !findesafio2:
		establecer_Recompensas2(ScriptGlobal.desafio2)
func establecer_Recompensas1(a):
		match a:
			1:
				print("especial")
				ScriptGlobal.tiros += 3
				ScriptGlobal.balas += 3
				ScriptGlobal.vida += 20
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
			2:
				print("balas bombas")
				ScriptGlobal.tiros += 3
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
			3:
				print("potenciador")
				ScriptGlobal.potenciador += 1 
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
			4:
				print("vida + 20")
				ScriptGlobal.vida += 20
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
			5:
				print("vida + 10")
				ScriptGlobal.vida += 10
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
			6:
				print("speed")
				ScriptGlobal.speed=1.25
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
			7:
				print("salto")
				ScriptGlobal.salto=1.2
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
			8:
				print("balas bazuca")
				ScriptGlobal.balas += 3
				$CanvasLayer/objetivo1.text=String("Objetivo completado")
				$CanvasLayer/recompensa1.visible=false
		ScriptGlobal.completadoDesafio1=false
		ScriptGlobal.actualizadoHUD=false
		finDesafio1=true
func establecer_Recompensas2(a):
		match a:
			1:
				print("especial")
				ScriptGlobal.tiros += 3
				ScriptGlobal.balas += 3
				ScriptGlobal.vida += 20
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
			2:
				print("balas bomba")
				ScriptGlobal.tiros += 3
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
			3:
				print("potenciador")
				ScriptGlobal.potenciador += 1 
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
			4:
				print("vida + 20")
				ScriptGlobal.vida += 20
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
			5:
				print("vida + 10")
				ScriptGlobal.vida += 10
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
			6:
				print("speed")
				ScriptGlobal.speed=1.25
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
			7:
				print("salto")
				ScriptGlobal.salto=1.2
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
			8:
				print("balas bazuca")
				ScriptGlobal.balas += 3
				$CanvasLayer/objetivo2.text=String("Objetivo completado")
				$CanvasLayer/recompensa2.visible=false
		ScriptGlobal.completadoDesafio2=false
		ScriptGlobal.actualizadoHUD=false
		findesafio2=true
func establecer_Objetivos(a,b):
		match a:
			1:
				$CanvasLayer/objetivo1.text=String("Agarrar 3 regalos. Recompensa: Balas multiples y vida")
				var data=String("Progreso: " + str(ScriptGlobal.cantRegalosRecompensa) +" /3.")
				ScriptGlobal.update_Recompensa1(data)
			2:
				$CanvasLayer/objetivo1.text=String("Hacer 40 dano con escopeta. Recompensa: Balas bombas")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /40.")
				ScriptGlobal.update_Recompensa1(data)
			3:
				$CanvasLayer/objetivo1.text=String("Danar 2 turnos seguidos al enemigo. Recompensa:Potenciador de dano.")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /2.")
				ScriptGlobal.update_Recompensa1(data)
			4:
				$CanvasLayer/objetivo1.text=String("Agarrar una bomba del suelo . Recompensa: Mas vida")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /1.")
				ScriptGlobal.update_Recompensa1(data)
			5:
				$CanvasLayer/objetivo1.text=String("Agarrar una molotov. Recompensa: Un poco de vida")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /1.")
				ScriptGlobal.update_Recompensa1(data)
			6:
				$CanvasLayer/objetivo1.text=String("Hacer 80 de dano con Molotov . Recompensa: Mas velocidad")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /80.")
				ScriptGlobal.update_Recompensa1(data)
			7:
				$CanvasLayer/objetivo1.text=String("Saltar 100 veces. Recompensa: Saltar mas alto")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /100.")
				ScriptGlobal.update_Recompensa1(data)
			8:
				$CanvasLayer/objetivo1.text=String("Hacer 60 de dano con bazuca . Recompensa: Mas balas bazuca")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /60.")
				ScriptGlobal.update_Recompensa1(data)
		match b:
			1:
				$CanvasLayer/objetivo2.text=String("Agarrar 3 regalos. Recompensa: Balas multiples y vida")
				var data=String("Progreso: " + str(ScriptGlobal.cantRegalosRecompensa) +" /3.")
				ScriptGlobal.update_Recompensa2(data)
			2:
				$CanvasLayer/objetivo2.text=String("Hacer 40 dano con escopeta. Recompensa: Balas bombas")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /40.")
				ScriptGlobal.update_Recompensa2(data)
			3:	
				$CanvasLayer/objetivo2.text=String("Danar 2 turnos seguidos al enemigo. Recompensa: Potenciador de disparo")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /2.")
				ScriptGlobal.update_Recompensa2(data)
			4:
				$CanvasLayer/objetivo2.text=String("Agarrar una bomba del suelo . Recompensa: Mas vida")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /1.")
				ScriptGlobal.update_Recompensa2(data)
			5:
				$CanvasLayer/objetivo2.text=String("Agarrar una molotov. Recompensa: Un poco de vida")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /1.")
				ScriptGlobal.update_Recompensa2(data)
			6:
				$CanvasLayer/objetivo2.text=String("Hacer 80 de dano con Molotov . Recompensa: Mas velocidad")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /80.")
				ScriptGlobal.update_Recompensa2(data)
			7:
				$CanvasLayer/objetivo2.text=String("Saltar 100 veces. Recompensa: Saltar mas alto")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /100.")
				ScriptGlobal.update_Recompensa2(data)
			8:
				$CanvasLayer/objetivo2.text=String("Hacer 60 de dano con bazuca . Recompensa: Mas balas bazuca")
				var data=String("Progreso: " + str(ScriptGlobal.danoEscopetaRecompensa) +" /60.")
				ScriptGlobal.update_Recompensa2(data)
		
	
func setearArmas():
	var newArma
	var random
	var rng = RandomNumberGenerator.new()
	var maxescopeta = 0
	var maxbazuca = 0
	var maxmolotov = 0
	var maxbomba = 0
	
	for i in  posicionesArmas:
		#print(posicionesArmas[i])
		rng.randomize()
		random = rng.randf_range(0, 1)
		
		if (random > 0.75 && maxescopeta < 2) || (maxbazuca == 2 && maxmolotov == 2 && maxbomba == 2):
			#Escopeta
			newArma = escopeta.instance()
			maxescopeta += 1
			numerosArmas.append(1)
			print("creo escopeta")
		elif (random > 0.5 && maxbazuca < 2) || (maxescopeta == 2 && maxmolotov == 2 && maxbomba == 2):
			#Bazuca
			newArma = bazuca.instance() 
			maxbazuca += 1
			numerosArmas.append(2)
			print("creo bazuca")
		elif (random > 0.25 && maxmolotov < 2) || (maxescopeta == 2 && maxbazuca == 2 && maxbomba == 2):
			#Molotov
			newArma = molotov.instance() 
			maxmolotov += 1
			numerosArmas.append(3)
			print("creo molotov")
		elif (maxbomba < 2) || (maxescopeta == 2 && maxbazuca == 2 && maxmolotov == 2) :
			#Bomba
			newArma = bomba.instance() 
			maxbomba += 1
			numerosArmas.append(4)
			print("creo bomba")
		elif (maxbazuca < 2) || (maxescopeta == 2 && maxmolotov == 2 && maxbomba == 2):
			#Bazuca
			newArma = bazuca.instance() 
			maxbazuca += 1
			print("creo bazuca")
			numerosArmas.append(2)
			
		newArma.position = posicionesArmas[i]

		get_parent().add_child(newArma)
		
	#enviarArmas()
	seteadoArmas = true

func setearArmasD():
	var newArma
	var random
	var rng = RandomNumberGenerator.new()
	var maxescopeta = 0
	var maxbazuca = 0
	var maxmolotov = 0
	var maxbomba = 0
	
	for i in  posicionesArmasD:
		#print(posicionesArmas[i])
		rng.randomize()
		random = rng.randf_range(0, 1)
		
		if (random > 0.75 && maxescopeta < 2) || (maxbazuca == 2 && maxmolotov == 2 && maxbomba == 2):
			#Escopeta
			newArma = escopeta.instance()
			maxescopeta += 1
			numerosArmasD.append(1)
			print("creo escopeta")
		elif (random > 0.5 && maxbazuca < 2) || (maxescopeta == 2 && maxmolotov == 2 && maxbomba == 2):
			#Bazuca
			newArma = bazuca.instance() 
			maxbazuca += 1
			numerosArmasD.append(2)
			print("creo bazuca")
		elif (random > 0.25 && maxmolotov < 2) || (maxescopeta == 2 && maxbazuca == 2 && maxbomba == 2):
			#Molotov
			newArma = molotov.instance() 
			maxmolotov += 1
			numerosArmasD.append(3)
			print("creo molotov")
		elif (maxbomba < 2) || (maxescopeta == 2 && maxbazuca == 2 && maxmolotov == 2) :
			#Bomba
			newArma = bomba.instance() 
			maxbomba += 1
			numerosArmasD.append(4)
			print("creo bomba")
		elif (maxbazuca < 2) || (maxescopeta == 2 && maxmolotov == 2 && maxbomba == 2):
			#Bazuca
			newArma = bazuca.instance() 
			maxbazuca += 1
			print("creo bazuca")
			numerosArmasD.append(2)
			
		newArma.position = posicionesArmasD[i]

		get_parent().add_child(newArma)
		
	enviarArmas()
	seteadoArmasD = true

func setearRegalos():
	var newRegalo
	var random
	var rng = RandomNumberGenerator.new()
	var maxAmarillo = 0
	var maxAzul = 0
	var maxNaranja = 0
	var maxRojo = 0
	var maxRosa = 0
	var maxVerde = 0
	var maxVerdeAgua = 0
	var maxVioleta = 0
	#var maxGris = 0
	
	if (maxAmarillo < 1):
			#RegaloAmarillo
			newRegalo = regaloAmarillo.instance()
			maxAmarillo += 1
			#print("creo Amarillo")
			newRegalo.position = Vector2(3213.919,166.417)
			get_parent().add_child(newRegalo)
	
	for i in  posicionesRegalosIzquierda:
		#print(posicionesRegalosIzquierda[i])
		rng.randomize()
		random = rng.randf_range(0, 1)
		
#		if (random > 0.8 && maxGris < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2):
#			#RegaloGris
#			newRegalo = regaloGris.instance()
#			maxGris += 1
#			numerosRegalos.append(1)
#			#print("creo Gris")
		if (random > 0.7 && maxVioleta < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1):
			#RegaloVioleta
			newRegalo = regaloVioleta.instance()
			maxVioleta += 1
			numerosRegalos.append(2)
			#print("creo Violeta")
		elif (random > 0.6 && maxVerdeAgua < 1) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVioleta == 2):
			#RegaloVerdeAgua
			newRegalo = regaloVerdeAgua.instance()
			maxVerdeAgua += 1
			numerosRegalos.append(3)
			#print("creo VerdeAgua")
		elif (random > 0.5 && maxVerde < 1) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerdeAgua == 1 && maxVioleta == 2):
			#RegaloVerde
			newRegalo = regaloVerde.instance()
			maxVerde += 1
			numerosRegalos.append(4)
			#print("creo Verde")
		elif (random > 0.4 && maxRosa < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 ):
			#RegaloRosa
			newRegalo = regaloRosa.instance()
			maxRosa += 1
			numerosRegalos.append(5)
			#print("creo Rosa")
		elif (random > 0.3 && maxRojo < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2):
			#RegaloRojo
			newRegalo = regaloRojo.instance()
			maxRojo += 1
			numerosRegalos.append(6)
			#print("creo Rojo")
		elif (random > 0.2 && maxNaranja < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 ):
			#RegaloNaranja
			newRegalo = regaloNaranja.instance()
			maxNaranja += 1
			numerosRegalos.append(7)
			#print("creo Naranja")
		elif ((maxAzul < 2) || (maxAmarillo == 1 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 )):
			#RegaloAzul
			newRegalo = regaloAzul.instance()
			maxAzul += 1
			numerosRegalos.append(8)
			#print("creo Azul")
		else:
			newRegalo = regaloRosa.instance()
			maxRosa += 1
			numerosRegalos.append(5)
		
		
		newRegalo.position = posicionesRegalosIzquierda[i]
		get_parent().add_child(newRegalo)
		print(i)
		
	
	#enviarRegalos()
	seteadoRegalos = true

func setearRegalosD():
	var newRegalo
	var random
	var rng = RandomNumberGenerator.new()
	var maxAmarillo = 1
	var maxAzul = 0
	var maxNaranja = 0
	var maxRojo = 0
	var maxRosa = 0
	var maxVerde = 0
	var maxVerdeAgua = 0
	var maxVioleta = 0
	
	for i in  posicionesRegalosD:

		rng.randomize()
		random = rng.randf_range(0, 1)
		
		if (random > 0.7 && maxVioleta < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1):
			#RegaloVioleta
			newRegalo = regaloVioleta.instance()
			maxVioleta += 1
			numerosRegalosD.append(2)
			#print("creo Violeta")
		elif (random > 0.6 && maxVerdeAgua < 1) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVioleta == 2):
			#RegaloVerdeAgua
			newRegalo = regaloVerdeAgua.instance()
			maxVerdeAgua += 1
			numerosRegalosD.append(3)
			#print("creo VerdeAgua")
		elif (random > 0.5 && maxVerde < 1) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerdeAgua == 1 && maxVioleta == 2):
			#RegaloVerde
			newRegalo = regaloVerde.instance()
			maxVerde += 1
			numerosRegalosD.append(4)
			#print("creo Verde")
		elif (random > 0.4 && maxRosa < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 ):
			#RegaloRosa
			newRegalo = regaloRosa.instance()
			maxRosa += 1
			numerosRegalosD.append(5)
			#print("creo Rosa")
		elif (random > 0.3 && maxRojo < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2):
			#RegaloRojo
			newRegalo = regaloRojo.instance()
			maxRojo += 1
			numerosRegalosD.append(6)
			#print("creo Rojo")
		elif (random > 0.2 && maxNaranja < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 ):
			#RegaloNaranja
			newRegalo = regaloNaranja.instance()
			maxNaranja += 1
			numerosRegalosD.append(7)
			#print("creo Naranja")
		elif ((maxAzul < 2) || (maxAmarillo == 1 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 )):
			#RegaloAzul
			newRegalo = regaloAzul.instance()
			maxAzul += 1
			numerosRegalosD.append(8)
			#print("creo Azul")
		else:
			newRegalo = regaloRosa.instance()
			maxRosa += 1
			numerosRegalosD.append(5)
		
		
		newRegalo.position = posicionesRegalosD[i]
		get_parent().add_child(newRegalo)
		print(i)
		
	
	enviarRegalos()
	seteadoRegalosD = true

func _on_Button_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")

func _on_Tirarse_pressed():
	if !caido:
		var mob
		if ScriptGlobal.pinguino == 1:
			mob = playerA.instance()
		elif ScriptGlobal.pinguino == 2:
			mob = playerR.instance()
		elif ScriptGlobal.pinguino == 3:
			mob = playerV.instance()
		else:
			mob = player.instance()
		mob.position = $RigidBody2D/Position2D.global_position
		add_child(mob)
		caido = true
		if ScriptGlobal.LAN :
			mob.id = Network.local_player_id

func _on_Disparar_released():
	if caido:
		TouchGeneral._disparo()

func actualizarHUD():
	$CanvasLayer/Vida.text = str(ScriptGlobal.vida)
	$CanvasLayer/Tiros.text = "X " + str(ScriptGlobal.tiros)
	$CanvasLayer/Balas.text = "X " + str(ScriptGlobal.balas)
	$CanvasLayer/Potenciador.text = "X " + str(ScriptGlobal.potenciador)
	$CanvasLayer/Speed.text = "X " + str(ScriptGlobal.speed)
	$CanvasLayer/Salto.text = "X " + str(ScriptGlobal.salto)
	ScriptGlobal.actualizadoHUD = true
	var data = {
		vida=ScriptGlobal.vida
	}
	Network.send_cambioVida(data)

func _on_BotonAtras_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")

func _on_Listo_pressed():
	$ControlListo.visible = false
	$ControlEsperando.visible = true
	$ControlEsperando/Esperando/Label/AnimationPlayer.play("Esperando")
	listoJugador = true

func enviarArmas():
	var data= {
				posiciones = numerosArmas,
				posicionesD  = numerosArmasD
			}
	print("numeros armass")
	print(numerosArmas)
	Network.send_armas(data)

func enviarRegalos():
	var data= {
				posiciones = numerosRegalos,
				posicionesD = numerosRegalosD
			}
	print("numeros regalos")
	print(numerosRegalos)
	Network.send_regalos(data)

func verificarTodoListo():
	if seteadoArmas && seteadoArmasD && seteadoRegalos && seteadoRegalosD && listoJugador:
		if Network.players_IDS[0] == Network.local_player_id :
			Network.readyMapa = true
			Network.send_ListoMapa()
		else :
			Network.readyMapa2 = true
			Network.send_ListoMapa()
		if Network.readyMapa && Network.readyMapa2 :
			TodoListo = true
			$ControlEsperando.visible = false

func setearArmasDelServer():
	print("tengo que setear armas que vinieron")
	var newArma
	var j=0

	for i in  posicionesArmas:
		match Network.posArmas[j] :
			1:
				newArma = escopeta.instance()
				print("creo escopeta")
			2:
				newArma = bazuca.instance() 
			3:
				newArma = molotov.instance() 
			4:
				newArma = bomba.instance() 
			
		newArma.position = posicionesArmas[i]
		get_parent().add_child(newArma)
		j+=1
	seteadoArmas = true

func setearArmasDelServerD():
	print("tengo que setear armas que vinieron")
	var newArma
	var j=0

	for i in  posicionesArmasD:
		match Network.posArmasD[j]:
			1:
				newArma = escopeta.instance()
				print("creo escopeta")
			2:
				newArma = bazuca.instance() 
			3:
				newArma = molotov.instance() 
			4:
				newArma = bomba.instance() 
			
		newArma.position = posicionesArmasD[i]
		get_parent().add_child(newArma)
		j+=1
	seteadoArmasD = true

func setearRegalosDelServer():
	print("tengo que setear regalos que vinieron")
	var newRegalo
	var maxAmarillo = 0
	var j=0

	if (maxAmarillo < 1):
			#RegaloAmarillo
			newRegalo = regaloAmarillo.instance()
			maxAmarillo += 1
			#print("creo Amarillo")
			newRegalo.position = Vector2(3213.919,166.417)
			get_parent().add_child(newRegalo)
	
	for i in  posicionesRegalosIzquierda:
		#print(posicionesRegalosIzquierda[i])
		match Network.posRegalos[j]:
			2:
				newRegalo = regaloVioleta.instance()
			3:
				newRegalo = regaloVerdeAgua.instance()
			4:
				newRegalo = regaloVerde.instance()
			5:
				newRegalo = regaloRosa.instance()
			6:
				newRegalo = regaloRojo.instance()
				print("creo rojo")
			7:
				newRegalo = regaloNaranja.instance()
			8:
				newRegalo = regaloAzul.instance()
		
		newRegalo.position = posicionesRegalosIzquierda[i]
		get_parent().add_child(newRegalo)
		j+=1
		
	seteadoRegalos = true

func setearRegalosDelServerD():
	print("tengo que setear regalos que vinieron")
	var newRegalo
	var maxAmarillo = 1
	var j=0

	if (maxAmarillo < 1):
			#RegaloAmarillo
			newRegalo = regaloAmarillo.instance()
			maxAmarillo += 1
			#print("creo Amarillo")
			newRegalo.position = Vector2(3213.919,166.417)
			get_parent().add_child(newRegalo)
	
	for i in  posicionesRegalosD:
		#print(posicionesRegalosIzquierda[i])
		match Network.posRegalosD[j]:
			2:
				newRegalo = regaloVioleta.instance()
			3:
				newRegalo = regaloVerdeAgua.instance()
			4:
				newRegalo = regaloVerde.instance()
			5:
				newRegalo = regaloRosa.instance()
			6:
				newRegalo = regaloRojo.instance()
				print("creo rojo")
			7:
				newRegalo = regaloNaranja.instance()
			8:
				newRegalo = regaloAzul.instance()
		
		newRegalo.position = posicionesRegalosD[i]
		get_parent().add_child(newRegalo)
		j+=1
		
	seteadoRegalosD = true


func _on_Timer_timeout():
	if ScriptGlobal.tiempoMultiJugador > 0:
		ScriptGlobal.tiempoMultiJugador -= 1
		ScriptGlobal.update_timeM()
		


func _on_cambioArma_pressed():
	if $CanvasLayer/MenuArmas.visible:
		$CanvasLayer/MenuArmas.visible = false
	else:
		if Network.last_movement_id == Network.local_player_id:
			if ScriptGlobal.tiros > 0 && ScriptGlobal.agarroMolotov:
				$CanvasLayer/MenuArmas/molotov.visible = true
			else:
				$CanvasLayer/MenuArmas/molotov.visible = false
			if ScriptGlobal.tiros > 0 && ScriptGlobal.agarroBomba:
				$CanvasLayer/MenuArmas/bomba.visible = true
			else:
				$CanvasLayer/MenuArmas/bomba.visible = false
			if ScriptGlobal.agarroEscopeta:
				$CanvasLayer/MenuArmas/escopeta.visible = true
			else:
				$CanvasLayer/MenuArmas/escopeta.visible = false
			if ScriptGlobal.agarroBazuca && ScriptGlobal.balas > 0:
				$CanvasLayer/MenuArmas/bazuca.visible = true
			else:
				$CanvasLayer/MenuArmas/bazuca.visible = false
			$CanvasLayer/MenuArmas.visible = true # Replace with function body.
	if !$CanvasLayer/MenuArmas/escopeta.visible && !$CanvasLayer/MenuArmas/bazuca.visible && !$CanvasLayer/MenuArmas/molotov.visible && !$CanvasLayer/MenuArmas/bomba.visible:
		$CanvasLayer/Disparar.visible = false
	else:
		$CanvasLayer/Disparar.visible = true

func _on_escopeta_pressed():
	$CanvasLayer/MenuArmas.visible = false
	ScriptGlobal.arma = 1

func _on_bazuca_pressed():
	$CanvasLayer/MenuArmas.visible = false 
	ScriptGlobal.arma = 2

func _on_molotov_pressed():
	$CanvasLayer/MenuArmas.visible = false
	ScriptGlobal.arma = 3

func _on_bomba_pressed():
	$CanvasLayer/MenuArmas.visible = false
	ScriptGlobal.arma = 4


func _on_LimiteIzq_body_entered(body):
	if !caido:
		_on_Tirarse_pressed()


func _on_LimiteDer_body_entered(body):
	if !caido:
		_on_Tirarse_pressed()


func _on_pisopiso_body_entered(body):
	if body.is_in_group("pinguino") && !body.is_in_group("enemigo"):
			ScriptGlobal.vida -= 50
			ScriptGlobal.actualizadoHUD = false
			ScriptGlobal.spawn = true


func _on_pre_Turno_timeout():
	ScriptGlobal.preTurno=false
	comenzoPreturno=false
	Network.sendCambiarTurno()
	$pre_Turno.stop()
	print ("TERMINO EL PRE TURNO")
	
func comprobarDisparo():
	if Network.last_movement_id == Network.local_player_id:
			if ScriptGlobal.tiros > 0 && ScriptGlobal.agarroMolotov:
				$CanvasLayer/MenuArmas/molotov.visible = true
			else:
				$CanvasLayer/MenuArmas/molotov.visible = false
			if ScriptGlobal.tiros > 0 && ScriptGlobal.agarroBomba:
				$CanvasLayer/MenuArmas/bomba.visible = true
			else:
				$CanvasLayer/MenuArmas/bomba.visible = false
			if ScriptGlobal.agarroEscopeta:
				$CanvasLayer/MenuArmas/escopeta.visible = true
			else:
				$CanvasLayer/MenuArmas/escopeta.visible = false
			if ScriptGlobal.agarroBazuca && ScriptGlobal.balas > 0:
				$CanvasLayer/MenuArmas/bazuca.visible = true
			else:
				$CanvasLayer/MenuArmas/bazuca.visible = false
			match $CanvasLayer/HUD.frame:
				0:
					if $CanvasLayer/MenuArmas/escopeta.visible:
						$CanvasLayer/Disparar.visible = true
					else:
						$CanvasLayer/Disparar.visible = false
				1:
					if $CanvasLayer/MenuArmas/bazuca.visible:
						$CanvasLayer/Disparar.visible = true
					else:
						$CanvasLayer/Disparar.visible = false
				2:
					if $CanvasLayer/MenuArmas/molotov.visible:
						$CanvasLayer/Disparar.visible = true
					else:
						$CanvasLayer/Disparar.visible = false
				3:
					if $CanvasLayer/MenuArmas/bomba.visible:
						$CanvasLayer/Disparar.visible = true
					else:
						$CanvasLayer/Disparar.visible = false


func _on_sonido_pressed():
		if !ScriptGlobal.muteMultijugador:
			ScriptGlobal.reproducirMultijugador = $MusicaFondo.get_playback_position()
			$MusicaFondo.stop()
			ScriptGlobal.muteMultijugador= true
		else:
			$MusicaFondo.play(ScriptGlobal.reproducirMultijugador)
			ScriptGlobal.muteMultijugador= false
