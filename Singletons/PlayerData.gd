extends Node

var vanguard: Array[UnitSlot]
var reserve: Array[UnitSlot]
var initiative = 5

const VANGUARD_SIZE = 4

class UnitSlot:
	var unitData: UnitData
	var exp: int
	var isPlayer: bool
	var isWounded: bool
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
