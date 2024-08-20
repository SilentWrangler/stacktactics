class_name StepEfect
extends BaseAbilityEffect


func applyEffect(user: Unit, target_hex: Vector2, targets: Array[Unit]):
	user.move(target_hex)
