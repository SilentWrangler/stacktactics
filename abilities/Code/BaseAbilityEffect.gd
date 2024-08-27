class_name BaseAbilityEffect
extends Resource


signal ability_part_finished
func applyEffect(_user: Unit, _target_hex: Vector2, _targets: Array[Unit]):
	ability_part_finished.emit()
