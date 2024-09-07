class_name Battle
extends Encounter

@export var battle_scene: PackedScene = preload("res://Scenes/battle.tscn")
@export var enemy_vanguard: Array[UnitData]
@export var enemy_reserve:  Array[UnitData]


func play_encounter(node: MapNode):
	BattleData.victory = false
		
	BattleData.enemy_vanguard = enemy_vanguard
	BattleData.enemy_reserve = enemy_reserve
	
	var campaign = node.campaign
	
	BattleData.player_vanguard = campaign.vanguard
	BattleData.player_reserve = campaign.reserve
	
	PlayerData.node_id = node.id
	PlayerData.campaign = campaign.scene_file_path
	
	BattleData.rewards = rewards
	
	campaign.persist_data()
	node.get_tree().change_scene_to_packed(battle_scene)
