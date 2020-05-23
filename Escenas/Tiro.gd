extends Node2D

var gravity = -9.8
var num_of_points = 60
export (float,100) var strength = 30.0 setget set_strength
var aiming = false
var ver = false
var contacto = false

func _input(event):
	if event.is_action_pressed("lefft_mouse"):
		aiming = true
	if event.is_action_released("lefft_mouse"):
		aiming = false
		ver = true
		#var newBala = $Bala.instance()
		#newBala.visible = true
		if $Bala != null:
			$Bala.visible = true
		$Line2D.visible = false
		#$Pivot/TextureProgress.visible = false
		mover()
		

	if aiming:
		if event is InputEventMouseMotion:
			self.strength += event.relative.x / 5.0


func mover():
	#var contacto = false
	for point in $Line2D.points:
		#contacto = $Bala.get_contacto()
		#print(contacto)
		
		var t = Timer.new()
		t.set_wait_time(0.025)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		if !contacto:
			$Bala.position = point
		if contacto:
			$Line2D.points = []
		

func _physics_process(delta):
	if !ver:
		$Bala.visible = false
	if aiming:
		$Pivot.rotation = $Pivot.global_position.angle_to_point(get_global_mouse_position()) + PI

func calculate_trajectory():
	var points = []
	var total_air_time = 20.0
	var x_component = strength * cos($Pivot.rotation * -1.0)
	var y_component = strength * sin($Pivot.rotation * -1.0)
	for point in num_of_points:
		var time = total_air_time * point / num_of_points
		var dx = time * x_component
		var dy = -1.0 * (time * y_component + 0.5 * gravity * time * time)
		
		points.append(Vector2(dx,dy))
	
	$Line2D.points = points
		
	
func set_strength(num):
	strength = num
	clamp(strength,0.0,100.0)
	
	if $Pivot/TextureProgress:
		$Pivot/TextureProgress.value = num
	
	calculate_trajectory()


func _on_Bala_body_entered(body):
	contacto = true
	
