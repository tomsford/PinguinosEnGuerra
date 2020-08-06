extends Node

var posicion = 0

func _ready():
	set_process_input(true)

func _disparo():
	get_tree().get_nodes_in_group("pinguino")[0]._disparar()

func _pad():
	posicion = get_tree().get_nodes_in_group("pad")[0].get_value() * 100
	return posicion
