class_name HpSegment
extends Resource


const INFINITE_DURATION: int = -1

@export var Type: StringName
@export var amount: int = 0
@export var isVital: bool 
@export var duration: int = INFINITE_DURATION

func _init():
	Type = &"flesh"
	amount = 0
	isVital = false
	duration = INFINITE_DURATION
