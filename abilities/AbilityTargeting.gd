class_name AbilityTargteting
extends Resource

enum TargetedUnits{
	Hex,
	Self,
	Single,
	All,
	Random
}

enum AreaType{
	Line,
	Arc,
	Splash,
	Field
}

enum AllegianceFilter{
	All,
	Enemy,
	Friend
}


@export var targets: TargetedUnits
@export var range: int

@export var target_hex: Vector2
@export var select_target_hex: bool

@export_group("AreaFilter")
@export var area: AreaType
@export var area_size: int
@export var target_allegiance: AllegianceFilter
@export var require_tags: Array[StringName]
@export var exclude_tags: Array[StringName]

enum Status{
	Success,
	NeedMoreInput,
	NoValidTargets
}

class GrabReturn:
	var status: Status
	var hex: Vector2i
	var hex2: Vector2i
	var units: Array[Unit]


func allegiance_check(user: Unit, target: Unit, filter: AllegianceFilter) -> bool:
	if filter==AllegianceFilter.All:
		return true
	elif filter==AllegianceFilter.Enemy:
		return user.side != target.side
	elif filter == AllegianceFilter.Friend:
		return user.side == target.side
	else:
		return false

func check_tags(target: Unit, tag_array: Array[StringName], exclude = false):
	if tag_array.is_empty():
		return true
	for tag in tag_array:
		if target.has_tag(tag):
			return not exclude
	return exclude

func run_checks(user: Unit, target: Unit) -> bool:
	if target == null:
		return false
	if not allegiance_check(user, target, target_allegiance):
		return false
	if not check_tags(target, require_tags):
		return false
	if not check_tags(target, exclude_tags, true):
		return false
	return true
		
func grab_targets(manager: BattleManager,user: Unit, target_hex: Vector2i) -> GrabReturn:
	var result = GrabReturn.new()
	if targets == TargetedUnits.Hex:
		if manager.unit_on_hex(target_hex) != null:
			result.status = Status.NoValidTargets
			return result
		elif target_hex not in manager.tilemap.get_used_cells():
			result.status = Status.NoValidTargets
			return result
		else:
			result.status= Status.Success
			result.hex = target_hex
			return result
	elif  targets == TargetedUnits.Self:
		if target_hex==user.map_position:
			result.hex = target_hex
			result.units.append(user)
			result.status = Status.Success
			return result
		else:
			result.status = Status.NoValidTargets
			return result
	elif targets == TargetedUnits.Single:
		var unit = manager.unit_on_hex(target_hex)
		if run_checks(user, unit):
			result.hex = target_hex
			result.units.append(unit)
			result.status = Status.Success
			return result
		else:
			result.status = Status.NoValidTargets
			return result
			
	return result
	
	
