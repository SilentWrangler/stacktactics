class_name GrantHp
extends BaseAbilityEffect

@export var hp_type: StringName
@export_group("Amount")
@export var attribute_scaling: Unit.Attribute
@export_range(0,10) var attribute_multiplier: float
@export var flat_amount: int

@export_group("Duration")
@export var attribute_scaling_duration: Unit.Attribute
@export_range(0,10) var attribute_multiplier_duration: float
@export var flat_duration: int


func applyEffect(user: Unit, _target_hex: Vector2, targets: Array[Unit]):
	var amount = user.calculate_power(flat_amount,attribute_scaling,attribute_multiplier)
	if amount<1:
		ability_part_finished.emit()
		return
	if flat_duration==-1:
		user.stack.add_hp(hp_type,amount,-1)
		ability_part_finished.emit()
		return
	var duration = user.calculate_power(flat_duration,attribute_scaling_duration,attribute_multiplier_duration)
	if duration<1:
		ability_part_finished.emit()
		return
	user.stack.add_hp(hp_type,amount,duration)
	ability_part_finished.emit()
