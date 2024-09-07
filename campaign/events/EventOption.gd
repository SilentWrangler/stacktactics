class_name  EventOption
extends Resource

var text: String
var conditions: Array[OptionCondition]
var outcome: OptionOutcome

func available() -> bool:
	for cond in conditions:
		if not cond.check():
			return false
	return true
