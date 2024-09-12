extends Node

var node_id: StringName
var campaign

var vanguard: Array[UnitSlot]
var reserve: Array[UnitSlot]
var initiative = 5

var resources: Dictionary
var flags : Array[StringName]

var player_name = "The Player"

const VANGUARD_SIZE = 4

class UnitSlot:
	var unitData: UnitData
	var experience: int
	var isPlayer: bool
	var isWounded: bool
	var extra_tags: Array[StringName]
	
	func get_tags() -> Array[StringName]:
		var tags = unitData.inherent_tags.duplicate()
		tags.append_array(extra_tags)
		return tags
	
	func get_unit_name() -> String:
		if isPlayer:
			return PlayerData.player_name + exp_addition()
		return unitData.unit_name + exp_addition()
	
	func exp_addition() -> String:
		return ' %d [img]res://img/hp-icons/swirl.png[/img]' % experience
	
	func get_desc() -> String:
		if isPlayer:
			return "It's you. The one and only."
		return unitData.unit_description
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if vanguard.size()<1:
		var playerSlot = UnitSlot.new()
		playerSlot.isPlayer = true
		playerSlot.unitData = getPlayerUnit()
		vanguard.append(playerSlot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getPlayerUnit() -> UnitData:
	return load("res://Units/humanoids/humans/nornoth_merc.tres")

func addUnit(unitData: UnitData):
	var slot = UnitSlot.new()
	slot.unitData = unitData
	if vanguard.size()<VANGUARD_SIZE:
		vanguard.append(slot)
	else:
		reserve.append(slot)

func can_afford(cost: Dictionary) -> bool:
	for k in cost:
		var have = resources.get(k,0)
		if have<cost[k]:
			return false
	return true

func give_resources(income: Dictionary):
	print("giving resources")
	print(income.size())
	for k in income:
		if income[k]<0:
			push_error("income values should not be negative")
		var have = resources.get_or_add(k,0)
		
		resources[k] = have + income[k]
		print("%s: Had  %d recieved %d, total %d" % [k, have, income[k], resources[k]])

func take_resources(expense: Dictionary, ensure_zero=true):
	for k in expense:
		if expense[k]<0:
			push_error("expense values should not be negative")
		var have = resources.get_or_add(k,0)
		resources[k] = have - expense[k]
		if ensure_zero and resources[k]<0:
			resources[k]=0

func dismiss_unit(slot: UnitSlot):
	if slot.isPlayer:
		return false
	vanguard.erase(slot)
	reserve.erase(slot)


func multiply_resources(base: Dictionary, multiplier: int) -> Dictionary:
	var result = {}
	for k in base:
		result[k] = base[k] * multiplier
	return result
