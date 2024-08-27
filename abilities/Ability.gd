class_name Ability
extends Resource

@export_group("Mechanics")
@export var parts: Array[AbilityPart]
@export var tags: Array[StringName]
@export var ap_cost: int = 1
@export_group("Appearance")
@export var Name: String
@export var Description: String
@export var sprite: Texture2D



signal ability_done
func applyAbility(user: Unit, target_hex: Vector2, targets: Array[Unit]):
	for part in parts:
		part.effect.applyEffect(user,target_hex,targets)
		await part.effect.ability_part_finished
	ability_done.emit()
