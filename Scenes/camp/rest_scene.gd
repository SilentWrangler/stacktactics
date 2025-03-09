class_name RestManager
extends Control


@onready var resource_display = $VBoxContainer/ResourceDisplay
#Warning section
@export var warning_text_color = Color("dc6619")
@onready var warning_blocker = $ConfirmationBlocker
@onready var warning_title = $ConfirmationBlocker/NinePatchRect/VBoxContainer/WarningTitle
@onready var warning_message = $ConfirmationBlocker/NinePatchRect/VBoxContainer/WarningMessage
@onready var cancel_button = $ConfirmationBlocker/NinePatchRect/VBoxContainer/HBoxContainer/CancelButton
@onready var confirm_button = $ConfirmationBlocker/NinePatchRect/VBoxContainer/HBoxContainer/ConfirmButton
signal warining_interacted(confirmed: bool)
#end warning section

@export var selection_template = preload("res://Scenes/camp/unit_camp_selector.tscn")
@export var evolution_template = preload("res://Scenes/camp/unit_evolve_selector.tscn")
@onready var vanguard_box = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/Vanguard"
@onready var reserve_box = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/ScrollContainer/Reserve"
@onready var manage_units_display = $"VBoxContainer/TabContainer/Manage Units/UnitInfoDisplay1"

@onready var button_swap_vanguard = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/HBoxContainer/ButtonToFromVanguard"
@onready var button_heal = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/HBoxContainer/ButtonHeal"
@onready var swap_left = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/HBoxContainer/ButtonLeft"
@onready var swap_right = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/HBoxContainer/ButtonRight"
@onready var button_dismiss = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/HBoxContainer/ButtonDismiss"
@onready var heal_all_button = $"VBoxContainer/TabContainer/Manage Units/VBoxContainer/ButtonHealAll"

@onready var unit_box = $"VBoxContainer/TabContainer/Evolve Units/VBoxContainer/HBoxContainer/ScrollContainer/playerunitBox"
@onready var evo_box = $"VBoxContainer/TabContainer/Evolve Units/VBoxContainer/HBoxContainer/ScrollContainer2/evolvebox"

@onready var from_display = $"VBoxContainer/TabContainer/Evolve Units/VBoxContainer/HBoxContainer/UnitInfoDisplay_evo"
@onready var evo_display = $"VBoxContainer/TabContainer/Evolve Units/VBoxContainer/HBoxContainer/UnitInfoDisplay_evo_from"


class Selection:
	var is_vanguard: bool
	var slot: PlayerData.UnitSlot


var selected : Array[Selection]

var selected_evo: Selection
var evo_target: UnitEvolution

func clear_boxes():
	for ch in vanguard_box.get_children():
		ch.free()
	for ch in reserve_box.get_children():
		ch.free()

func place_selectors():
	clear_boxes()
	for slot in PlayerData.vanguard:
		var sel = Selection.new()
		sel.is_vanguard = true
		sel.slot = slot
		var t = selection_template.instantiate()
		t.selection = sel
		t.connect("toggled", func(is_toggled: bool): selection_callback(is_toggled, sel))
		vanguard_box.add_child(t)
		t.display(sel)
	for slot in PlayerData.reserve:
		var sel = Selection.new()
		sel.is_vanguard = false
		sel.slot = slot
		var t = selection_template.instantiate()
		t.selection = sel
		t.connect("toggled", func(is_toggled: bool): selection_callback(is_toggled, sel))
		reserve_box.add_child(t)
		t.display(sel)
	button_availability()

func place_evo_units():
	for ch in unit_box.get_children():
		ch.free()
	for ch in evo_box.get_children():
		ch.free()
	var group = ButtonGroup.new()
	for s in PlayerData.vanguard:
		if not s.isPlayer:
			var sel = Selection.new()
			sel.is_vanguard = true
			sel.slot = s
			var t = selection_template.instantiate()
			t.selection = sel
			t.connect("toggled", func(is_toggled: bool): evo_sel_callback(is_toggled, sel))
			t.button_group = group
			unit_box.add_child(t)
			t.display(sel)
	for s in PlayerData.reserve:
		var sel = Selection.new()
		sel.is_vanguard = false
		sel.slot = s
		var t = selection_template.instantiate()
		t.selection = sel
		t.connect("toggled", func(is_toggled: bool): evo_sel_callback(is_toggled, sel))
		t.button_group = group
		unit_box.add_child(t)
		t.display(sel)

func evo_sel_callback(_is_toggled: bool, sel: Selection):
	from_display.display_from_slot(sel.slot)
	selected_evo = sel
	place_evolutions()

func evo_targ_sel_callback(_is_toggled: bool, evo: UnitEvolution):
	evo_display.display_evo(selected_evo.slot,evo.evolved_unit_data)
	evo_target = evo


func place_evolutions():
	var group = ButtonGroup.new()
	for e in BattleData.camp.unit_evolutions:
		if e.can_evolve(selected_evo.slot):
			var t = evolution_template.instantiate()
			t.button_group = group
			evo_box.add_child(t)
			t.display(e.evolved_unit_data)

func selection_callback(is_toggled: bool, selection: Selection):
	manage_units_display.display_from_slot(selection.slot)
	print(is_toggled)
	if is_toggled:
		selected.append(selection)
	else:
		selected.erase(selection)
	button_availability()



