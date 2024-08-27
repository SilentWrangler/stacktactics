class_name StepEfect
extends BaseAbilityEffect


func applyEffect(user: Unit, target_hex: Vector2, _targets: Array[Unit]):
	user.move(target_hex)
	await  user.move_finished
	ability_part_finished.emit()
