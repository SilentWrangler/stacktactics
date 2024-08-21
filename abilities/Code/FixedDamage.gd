class_name FixedDamage
extends BaseAbilityEffect

@export var damage: DamageStack

func applyEffect(user: Unit, target_hex: Vector2, targets: Array[Unit]):
	for t in targets:
		t.take_damage(damage)
