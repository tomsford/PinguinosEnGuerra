extends Control

const grav= Vector2(0,-1)
const posicao = Vector2(50,0)
const posicao2 = Vector2(0,-300)
const posicao3 = Vector2(0,-300)
const posicao4 = Vector2(0,-300)
const gravity = 9.8

func _ready():
	$AudioStreamPlayer.play(ScriptGlobal.reproducirV)
	

func _physics_process(delta):
	$Label3.text = str(ScriptGlobal.puntos)
	#$KinematicBody2D.scale.x = 0.22
	$KinematicBody2D/AnimationPlayer.play("correr")
	$KinematicBody2D.move_and_slide(posicao,grav)
	posicao2.y += gravity
	posicao3.y += gravity
	posicao4.y += gravity
	$Mujer.move_and_slide(posicao2,grav)
	$Mujer/AnimationPlayer.play("correr")
	$Hijo1.move_and_slide(posicao3,grav)
	$Hijo1/AnimationPlayer.play("correr")
	$Hijo2.move_and_slide(posicao4,grav)
	$Hijo2/AnimationPlayer.play("correr")
	if Input.is_action_just_pressed("espacio"):
		ScriptGlobal.goto_scene("res://Escenas/Menu/PantallaMenu.tscn")


func _on_Timer_timeout():
	posicao2.y = -400
	
func _on_Timer2_timeout():
	posicao3.y = -350

func _on_Timer3_timeout():
	posicao4.y = -380


func _on_Area2D_body_entered(body):
	if body.is_in_group("padre"):
		$cora1.show()
		$cora2.show()
		$cora1/AnimationPlayer.play("cora1")
		$cora2/AnimationPlayer.play("cora2")
