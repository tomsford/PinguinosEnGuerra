extends RigidBody2D

var explosion = preload("res://Escenas/explosion.tscn")
var hitEnemy=false

# PARTE EXPLOSION BALA
func bang():
	visible = false
	var bang = explosion.instance()
	bang.position = global_position
	get_tree().get_root().add_child(bang)
	queue_free()
	ScriptGlobal.balaActiva = false
	if ScriptGlobal.LAN && Network.last_movement_id == Network.local_player_id:
		print ("le pegue al enemy")
		#Network.sendCambiarTurno()
		ScriptGlobal.preTurno=true
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bala_body_entered(body):
	if get_tree().get_nodes_in_group("enemigo").size() > 0:
		if !ScriptGlobal.LAN:
			if body.is_in_group("enemigo"):
				ScriptGlobal.puntos += 1
				ScriptGlobal.update_puntos()
				body.queue_free()
		elif body.is_in_group("enemigo") && Network.local_player_id== Network.last_movement_id:
			print ("bala choco al jugador")
			var data = {
				id = Network.local_player_id,
				dano= ScriptGlobal.explosion+ScriptGlobal.potenciador
			}
			Network.send_Dano(data)

	bang()
