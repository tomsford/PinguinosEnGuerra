extends RigidBody2D

var tilemap
export (int) var explosion_size = 40

func _ready():
	
	$CollisionShape2D.shape.radius = ScriptGlobal.explosion / 2
	match ScriptGlobal.arma:
		1:
			$AnimationPlayer.play("explode")
		2:
			$AnimationPlayer.play("nuclear2")
		3: 
			$AnimationPlayer.play("molotov")
		4:
			$AnimationPlayer.play("bomb")
	tilemap = get_tree().get_root().get_node("Mapa1").get_node("Destructable")

func _integrate_forces(state):
	#print(state.get_contact_count())
	for i in range(state.get_contact_count()):
		if state.get_contact_collider_object(i).is_in_group("destructable"):
			var hit = tilemap.world_to_map(state.get_contact_local_position(i))
			tilemap.replace_tile(hit)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
