class_name BaseAI
extends Resource

func processAI(unit: Unit, manager: BattleManager):
	pass

func opposing_side(unit: Unit) -> Unit.Team:
	if unit.side == unit.Team.Player:
		return unit.Team.Enemy
	return unit.Team.Player

func find_closest(unit: Unit, manager: BattleManager, team: Unit.Team, max_range:int = 999) -> Array[Unit]:
	var result: Array[Unit]
	var min_dist: int = 999
	
	for u in manager.unit_list:
		if not is_instance_valid(u):
			continue #safety first
		if u==unit:
			continue #if we're searching for closest ally, we don't want that to be the unit itself
		if u.side!=team:
			continue
		
		var dist = manager.hex_distance(unit.map_position,u.map_position)
		print(dist)
		if dist>max_range:
			continue
		if dist<min_dist:
			result.clear()
			min_dist=dist
			result.append(u)
			print("New closest: ", dist)
		if dist==min_dist:
			result.append(u)
	return result
		
func find_farthest(unit: Unit, manager: BattleManager, team: Unit.Team, max_range:int = 100) -> Array[Unit]:
	var result: Array[Unit]
	var max_dist: int = 0
	
	for u in manager.unit_list:
		if not is_instance_valid(u):
			continue #safety first
		if u==unit:
			continue 
		if u.side!=team:
			continue
		var dist = manager.hex_distance(unit.map_position,u.map_position)
		if dist>max_range:
			continue
		if dist>max_dist:
			result.clear()
			max_dist=dist
			result.append(u)
		if dist==max_dist:
			result.append(u)
	return result

func find_lowest_hp(unit: Unit, manager: BattleManager, team: Unit.Team, max_range:int = 100) -> Array[Unit]:
	var result: Array[Unit]
	var min_hp: int = 999
	
	for u in manager.unit_list:
		if not is_instance_valid(u):
			continue #safety first
		if u==unit:
			continue 
		if u.side!=team:
			continue
		var dist = manager.hex_distance(unit.map_position,u.map_position)
		if dist>max_range:
			continue
		var hp = u.stack.total()
		if hp<min_hp:
			result.clear()
			min_hp = hp
			result.append(u)
		if hp==min_hp:
			result.append(u)
	return result

func find_highest_hp(unit: Unit, manager: BattleManager, team: Unit.Team, max_range:int = 100) -> Array[Unit]:
	var result: Array[Unit]
	var max_hp: int = 0
	
	for u in manager.unit_list:
		if not is_instance_valid(u):
			continue #safety first
		if u==unit:
			continue 
		if u.side!=team:
			continue
		var dist = manager.hex_distance(unit.map_position,u.map_position)
		if dist>max_range:
			continue
		var hp = u.stack.total()
		if hp>max_hp:
			result.clear()
			max_hp = hp
			result.append(u)
		if hp==max_hp:
			result.append(u)
	return result

func reconstruct_path(came_from: Dictionary, current: Vector2i):
	var total_path: Array[Vector2i]
	total_path.append(current)
	while  current in came_from:
		current = came_from[current]
		total_path.insert(0,current)
	return total_path

func a_star(manager: BattleManager, start: Vector2i, end: Vector2i, step_size: int =1, end_dist: int =0) -> Array[Vector2i]:
	var open_set: Array[Vector2i]
	open_set.append(start)
	
	var came_from : Dictionary
	
	var g_score : Dictionary
	g_score[start] = 0
	
	var f_score: Dictionary
	f_score[start] = manager.hex_distance(start,end)/step_size
	
	while not open_set.is_empty():
		
		var min_score = 999999999
		var current = null
		for hex in open_set:
			if f_score[hex]<min_score:
				current = hex
				min_score = f_score[hex]
		
		if manager.hex_distance(current,end)<=end_dist:
			var path = reconstruct_path(came_from,current)
			return path
		
		open_set.erase(current)
		
		for hex in manager.get_free_hexes_in_radius(current,step_size,true):
			var tentative_g = g_score[current] + 1
			if tentative_g < g_score.get(hex,999999999):
				came_from[hex] = current
				g_score[hex] = tentative_g
				f_score[hex] = tentative_g + manager.hex_distance(hex,end)/step_size
				if hex not in open_set:
					open_set.append(hex)
		
	var empty : Array[Vector2i]
	return empty
	
