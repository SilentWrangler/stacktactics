class_name SimpleDamage
extends BaseAbilityEffect

@export var damage_type: StringName
@export var attribute_scaling: Unit.Attribute
@export_range(0,10) var attribute_multiplier: float
@export var flat_damage: int



func applyEffect(user: Unit, _target_hex: Vector2, targets: Array[Unit]):
	print("Trying to deal damage")
	var stack = DamageStack.new()
	var damage = user.calculate_power(flat_damage,attribute_scaling,attribute_multiplier)
	stack.append_damage(damage_type,damage)
	print("pre_mod: "+stack.debug_text())
	user.modify_stack(stack)
	print("post_mod: "+stack.debug_text())
	for t in targets:
		t.take_damage(stack)
	
