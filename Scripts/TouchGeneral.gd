extends Node


func _ready():
	set_process_input(true)

func _moverDer():
	get_tree().get_nodes_in_group("pinguino")[0]._derecha()

func _moverIzq():
	get_tree().get_nodes_in_group("pinguino")[0]._izquierda()

func _moverArriba():
	get_tree().get_nodes_in_group("pinguino")[0]._arriba()
	
func _disparo():
	get_tree().get_nodes_in_group("pinguino")[0]._disparar()
