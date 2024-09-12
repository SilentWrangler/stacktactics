class_name BattleManager
extends Node2D


signal end_turn(side: Unit.Team)
signal start_turn(side: Unit.Team)


@export var unit_list: Array[Unit]
@export var tilemap: TileMapLayer


@export var selected_unit: Unit
@export var unit_parent: Node
@export var unit_template = preload("res://unit.tscn")

@export var player_deploy_locations: Array[Vector2i]
@export var enemy_deploy_locations: Array[Vector2i]

@export_group("Interface")
@export var AbilityButtonContainer: HBoxContainer
@export var blocked_ability_texture: Texture
@export var AP_display: ApDisplay
@export var end_button: TextureButton
@export var turn_indicator: TextureRect
@onready var unit_display = $"../BattleGUI/Control/UnitInfoDisplay"
@export_subgroup("Turn images")
@export var player_turn_tex: Texture2D
@export var enemy_turn_tex: Texture2D

var is_palyer_turn: bool = true

var used_ability: Ability = null



func start_ability_targeting(ability: Ability):
	used_ability = ability
	print("Start using ability")
	print(ability)


func process_ablity(ability: Ability, user: Unit, target_grab: AbilityTargteting.GrabReturn):
	ability.applyAbility(user,target_grab.hex, target_grab.units)
	#await ability.ability_done
	user.action_points -= ability.ap_cost
	if user.side == user.Team.Player:
		select_unit(user)
	user.update_circle()

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	
	
	
	for i in range(len(BattleData.enemy_vanguard)):
		deploy_unit(BattleData.enemy_vanguard[i],enemy_deploy_locations[i],Unit.Team.Enemy)
	for i in range(len(PlayerData.vanguard)):
		var slot = PlayerData.vanguard[i]
		if not slot.isWounded:
			var data = slot.unitData
			var unit = deploy_unit(data,player_deploy_locations[i],Unit.Team.Player)
			unit.slot = slot
			unit.tags.append_array(slot.extra_tags)
			if unit.slot.isPlayer:
				unit.critical = true
	
	var turn = [true,false]
	var weights = [BattleData.player_initiative, BattleData.enemy_initiative]
	
	is_palyer_turn = turn[rng.rand_weighted(weights)]
	for unit in unit_list:
		await  unit.ready
	emit_signal("start_turn", Unit.Team.Player if is_palyer_turn else Unit.Team.Enemy)
	
	if not is_palyer_turn:
		process_ais()
		pass_turn()
	




func can_use_ability(unit: Unit, ability: Ability) -> bool:
	if not is_palyer_turn:
		return false
	if unit.side != Unit.Team.Player:
		return false
	return unit.action_points >= ability.ap_cost


func hex_distance(A: Vector2i, B: Vector2i) -> int:
	
	
	var A_c = convert_to_cube(A)
	var B_c = convert_to_cube(B)
	
	var diff = A_c-B_c
	
	return (abs(diff.x)+abs(diff.y)+abs(diff.z))/2

func is_in_range(unit: Unit, coords: Vector2i) -> bool:
	var dist = hex_distance(unit.map_position, coords)
	print("distance: ",dist)
	return used_ability.parts[0].targeting.radius >= dist

func convert_to_cube(oddq: Vector2i) -> Vector3i:
	var q = oddq.x
	var r = oddq.y - (oddq.x - (oddq.x&1))/2
	return Vector3i(q,r,-q-r)

func convert_to_tilemap(cube: Vector3i) -> Vector2i:
	var col = cube.x
	var row = cube.y + (cube.x-(cube.x&1))/2
	return Vector2i(col,row)

func pass_turn():
	if count_side(Unit.Team.Player)<1:
		back_to_campaign(false)
		return
	if count_side(Unit.Team.Enemy)<1:
		back_to_campaign(true)
		return
	print("turn passed")
	select_unit(null)
	emit_signal("end_turn", Unit.Team.Player if is_palyer_turn else Unit.Team.Enemy)
	is_palyer_turn=not is_palyer_turn
	turn_indicator.texture = player_turn_tex if is_palyer_turn else enemy_turn_tex
	emit_signal("start_turn", Unit.Team.Player if is_palyer_turn else Unit.Team.Enemy)

func deploy_unit(unitData: UnitData, location: Vector2i, side: Unit.Team = Unit.Team.Player):
	var unit = unit_template.instantiate()
	unit.unitData = unitData
	unit.side= side
	unit_parent.add_child(unit)
	var unit_position = tilemap.map_to_local(location)
	unit.map_position = location
	unit.position = unit_position
	end_turn.connect(unit._on_end_turn)
	start_turn.connect(unit._on_start_turn)
	unit_list.append(unit)
	return unit

