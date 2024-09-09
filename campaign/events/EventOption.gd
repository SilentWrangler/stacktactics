class_name  EventOption
extends Resource

@export var text: String
@export var conditions: Array[OptionCondition]
@export var outcomes: Array[OptionOutcome]

func available() -> bool:
	for cond in conditions:
		if not cond.check():
			return false
	return true

func apply_outcomes(tree):
	for outcome in outcomes:
		outcome.apply(tree)

func get_tooltip() -> String:
	var msg= ""
	for outcome in outcomes:
		msg += outcome.get_tooltip() + '\n'
	return msg
