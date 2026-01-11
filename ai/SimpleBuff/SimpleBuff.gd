class_name SimpleBuffAI
extends BaseAI

@export var move_ability_idx: int = 0
@export var buff_ability_idx: int = 2
@export var search_range: int = 3

var buff: Ability
var move: Ability

func processAI(unit: Unit, manager: BattleManager):
	buff =  unit.Abilities[buff_ability_idx]
	move = unit.Abilities[move_ability_idx]
	var pre_targets =  find_closest(unit,manager,unit.side,search_range)
	var targets_with_paths: Dictionary
	var targets_within_range = find_closest(unit,manager,unit.side,buff.parts[0].targeting.radius)
	for t in pre_targets:
		var p = a_star(manager, unit.map_position,t.map_position,
			move.parts[0].targeting.radius,
			buff.parts[0].targeting.radius)
		if not p.is_empty():
			targets_with_paths[t] = p
	if targets_with_paths.is_empty():
		return
	var target = targets_with_paths.keys().pick_random()
	var dist = manager.hex_distance(unit.map_position,target.map_position)
	if dist<=buff.parts[0].targeting.radius:
		full_attack(unit,manager,target)
		return
	
	var path = targets_with_paths[target]
	var idx = 1 if path.size() > 1 else 0
	while unit.action_points >= move.ap_cost:
		var grab = move.parts[0].targeting.grab_targets(manager,unit,path[idx])
		if grab.status == AbilityTargteting.Status.Success:
			manager.process_ablity(move,unit,grab)
			await move.ability_done
			if not is_instance_valid(unit):
				print("WHAT THE FUCK")
				return
			print("unit moved, ap left: ",unit.action_points," new pos: ", unit.map_position)
			idx+=1
		else:
			return
		if not is_instance_valid(target):
			return
		dist = manager.hex_distance(unit.map_position,target.map_position)
		if dist<=buff.parts[0].targeting.radius:
			full_attack(unit,manager,target)
			return
		
		

func full_attack(unit: Unit, manager: BattleManager, target: Unit):
	var grab = buff.parts[0].targeting.grab_targets(manager,unit,target.map_position)
	manager.process_ablity(buff,unit,grab)
		
	
