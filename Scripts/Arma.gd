extends Area2D

export var numeroArma = 0
export var tamanoExplosion = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Arma_body_entered(body):
	if body.is_in_group("pinguino") :
		if Network.last_movement_id == Network.local_player_id:
			ScriptGlobal.arma = numeroArma
			match numeroArma:
				1:
					ScriptGlobal.agarroEscopeta = true
				2:
					ScriptGlobal.agarroBazuca = true
					ScriptGlobal.balas +=2
					
				3: 
					ScriptGlobal.agarroMolotov = true
					ScriptGlobal.tiros +=2
					#DESAFIO 5
					if ScriptGlobal.desafio1==5:
						ScriptGlobal.completadoDesafio1=true
						var data=String("Completo la recoleccion de molotovs: 1/1")
						ScriptGlobal.update_Recompensa1(data)
					if ScriptGlobal.desafio2==5:
						ScriptGlobal.completadoDesafio2=true
						var data=String("Completo la recoleccion de molotovs: 1/1")
						ScriptGlobal.update_Recompensa2(data)
					
				4:
					ScriptGlobal.agarroBomba = true
					ScriptGlobal.tiros +=2
					#DESAFIO 4
					if ScriptGlobal.desafio1==4:
						ScriptGlobal.completadoDesafio1=true
						var data=String("Completo la recoleccion de bombas: 1/1")
						ScriptGlobal.update_Recompensa1(data)
					if ScriptGlobal.desafio2==4:
						ScriptGlobal.completadoDesafio2=true
						var data=String("Completo la recoleccion de bombas 1/1")
						ScriptGlobal.update_Recompensa2(data)
					
			ScriptGlobal.explosion = tamanoExplosion
			ScriptGlobal.tocoArma = true
			ScriptGlobal.tocoArmaPrimeraVez = true
			ScriptGlobal.actualizadoHUD=false
			
		visible = false
		self.queue_free()
