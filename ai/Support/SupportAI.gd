class_name SupportAI
extends BaseAI


@export var move_ability_idx: int = 0
@export var attack_ability_idx: int = 1
@export var support_ability_idx: int = 2
@export var search_range: int = 3
@export var keep_distance: int = 2

@export var EscapeAI: BaseAI
@export var AtttackAI: BaseAI
@export var BuffAI: BaseAI

var attack: Ability
var move: Ability
var support: Ability

func processAI(unit: Unit, manager: BattleManager):
	attack =  unit.Abilities[attack_ability_idx]
	move = unit.Abilities[move_ability_idx]
	support = unit.Abilities[support_ability_idx]
	var pre_enemies =  find_closest(unit,manager,opposing_side(unit),search_range)
	var pre_allies = find_closest(unit,manager,unit.side,search_range)
	if len(pre_allies)>0:
		var dist_between_ally = manager.hex_distance(pre_allies[0].map_position,unit.map_position)
		var dist_between_enemy = manager.hex_distance(pre_enemies[0].map_position,unit.map_position)
		if dist_between_enemy<dist_between_ally:
			EscapeAI.processAI(unit,manager)
		else:
			support_routine(unit,manager)
	else:
		attack_routine(unit, manager)
	
		
func attack_routine(unit: Unit, manager: BattleManager):
	AtttackAI.processAI(unit,manager)

func support_routine(unit: Unit, manager:BattleManager):
	BuffAI.processAI(unit,manager)

func full_attack(unit: Unit, manager: BattleManager, target: Unit):
	while unit.action_points>=attack.ap_cost:
		var grab = attack.parts[0].targeting.grab_targets(manager,unit,target.map_position)
		manager.process_ablity(attack,unit,grab)
