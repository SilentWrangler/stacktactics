class_name Campaign
extends Node2D

var nodeList: Dictionary



@export var player_location: StringName

@onready var player_sprite = $PlayerSprite
@onready var resource_display = $ResourceDisplay



func unlockNodes(node_ids: Array[StringName]):
	for node in nodeList:
		if node in node_ids:
			nodeList[node].locked = false
	for node in nodeList:
		nodeList[node].refresh()

func clear_nodes(node_ids: Array[StringName]):
	for node in nodeList:
		if node in node_ids:
			nodeList[node].cleared = true

# Called when the node enters the scene tree for the first time.
func _ready():
	move_player(player_location,false)
	if BattleData.from_battle or BattleData.from_event:
		unlockNodes(BattleData.unlocked_nodes)
		clear_nodes(BattleData.cleared_nodes)
		move_player(PlayerData.node_id, false)
		BattleData.from_battle = false
		for reward in BattleData.extra_rewards:
			giveRewards(reward)
		BattleData.extra_rewards.clear()
		if BattleData.victory:
			print("Victory!")
			BattleData.victory = false
			var node = nodeList[PlayerData.node_id]
			giveRewards(BattleData.rewards)
			node.cleared = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func giveRewards(rewards: Rewards):
	print("giving rewards: ")
	if not rewards:
		return
	PlayerData.give_resources(rewards.resource_rewards)
	if resource_display:
		resource_display.refresh()
	unlockNodes(rewards.node_rewards)
	for unit in rewards.unitRewards:
		PlayerData.addUnit(unit)
	
	if rewards.next_encounter:
		var n = nodeList[player_location]
		rewards.next_encounter.play_encounter(n)

func move_player(to: StringName, tween: bool = true):
	player_location=to
	var target_node = nodeList[to]
	if tween:
		var t = player_sprite.create_tween()
		t.tween_property(player_sprite,"position",target_node.position,1.0)
	else:
		player_sprite.position = target_node.position

func persist_unlocked():
	BattleData.unlocked_nodes.clear()
	for n in nodeList:
		if not nodeList[n].locked:
			BattleData.unlocked_nodes.append(n)

func persist_cleared():
	BattleData.cleared_nodes.clear()
	for n in nodeList:
		if nodeList[n].cleared:
			BattleData.cleared_nodes.append(n)

func persist_data(to_file=false):
	persist_unlocked()
	persist_cleared()
	if to_file:
		var save_dict = {
			"player_data":PlayerData.get_data(),
			"battle_data":BattleData.get_data()
		}
		print(save_dict)
		var save_file = FileAccess.open(StaticData.save_folder +"%s.save" % PlayerData.savefile_name, FileAccess.WRITE)
		var json_string = JSON.stringify(save_dict)
		save_file.store_line(json_string)


func _on_save_button_pressed():
	persist_data(true)


func _on_load_buttol_pressed():
	if not FileAccess.file_exists(StaticData.save_folder + "%s.save" % PlayerData.savefile_name):
			return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://saves/%s.save" % PlayerData.savefile_name, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		else:
			PlayerData.set_data(json.data["player_data"])
			BattleData.set_data(json.data["battle_data"])
			BattleData.from_event = true
			get_tree().reload_current_scene()
			
			


func _on_save_button_2_pressed():
	persist_data(true)
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
