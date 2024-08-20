class_name DamageStack
extends Resource


@export var Stack : Array[DamageSegment]


func append_damage(type: StringName, amount: int):
	print("appending %d %s" % [amount, type])
	if amount>0:
		var segment = DamageSegment.new()
		segment.type = type
		segment.amount = amount
		Stack.append(segment)

func prepend_damage(type: StringName, amount: int):
	if amount>0:
		var segment = DamageSegment.new()
		segment.type = type
		segment.amount = amount
		Stack.insert(0, segment)

func head() -> DamageSegment: 
	return Stack[0]

func consume_damage(amount: int):
	Stack[0].amount -= amount
	if Stack[0].amount < 1:
		Stack.remove_at(0)

func lose_damage_segment():
	Stack.remove_at(0)

func debug_text() -> String:
	var msg = "["
	for s in Stack:
		msg += s.type
		msg += " %d "% s.amount
	msg += "]"
	return msg
