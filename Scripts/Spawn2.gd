extends Position2D

var enemigo = preload("res://Escenas/Enemigo.tscn")
var enemigoA = preload("res://Escenas/EnemigoAmarillo.tscn")
var enemigoR = preload("res://Escenas/EnemigoRosa.tscn")
var enemigoV = preload("res://Escenas/EnemigoVerde.tscn")

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	var random
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	random = rng.randi_range(0, 3)
	
	var newEnemy
	
	if random == 0:
		newEnemy = enemigo.instance()
	elif random == 1:
		newEnemy = enemigoA.instance()
	elif random == 2:
		newEnemy = enemigoR.instance()
	elif random == 3:
		newEnemy = enemigoV.instance()
	
	get_tree().get_nodes_in_group("SinglePlayer")[0].add_child(newEnemy)
	newEnemy.global_position = global_position
	var data = 2
	newEnemy.direccion(data)
	newEnemy.spawn = 2

