extends Area2D

export var numeroRegalo = 0

func _ready():
	pass 

func _on_Regalo_body_entered(body):
		if body.is_in_group("pinguino") :
			if Network.last_movement_id == Network.local_player_id && !body.is_in_group("enemigo"):
				ScriptGlobal.tocoRegalo = true
				ScriptGlobal.regalo = numeroRegalo
			visible = false
			self.queue_free()

