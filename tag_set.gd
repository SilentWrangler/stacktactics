class_name TagSet
extends Resource

@export var tags: Array[StringName]

func match_all(slot: PlayerData.UnitSlot, result_if_empty: bool = true):
	if tags.is_empty():
		return result_if_empty
	var unit_tags = slot.unitData.inherent_tags.duplicate()
	unit_tags.append_array(slot.extra_tags)
	return tags.all(func(tag): unit_tags.has(tag))

func match_any(slot: PlayerData.UnitSlot, result_if_empty: bool = true):
	if tags.is_empty():
		return result_if_empty
	var unit_tags = slot.unitData.inherent_tags.duplicate()
	unit_tags.append_array(slot.extra_tags)
	return tags.any(func(tag): unit_tags.has(tag))
