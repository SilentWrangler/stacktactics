class_name Rewards
extends Resource

@export var node_rewards: Array[StringName]
@export var unitRewards: Array[UnitData]
@export var next_encounter: Encounter
@export var resource_rewards: Dictionary

func get_text() -> String:
	var msg = ""
	if len(node_rewards)>0:
		msg+="Unlock %d nodes \n" % len(node_rewards)
	if len(unitRewards)>0:
		msg+= "Recruit %d units: \n" % len(unitRewards)
		for u in unitRewards:
			msg+= "	%s\n" % u.unit_name
	if resource_rewards:
		var res_msg=""
		for r in resource_rewards:
			res_msg+="<img>%s</img> %d " %[StaticData.get_resource_texture(r.key),r.value]
		msg+= "Recieve resources: %s \n" % res_msg
	if next_encounter:
		msg+="Face the next encounter...\n"
	return msg
