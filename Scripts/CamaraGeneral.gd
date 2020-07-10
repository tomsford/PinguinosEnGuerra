extends Node

func _ready():
	set_process_input(true)

func _zeppelinFin(camara):
	camara.clear_current() #Camara del zeppelin
	get_tree().get_nodes_in_group("camara")[1].make_current() 
	#[1] es CamaraPinguino y [0] es CamaraP

func cambioTurno(camara):
	camara.make_current() 
