extends Control

var scene_path_to_load

func _ready():
	$Menu/Jugar.grab_focus()
	for button in $Menu.get_children():
		button.connect("pressed",self,"_on_Button_pressed",[button.scene_to_load])
		
func _on_Button_pressed(scene_to_load):
	#get_tree().change_scene(scene_to_load)
	scene_path_to_load = scene_to_load
	$CambioEscena.show()
	$CambioEscena.fade_in()
	#$CambioEscena.show()
	#$CambioEscena.Cambio_escena()

func _on_CambioEscena_fade_finished():
	get_tree().change_scene(scene_path_to_load)
