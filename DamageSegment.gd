class_name DamageSegment
extends Resource

@export var type: StringName
@export var amount: int

func _init():
	type = &"pierce"
	amount = 0
