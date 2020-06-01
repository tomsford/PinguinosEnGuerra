extends Node2D

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
var seteadoRegalos = false

var posicionesArmas = { 
						"a" : Vector2(1311.225,295.707),
						"b" : Vector2(1576.033,295.891),
						"c" : Vector2(119.513,580.499),
						"d" : Vector2(462.227,582.89),
						"e" : Vector2(2000.807,485.683),
						"f" : Vector2(2437.03,580.499),
						"g" : Vector2(2245.697,166.917),
						"h" : Vector2(2968.271,101.868)}

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
						"m" : Vector2(429.789,486.23),
						"n" : Vector2(238.839,295.28),
						"o" : Vector2(25.771,582.646)}

func _physics_process(delta):
	
	
	var mob
	
	if !seteadoArmas:
		setearArmas()
	
	if !seteadoRegalos:
		setearRegalos()
	
	$RigidBody2D.position.x += 3
	
	if Input.is_action_pressed("ui_right") and caido:
		TouchGeneral._moverDer()
	if Input.is_action_pressed("ui_left") and caido:
		TouchGeneral._moverIzq()
	if Input.is_action_pressed("ui_up") and caido:
		TouchGeneral._moverArriba()
	
	if ScriptGlobal.LAN && Network.ready1 && Network.ready2 && caido && !yacreeenemy :
		enemy = playerA.instance()
		enemy.soyEnemy = true
		enemy.id = Network.players_IDS[1]
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
			print("creo escopeta")
		elif (random > 0.5 && maxbazuca < 2) || (maxescopeta == 2 && maxmolotov == 2 && maxbomba == 2):
			#Bazuca
			newArma = bazuca.instance() 
			maxbazuca += 1
			print("creo bazuca")
		elif (random > 0.25 && maxmolotov < 2) || (maxescopeta == 2 && maxbazuca == 2 && maxbomba == 2):
			#Molotov
			newArma = molotov.instance() 
			maxmolotov += 1
			print("creo molotov")
		else:
			#Bomba
			newArma = bomba.instance() 
			maxbomba += 1
			print("creo bomba")
		newArma.position = posicionesArmas[i]

		get_parent().add_child(newArma)
		
	seteadoArmas = true

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
	var maxGris = 0
	
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
		
		if (random > 0.8 && maxGris < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2):
			#RegaloGris
			newRegalo = regaloGris.instance()
			maxGris += 1
			#print("creo Gris")
		elif (random > 0.7 && maxVioleta < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxGris == 2):
			#RegaloVioleta
			newRegalo = regaloVioleta.instance()
			maxVioleta += 1
			#print("creo Violeta")
		elif (random > 0.6 && maxVerdeAgua < 1) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVioleta == 2 && maxGris == 2):
			#RegaloVerdeAgua
			newRegalo = regaloVerdeAgua.instance()
			maxVerdeAgua += 1
			#print("creo VerdeAgua")
		elif (random > 0.5 && maxVerde < 1) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerdeAgua == 1 && maxVioleta == 2 && maxGris == 2):
			#RegaloVerde
			newRegalo = regaloVerde.instance()
			maxVerde += 1
			#print("creo Verde")
		elif (random > 0.4 && maxRosa < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRojo == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 && maxGris == 2):
			#RegaloRosa
			newRegalo = regaloRosa.instance()
			maxRosa += 1
			#print("creo Rosa")
		elif (random > 0.3 && maxRojo < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxNaranja == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 && maxGris == 2):
			#RegaloRojo
			newRegalo = regaloRojo.instance()
			maxRojo += 1
			#print("creo Rojo")
		elif (random > 0.2 && maxNaranja < 2) || (maxAmarillo == 1 && maxAzul == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 && maxGris == 2):
			#RegaloNaranja
			newRegalo = regaloNaranja.instance()
			maxNaranja += 1
			#print("creo Naranja")
		elif ((maxAzul < 2) || (maxAmarillo == 1 && maxNaranja == 2 && maxRojo == 2 && maxRosa == 2 && maxVerde == 1 && maxVerdeAgua == 1 && maxVioleta == 2 && maxGris == 2)):
			#RegaloAzul
			newRegalo = regaloAzul.instance()
			maxAzul += 1
			#print("creo Azul")
		
		
		newRegalo.position = posicionesRegalosIzquierda[i]
		get_parent().add_child(newRegalo)
		
	seteadoRegalos = true

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
