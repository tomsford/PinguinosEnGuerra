extends Area2D

export var numeroRegalo = 0

func _ready():
	pass 

func _on_Regalo_body_entered(body):
		if body.is_in_group("pinguino"):
			ScriptGlobal.regalo = numeroRegalo
			ScriptGlobal.accionRegalo()
			visible = false
			self.queue_free()

