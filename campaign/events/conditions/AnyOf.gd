class_name AnyOf
extends OptionCondition

@export var conditions: Array[OptionCondition]

func check() -> bool:
	for cond in conditions:
		if cond.check():
			return true
	return false
