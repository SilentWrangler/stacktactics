class_name GrantBuff
extends BaseAbilityEffect

@export var buff: Buff
@export_group("Duration")
@export var flat_duration: int
@export var duration_scaling_attribute: Unit.Attribute
@export_range(0,10) var duration_scaling_multiplier: float
@export var is_infinite : bool
@export_group("Amount")
@export var flat_amount: int
@export var amount_scaling_attribute: Unit.Attribute
@export_range(0,10) var amount_scaling_multiplier: float

func placeBuffs(targets: Array[Unit], duration: int, amount: int):
	buff.duration = duration
	buff.amount = amount
	for t in targets:
		t.applyBuff(buff)

func applyEffect(user: Unit, _target_hex: Vector2, targets: Array[Unit]):
	var amount = user.calculate_power(flat_amount,amount_scaling_attribute,amount_scaling_multiplier)
	if amount<1:
		ability_part_finished.emit()
		return
	if is_infinite:
		placeBuffs(targets,buff.INFINITE_DURATION,amount)
		ability_part_finished.emit()
		return
	var duration = user.calculate_power(flat_duration, duration_scaling_attribute, duration_scaling_multiplier)
	if duration<0:
		ability_part_finished.emit()
		return
	placeBuffs(targets,duration,amount)
	ability_part_finished.emit()
