extends Panel
var size = 0
func _ready():
	size = Network.players_IDS.size()
	print("cant players = " + size)
	_initialize()
	if size <4:
		$Tabs/Player4.queue_free()
	if size <3:
		$Tabs/Player3.queue_free()

func _initialize():
		#Turno
	var last = Network.players_IDS.find(Network.last_movement_id)
	if last == size -1:
		last = 0
	else:
		last +=1
	$Label.text = "TURNO DE:\nPlayer"+str(last+1)
	if Network.players_IDS[last] == Network.local_player_id: #My turn
		$Label.text += "\n(TU)"
#		for btn in get_tree().get_nodes_in_group("btn"):
#			btn.disabled = false
#	else:
#		for btn in get_tree().get_nodes_in_group("btn"):
#			btn.disabled = true

#	var count = 0
#	for button in get_tree().get_nodes_in_group("player1")[0].get_children():
#		button.set_info(Network.players_IDS[0],count)
#		count+=1
#	count = 0
#	for button in get_tree().get_nodes_in_group("player2")[0].get_children():
#		button.set_info(Network.players_IDS[1],count)
#		count+=1
#	count = 0
#	if size > 2:
#		for button in get_tree().get_nodes_in_group("player3")[0].get_children():
#			button.set_info(Network.players_IDS[2],count)
#			count+=1
#		count = 0
#	if size > 3:
#		for button in get_tree().get_nodes_in_group("player4")[0].get_children():
#			button.set_info(Network.players_IDS[3],count)
#			count+=1
	

