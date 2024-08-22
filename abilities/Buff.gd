class_name Buff
extends Resource


enum DamagePlacement{
	Append,
	Prepend
}


enum Positivity{
	Neutral,
	Beneficial,
	Harmful
}

const INFINITE_DURATION = -1

@export var positivity: Positivity

@export var stack_id: StringName

@export_group("Duration")
@export var duration: int
@export var amount: int
@export var decaying: bool

@export_group("Appearance")
@export var Name: String
@export var Description: String
@export var Icon: Texture2D = preload("res://img/hp-icons/swirl.png")

@export_group("Mechanics")
@export var tags: Array[StringName]

@export_subgroup("Alter Attribute")
@export var attribute_mod_attribute: Unit.Attribute
@export var attribute_mod_amount: int

@export_subgroup("Bonus damage")
@export var damage_placement: DamagePlacement
@export var damage_attr_scaling: Unit.Attribute
@export_range(0,10) var damage_attr_multiplier: float
@export var damage_flat_modifier: int
@export var damage_type: StringName

func get_duration_text() -> String:
	if duration == INFINITE_DURATION:
		return "%d/∞" % amount
	else:
		return "%d/%d" % [amount, duration]
