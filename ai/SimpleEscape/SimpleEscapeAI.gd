class_name SimpleEscapeAI
extends BaseAI

@export var move_ability_idx: int = 0
@export var search_range: int = 3


var move: Ability

func processAI(unit: Unit, manager: BattleManager):
	move = unit.Abilities[move_ability_idx]
	var pre_targets =  find_closest(unit,manager,opposing_side(unit),search_range)
	var pre_escapes = manager.get_free_hexes_in_radius(unit.map_position,search_range)
	
	var max_enemy_dist = 0
	var escape: Vector2i
	var found = false
	
	
	
	var path
	
	for e in pre_escapes:
		var mmd = 1000;
		for en in pre_targets:
			var d = manager.hex_distance(e,en.map_position)
			if d<mmd:
				mmd = d
		if mmd>max_enemy_dist:
			var p = a_star(manager, unit.map_position,e,
			move.parts[0].targeting.radius,0)
			if not p.is_empty():
				max_enemy_dist = mmd
				escape = e
				found = true
				path = p
	
	if found:
		
		var idx = 1 if path.size() > 1 else 0
		while unit.action_points >= move.ap_cost and idx<len(path):
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
		
