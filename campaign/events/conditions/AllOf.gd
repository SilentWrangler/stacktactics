class_name AllOf
extends OptionCondition

@export var conditions: Array[OptionCondition]

func check() -> bool:
	for cond in conditions:
		if not cond.check():
			return false
	return true
