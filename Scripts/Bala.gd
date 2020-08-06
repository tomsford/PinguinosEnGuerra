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
	if !ScriptGlobal.LAN:
		ScriptGlobal.disparoSinglePlayer=true

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
			##DESAFIO 2 
			if ScriptGlobal.desafio1==2 && ScriptGlobal.arma==1:
				ScriptGlobal.danoEscopetaRecompensa+=ScriptGlobal.explosion+ScriptGlobal.potenciador
				ScriptGlobal.update_Recompensa1(String("Progreso: "+str(ScriptGlobal.danoEscopetaRecompensa)+" /40."))
				if ScriptGlobal.danoEscopetaRecompensa>=40 :
					ScriptGlobal.completadoDesafio1=true
			elif ScriptGlobal.desafio2==2 && ScriptGlobal.arma==1:
				ScriptGlobal.danoEscopetaRecompensa+=ScriptGlobal.explosion+ScriptGlobal.potenciador
				ScriptGlobal.update_Recompensa2(String("Progreso: "+str(ScriptGlobal.danoEscopetaRecompensa)+" /40."))
				if ScriptGlobal.danoEscopetaRecompensa>=40 :
					ScriptGlobal.completadoDesafio2=true
			##DESAFIO 3
			if ScriptGlobal.desafio1==3:
				ScriptGlobal.turnosDanados+=1
				ScriptGlobal.update_Recompensa1(String("Progreso: "+str(ScriptGlobal.turnosDanados)+" /2."))
				print ("turnos danados",ScriptGlobal.turnosDanados)
				if ScriptGlobal.turnosDanados==2:
					ScriptGlobal.completadoDesafio1=true
			elif ScriptGlobal.desafio2==3:
				ScriptGlobal.turnosDanados+=1
				ScriptGlobal.update_Recompensa2(String("Progreso: "+str(ScriptGlobal.turnosDanados)+" /2."))
				if ScriptGlobal.turnosDanados==2:
					ScriptGlobal.completadoDesafio2=true
					
			##DESAFIO 6
			if ScriptGlobal.desafio1==6 && ScriptGlobal.arma==3:
				ScriptGlobal.danoMolotovRecompensa+=ScriptGlobal.explosion+ScriptGlobal.potenciador
				ScriptGlobal.update_Recompensa1(String("Progreso: "+str(ScriptGlobal.danoMolotovRecompensa)+" /80."))
				if ScriptGlobal.danoMolotovRecompensa>=80 :
					ScriptGlobal.completadoDesafio1=true
			elif ScriptGlobal.desafio2==6 && ScriptGlobal.arma==3:
				ScriptGlobal.danoMolotovRecompensa+=ScriptGlobal.explosion+ScriptGlobal.potenciador
				ScriptGlobal.update_Recompensa2(String("Progreso: "+str(ScriptGlobal.danoMolotovRecompensa)+" /80."))
				if ScriptGlobal.danoMolotovRecompensa>=80 :
					ScriptGlobal.completadoDesafio2=true
			
			##DESAFIO 8
			if ScriptGlobal.desafio1==8 && ScriptGlobal.arma==2:
				ScriptGlobal.danoBazucaRecompensa+=ScriptGlobal.explosion+ScriptGlobal.potenciador
				ScriptGlobal.update_Recompensa1(String("Progreso: "+str(ScriptGlobal.danoBazucaRecompensa)+" /60."))
				if ScriptGlobal.danoBazucaRecompensa>=60 :
					ScriptGlobal.completadoDesafio1=true
			elif ScriptGlobal.desafio2==8 && ScriptGlobal.arma==2:
				ScriptGlobal.danoBazucaRecompensa+=ScriptGlobal.explosion+ScriptGlobal.potenciador
				ScriptGlobal.update_Recompensa2(String("Progreso: "+str(ScriptGlobal.danoBazucaRecompensa)+" /60."))
				if ScriptGlobal.danoBazucaRecompensa>=60 :
					ScriptGlobal.completadoDesafio2=true
				
		elif Network.local_player_id== Network.last_movement_id:
			if ScriptGlobal.turnosDanados>0 : 
				ScriptGlobal.turnosDanados-=1
				if ScriptGlobal.desafio1==3:
					ScriptGlobal.update_Recompensa1(String("Progreso: "+str(ScriptGlobal.turnosDanados)+" /2."))
				elif ScriptGlobal.desafio2==3:
					ScriptGlobal.update_Recompensa2(String("Progreso: "+str(ScriptGlobal.turnosDanados)+" /2."))
					
	bang()
