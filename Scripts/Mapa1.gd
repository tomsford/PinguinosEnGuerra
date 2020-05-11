extends Node2D
export(PackedScene) var player

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob = player.instance()
	mob.position = $Position2D.global_position
	add_child(mob)
	
func _on_Button_pressed():
	get_tree().change_scene('res://Escenas/Menu/PantallaMenu.tscn')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
