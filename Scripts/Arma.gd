extends Area2D

export var numeroArma = 0
export var tamanoExplosion = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Arma_body_entered(body):
	if body.is_in_group("pinguino"):
			ScriptGlobal.arma = numeroArma
			ScriptGlobal.explosion = tamanoExplosion
			ScriptGlobal.tocoArma = true
			visible = false
			self.queue_free()
