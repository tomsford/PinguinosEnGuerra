extends Control

var scene_path_to_load

func _ready():
	for button in $VBoxContainer/HBoxContainer.get_children():
		button.connect("pressed",self,"_on_BotonSeleccion_pressed",[button.scene_to_load])


func _on_BotonSeleccion_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$CambioEscena.show()
	$CambioEscena.fade_in()
	
	
func _on_Atras_pressed():
	get_tree().change_scene('res://Escenas/Menu/PantallaMenu.tscn')


func _on_CambioEscena_fade_finished():
	get_tree().change_scene(scene_path_to_load)
