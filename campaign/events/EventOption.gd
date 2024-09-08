class_name  EventOption
extends Resource

@export var text: String
@export var conditions: Array[OptionCondition]
@export var outcome: OptionOutcome

func available() -> bool:
	for cond in conditions:
		if not cond.check():
			return false
	return true