func select_unit(u: Unit):
	used_ability = null
	
	AP_display.show_icons(false)
	if selected_unit:
		selected_unit.sprite.modulate = Color(1,1,1)
	selected_unit = u
	for ch in AbilityButtonContainer.get_children(): #clean up previous buttons
		ch.free()
	if u:
		unit_display.visible = true
		unit_display.display_from_unit(u)
		AP_display.show_icons()
		AP_display.adjust_amount(u.action_points)
		u.sprite.modulate = Color(1.2,1.2,1.2)
		for ability in u.Abilities:
			var newButton = TextureButton.new()
			newButton.texture_normal = ability.sprite
			newButton.texture_disabled = blocked_ability_texture
			newButton.disabled = not can_use_ability(u, ability)
			newButton.connect("pressed", func(): start_ability_targeting(ability))
			AbilityButtonContainer.add_child(newButton)
	else:
		unit_display.visible = false

func count_side(side: Unit.Team) -> int:
	var result: int = 0
	for u in unit_list:
		if not is_instance_valid(u):
			continue
		if u.side==side:
			result +=1
	return result
	
var selected_unit_list: Array[Unit]

func next_unit():
	var next = selected_unit
	if selected_unit_list.size()>count_side(Unit.Team.Player)-2:
		selected_unit_list.clear()
	for u in unit_list:
		if not is_instance_valid(u):
			continue
		if u==selected_unit:
			continue
		if not u.side == u.Team.Player:
			continue
		if not u.action_points > 0:
			continue
		if u in selected_unit_list:
			continue
		selected_unit_list.append(selected_unit)
		next = u
		break
	select_unit(next)

func unit_on_hex(hex: Vector2i) -> Unit:
	for u in unit_list:
		if not is_instance_valid(u):
			continue
		if u.map_position == hex:
			return u
	return null

func get_taken_hexes() -> Array[Vector2i]:
	var result: Array[Vector2i]
	for u in unit_list:
		if not is_instance_valid(u):
			continue
		result.append(u.map_position)
	return result

func get_free_hexes_in_radius(center: Vector2i, radius:int, exclude_center: bool = false) -> Array[Vector2i]:
	var cube_results: Array[Vector3i]
	var center_cube = convert_to_cube(center)
	
	for q in range(-radius,radius+1):
		for r in range(-radius,radius+1):
			for s in range(-radius,radius+1):
				if (q+r+s)==0:
					cube_results.append(center_cube+Vector3i(q,r,s))
	
	var taken = get_taken_hexes()
	var used_cells = tilemap.get_used_cells()
	var tilemap_results : Array[Vector2i]
	
	for cube in cube_results:
		var tm = convert_to_tilemap(cube)
		if tm not in used_cells:
			continue
		if not exclude_center or tm != center:
			if tm not in taken:
				tilemap_results.append(tm)
	return tilemap_results

func _on_map_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT:
		var coords = tilemap.local_to_map(event.position)
		if used_ability!=null and is_in_range(selected_unit,coords):
			var target_grab = used_ability.parts[0].targeting.grab_targets(self,selected_unit,coords)
			print(target_grab.status)
			if target_grab.status == AbilityTargteting.Status.Success:
				process_ablity(used_ability,selected_unit,target_grab)

func _shortcut_input(event):
	use_abilities(event)
		


func use_abilities(event):
	if selected_unit==null:
		return
	var max_idx= min(len(selected_unit.Abilities),10)
	for i in range(max_idx):
		var ability = selected_unit.Abilities[i]
		var act = "ability_%d" % (i+1)
		if event.is_action_released(act):
			if can_use_ability(selected_unit, ability):
				start_ability_targeting(ability)


func _on_deploy_button_pressed():
	pass # Replace with function body.


func _on_nextunitbutton_pressed():
	next_unit()# Replace with function body.


func _on_end_turn_button_pressed():
	if is_palyer_turn:
			pass_turn()
			end_button.disabled = true
			process_ais()
			pass_turn() 
			end_button.disabled = false

func process_ais():
	for u in unit_list:
		if not is_instance_valid(u):
			continue
		if u.side != u.Team.Enemy:
			continue
		var AI = u.unitData.AI
		if AI!=null:
			AI.processAI(u,self)
			

func check_win_condition(kill: Unit):
	print("++++++", kill.unitData.resource_path, " is dead ******")
	var remaining = count_side(kill.side)
	print("remaining units: ", remaining)
	if kill.critical or remaining<=1: #either critical unit or last one remaining	 
		back_to_campaign(kill.side == kill.Team.Enemy)
			

func back_to_campaign(victory: bool):
	BattleData.victory = victory
	BattleData.from_battle = true
	if victory:
		for u in unit_list:
			if is_instance_valid(u):
				if u.side == Unit.Team.Player:
					if u.slot:
						u.slot.experience += BattleData.battle.exp
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file(PlayerData.campaign)	
