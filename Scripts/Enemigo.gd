extends KinematicBody2D

var posicao = Vector2()
const gravity = 9.8
const grav= Vector2(0,-1)
var derecha = false
var spawn

func _physics_process(delta):
	if derecha:
		$Sprite.scale.x = -0.5
		$Sprite.scale.y = 0.5
		posicao.x = -ScriptGlobal.velocidad
	else:
		$Sprite.scale.x = 0.5
		$Sprite.scale.y = 0.5
		posicao.x = ScriptGlobal.velocidad
	posicao.y += gravity
	$AnimationPlayer.play("caminar")
	move_and_slide(posicao,grav)
	
	#if(get_slide_collision(get_slide_count()-1)!= null):
	if(get_slide_count()>0 and get_slide_collision(get_slide_count()-1)!= null):
		var colisionador = get_slide_collision(get_slide_count()-1).collider
		if(colisionador.is_in_group("player")):
			_reproducir()
			ScriptGlobal.vida -= 10
			ScriptGlobal.update_vida()
			self.queue_free()
			#print("choco") #PERDISTE UNA VIDA

func direccion(data):
	if data == 1:
		derecha = true

func _on_Timer_timeout():
	posicao.y = -400

func _reproducir():
	if !ScriptGlobal.mute:
		$SFX/TocoEnemigo.play()
