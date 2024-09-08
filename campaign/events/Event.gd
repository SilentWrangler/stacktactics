class_name Event
extends Encounter

@export var event_scene: PackedScene

@export var title: String
@export_multiline var text: String

@export var background: Texture2D
@export var side_picture: Texture2D

@export var options: Array[EventOption]

func play_encounter(node: MapNode):
	print("encounter start")
	BattleData.victory = false
	BattleData.event = self
	BattleData.rewards = rewards
	var campaign = node.campaign
		
	PlayerData.node_id = node.id
	PlayerData.campaign = campaign.scene_file_path
	campaign.persist_data()
	node.get_tree().call_deferred("change_scene_to_packed", event_scene)
	
