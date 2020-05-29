extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Button_pressed():
	ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")
#	get_tree().change_scene('res://Escenas/Menu/PantallaMenu.tscn')


func _on_Button2_pressed():
	ScriptGlobal.goto_scene("res://Escenas/EscenaSeleccion.tscn")
#	get_tree().change_scene('res://Escenas/EscenaSeleccion.tscn')
