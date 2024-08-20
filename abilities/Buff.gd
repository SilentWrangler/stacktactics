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

@export var positivity: Positivity

@export var duration: int
@export var amount: int

@export var Name: String
@export var Description: String

@export var tags: Array[StringName]

@export var attribute_mod_attribute: Unit.Attribute
@export var attribute_mod_amount: int

@export var damage_placement: DamagePlacement
@export var damage_attr_scaling: Unit.Attribute
@export_range(0,10) var damage_attr_multiplier: float
@export var damage_flat_modifier: int
@export var damage_type: StringName
