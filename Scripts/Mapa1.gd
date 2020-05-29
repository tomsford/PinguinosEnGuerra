extends Node2D

var playerA = preload("res://Escenas/PersonajeAmarillo.tscn")
var playerR = preload("res://Escenas/PersonajeRosa.tscn")
var playerV = preload("res://Escenas/PersonajeVerde.tscn")
var player = preload("res://Escenas/Personaje.tscn")
var escopeta = preload("res://Escenas/Escopeta.tscn")
var bazuca = preload("res://Escenas/Bazuca.tscn")

var caido = false
var seteado = false
var posicionesArmas = { "a" : Vector2(1311.225,305.707),"b" : Vector2(1576.033,295.891),"c" : Vector2(119.513,580.499),"d" : Vector2(832.227,582.89),"e" : Vector2(1812.807,355.683),"f" : Vector2(2437.03,580.499),"g" : Vector2(2245.697,166.917),"h" : Vector2(2968.271,101.868)}

func _physics_process(delta):
	
	if !seteado:
		setearArmas()
	
	$RigidBody2D.position.x += 3
	
	if Input.is_action_pressed("caer") && !caido:
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

func setearArmas():
	var newArma
	var random
	var rng = RandomNumberGenerator.new()
	var maxescopeta = 0
	var maxbazuca = 0
	
	for i in  posicionesArmas:
		print(posicionesArmas[i])
		rng.randomize()
		random = rng.randf_range(0, 1)
		
		if (random > 0.5 && maxescopeta < 4) || maxbazuca == 4:
			newArma = escopeta.instance()
			maxescopeta += 1
			print("creo escopeta")
		else:
			newArma = bazuca.instance() 
			maxbazuca += 1
			print("creo bazuca")
		newArma.position = posicionesArmas[i]

		get_parent().add_child(newArma)
		
	seteado = true
	
func _on_Button_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")
#	get_tree().change_scene('res://Escenas/Menu/PantallaMenu.tscn')
