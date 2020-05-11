extends RigidBody2D

var tilemap
export (int) var explosion_size = 50

func _ready():
	$CollisionShape2D.shape.radius = explosion_size / 2
	$AnimationPlayer.play("explode")
	tilemap = get_tree().get_root().get_node("Mapa1").get_node("Destructable")

func _integrate_forces(state):
	#print(state.get_contact_count())
	for i in range(state.get_contact_count()):
		if state.get_contact_collider_object(i).is_in_group("destructable"):
			var hit = tilemap.world_to_map(state.get_contact_local_position(i))
			tilemap.replace_tile(hit)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
