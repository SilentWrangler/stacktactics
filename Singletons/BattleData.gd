extends Node

var victory: bool
var from_battle: bool
var from_event: bool

var event: Event
var camp: Camp
var battle: Battle

var player_vanguard: Array[UnitData]
var player_reserve:  Array[UnitData]
var player_initiative: int = 5

var enemy_vanguard: Array[UnitData]
var enemy_reserve:  Array[UnitData]
var enemy_initiative: int = 5

var unlocked_nodes: Array[StringName]
var cleared_nodes: Array[StringName]

var rewards: Rewards
var extra_rewards: Array[Rewards]

var max_enemy_deploys: int = 1

func get_data() -> Dictionary:
	return{
		"unlocked_nodes":unlocked_nodes,
		"cleared_nodes":cleared_nodes
	}

func set_data(data: Dictionary):
	unlocked_nodes.clear()
	for un in data["unlocked_nodes"]:
		unlocked_nodes.append(un)
	cleared_nodes.clear()
	for un in data["cleared_nodes"]:
		cleared_nodes.append(un)
