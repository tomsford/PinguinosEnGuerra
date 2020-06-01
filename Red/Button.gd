extends TextureButton
var state = 0
var id = 0
var player_id = -1
var its_me = false
# 0 Empty
# 1 Target
# 2 Attacked
# 3 Target Down
func set_info(player, button):
	player_id = player
	id = button
	state = Network.players[player_id].buttons[id]
	if player_id == Network.local_player_id:
		its_me = true
	_change_state()

func _change_state():
	if state ==2:
		self_modulate = "#0000ff"
		disabled = true
	if state ==3:
		self_modulate = "#ff0000"
		disabled = true
	if state == 1 and its_me:
		self_modulate = "#00ff00"

func _on_Button_pressed():
	state +=2
	_change_state()
	var data = {
	player = player_id,
	button = id,
	newState = state
	} 
	Network.send_movement(data)
	
