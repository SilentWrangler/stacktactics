extends Node

var victory: bool
var from_battle: bool
var from_event: bool

var event: Event

var player_vanguard: Array[UnitData]
var player_reserve:  Array[UnitData]
var player_initiative: int = 5

var enemy_vanguard: Array[UnitData]
var enemy_reserve:  Array[UnitData]
var enemy_initiative: int = 5

var unlocked_nodes: Array[StringName]
var cleared_nodes: Array[StringName]

var rewards: Rewards
