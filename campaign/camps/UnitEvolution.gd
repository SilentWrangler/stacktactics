class_name UnitEvolution
extends Resource

@export var required_exp: int
@export var banned_tags: TagSet
@export var required_set_variants: Array[TagSet]
@export var speciic_unit_type: bool
@export var specific_unit_id: StringName
@export var evolved_unit_data: UnitData


func can_evolve(slot: PlayerData.UnitSlot) -> bool:
	if slot.isPlayer:
		return false #players can never ecolve, they use different advancement system
	if speciic_unit_type:
		return slot.unitData.unit_type_ID==specific_unit_id
	if banned_tags.match_any(slot,false):
		return false
	return required_set_variants.any(func(tags): tags.match_all(slot))

func can_afford() -> bool:
	return true

func unit_allowed(slot: PlayerData.UnitSlot) -> bool:
	return can_afford() and slot.experience >= required_exp and can_evolve(slot)
