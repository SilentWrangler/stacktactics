class_name Camp
extends Encounter

@export var camp_scene: PackedScene = preload("res://Scenes/camp/rest_scene.tscn")
@export var unit_evolutions: Array[UnitEvolution]
@export var healing_cost: Dictionary

func play_encounter(node: MapNode):
	BattleData.victory = false
	BattleData.camp = self
	BattleData.rewards = rewards
	var campaign = node.campaign
	PlayerData.node_id = node.id
	PlayerData.campaign = campaign.scene_file_path
	
	BattleData.rewards = rewards
	
	campaign.persist_data()
	node.get_tree().change_scene_to_packed(camp_scene)

func can_afford_healing() -> bool:
	return PlayerData.can_afford(healing_cost)
		

func get_available_evolutions(slot: PlayerData.UnitSlot) -> Array[UnitEvolution]:
	var result : Array[UnitEvolution]
	for evo in unit_evolutions:
		if evo.can_evolve(slot):
			result.append(evo)
	return result

func heal(slot: PlayerData.UnitSlot):
	slot.isWounded = false
	PlayerData.take_resources(healing_cost)