func button_availability():
	print(selected)
	button_swap_vanguard.disabled = false
	button_heal.disabled = true
	swap_left.disabled = false
	swap_right.disabled = false
	button_dismiss.disabled = false
	
	
	var cost_for_all = calc_healing_cost_for_all()
	heal_all_button.disabled = not PlayerData.can_afford(cost_for_all)
	
	if selected.is_empty():
		button_swap_vanguard.disabled = true
		button_heal .disabled = true
		swap_left.disabled = true
		swap_right.disabled = true
		button_dismiss.disabled = true
		return
		
	var in_v_count = 0
	var in_r_count = 0
	var player_detected = false
	for s in selected:
		if s.slot.isPlayer:
			print('PLAYER SELECTED')
			player_detected = true
			button_dismiss.disabled = true
		if s.slot.isWounded:
			var cost = calc_healing_cost_for_selected()
			button_heal.disabled = not PlayerData.can_afford(cost)
		if s.is_vanguard:
			in_v_count += 1
		else:
			in_r_count +=1
	print("vanguard: %d reserve: %d" % [in_v_count,in_r_count])
	var swapp = in_r_count > 0 or in_v_count != 1
	swap_left.disabled = swapp
	swap_right.disabled = swapp
	var predicted_v = PlayerData.vanguard.size() - in_v_count + in_r_count 
	print("predicted vanguard: %d" %predicted_v)
	button_swap_vanguard.disabled = player_detected or predicted_v > PlayerData.VANGUARD_SIZE
	


func warn(
	title: String, message: String,
	confirm_text: String = "Confirm",
	cancel_text: String = "Cancel", 
	confirm_callback: Callable = func(): pass,
	cancel_callback: Callable = func(): pass):
	warning_blocker.visible = true
	warning_title.text = title
	warning_message.text = message
	confirm_button.text = confirm_text
	cancel_button.text = cancel_text
	var confirmed = await warining_interacted
	if confirmed:
		confirm_callback.call()
	else:
		cancel_callback.call()

func refresh():
	selected.clear()
	resource_display.refresh()
	place_selectors()
	place_evo_units()


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_confirm_button_pressed():
	warining_interacted.emit(true)


func _on_cancel_button_pressed():
	warining_interacted.emit(false)


func _on_warining_interacted(confirmed):
	warning_blocker.visible=false


func _on_button_leave_pressed():
	BattleData.victory = true
	BattleData.from_event = true
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file(PlayerData.campaign)	


func _on_button_to_from_vanguard_pressed():
	for s in selected:
		if s.is_vanguard:
			PlayerData.vanguard.erase(s.slot)
			PlayerData.reserve.append(s.slot)
		else:
			PlayerData.reserve.erase(s.slot)
			PlayerData.vanguard.append(s.slot)
	
	refresh()


func _on_button_right_pressed():
	var s = selected[0]
	var idx = PlayerData.vanguard.find(s.slot)
	var swap_idx = idx + 1
	if swap_idx>=PlayerData.vanguard.size():
		swap_idx = 0
	var buf = PlayerData.vanguard[swap_idx]
	PlayerData.vanguard[swap_idx] = s.slot
	PlayerData.vanguard[idx] = buf
	refresh()
	


func _on_button_left_pressed():
	var s = selected[0]
	var idx = PlayerData.vanguard.find(s.slot)
	var swap_idx = idx - 1
	if swap_idx<0:
		swap_idx = PlayerData.vanguard.size() - 1
	var buf = PlayerData.vanguard[swap_idx]
	PlayerData.vanguard[swap_idx] = s.slot
	PlayerData.vanguard[idx] = buf
	refresh()


func calc_healing_cost_for_selected() -> Dictionary:
	var wounded_count = 0
	for s in selected:
		if s.slot.isWounded:
			wounded_count+=1
	
	var total_cost = PlayerData.multiply_resources(BattleData.camp.healing_cost, wounded_count)
	return total_cost

func calc_healing_cost_for_all() -> Dictionary:
	var wounded = all_wounded()
	return PlayerData.multiply_resources(BattleData.camp.healing_cost, wounded)


func _on_button_heal_pressed():
	var cost = calc_healing_cost_for_selected()
	var msg = "Healing units will cost %s. Continue?" % StaticData.get_resuorce_bbcode(cost)
	warn("Healing Units",msg,"Heal","Cancel",heal_selected)


func all_wounded() -> int:
	var result = 0
	for s in PlayerData.vanguard:
		if s.isWounded:
			result += 1
	for s in PlayerData.reserve:
		if s.isWounded:
			result+=1
	return result

func _on_button_heal_all_pressed():
	var cost = calc_healing_cost_for_all()
	var msg = "Healing units will cost %s. Continue?" % StaticData.get_resuorce_bbcode(cost)
	warn("Healing Units",msg,"Heal","Cancel",heal_selected)
	
func heal_selected():
	var cost = calc_healing_cost_for_selected()
	PlayerData.take_resources(cost)
	for s in selected:
		s.slot.isWounded = false
	refresh()
	

func heal_all():
	var cost = calc_healing_cost_for_all()
	PlayerData.take_resources(cost)
	
	for s in PlayerData.vanguard:
		s.isWounded = false
	for s in PlayerData.reserve:
		s.isWounded = false
	
	refresh()
