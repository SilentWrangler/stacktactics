extends Control

@onready var select_panel = $CampaignSelectPanel
@onready var menu_panel = $MenuPanel
@onready var newgame_panel = $NewGamePanel

@onready var save_list = $CampaignSelectPanel/VBoxContainer/ScrollContainer/saveList
@export var save_button_template = preload("res://Scenes/save_slot_margin_container.tscn")

@onready var campaign_list = $NewGamePanel/VBoxContainer/MarginContainer/ScrollContainer/CampaignList
@export var campaign_template = preload("res://Scenes/campaign_select.tscn")
var selectted_campaign: CampaignDescription

@onready var save_text = $NewGamePanel/VBoxContainer/MarginContainer2/HBoxContainer/filename
@onready var start_button = $NewGamePanel/VBoxContainer/MarginContainer2/HBoxContainer/Start

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cancel_campaign_pressed():
	select_panel.visible = false 
	menu_panel.visible = true


func _on_select_campaign_pressed():
	select_panel.visible = true 
	menu_panel.visible = false
	populate_save_slots()

func populate_save_slots():
	if not DirAccess.dir_exists_absolute(StaticData.save_folder):
		DirAccess.make_dir_recursive_absolute(StaticData.save_folder)
	var dir = DirAccess.open(StaticData.save_folder)
	for ch in save_list.get_children():
		ch.free() #empty the list
	
	for f in dir.get_files():
		var t = save_button_template.instantiate()
		print(f)
		t.button.connect("pressed",func(): load_game(f))
		t.button.text = f
		save_list.add_child(t)

func load_game(savefile_name):	
	var full = StaticData.save_folder + savefile_name
	print(full)
	if not FileAccess.file_exists(full):
			return # Error! We don't have a save to load.
	var save_file = FileAccess.open(full, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		else:
			PlayerData.set_data(json.data["player_data"])
			BattleData.set_data(json.data["battle_data"])
			BattleData.from_event = true
			print(PlayerData.campaign)
			get_tree().change_scene_to_file(PlayerData.campaign)

func _on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_new_campaign_pressed():
	select_panel.visible = false
	newgame_panel.visible = true
	populate_campaigns()
	


func _on_cancel_new_campaign_pressed():
	select_panel.visible = true
	newgame_panel.visible = false


func populate_campaigns():
	for ch in campaign_list.get_children():
		ch.free() #empty the list
	var group = ButtonGroup.new()
	for c in ResourceLoader.list_directory("res://campaign/descriptions/"):
		var desc : CampaignDescription
		desc = ResourceLoader.load("res://campaign/descriptions/%s" % c) as CampaignDescription
		var t = campaign_template.instantiate()
		t.set_desc(desc)
		t.button_group = group
		t.connect("toggled",func(istoggled: bool): if istoggled: campaign_selection_callback(desc))
		campaign_list.add_child(t)

func campaign_selection_callback(cd: CampaignDescription):
	selectted_campaign = cd
	save_text.clear()
	save_text.insert_text(cd.default_save,0,0)

func _on_filename_text_changed():
	if selectted_campaign:
		var full = StaticData.save_folder + save_text.text + ".save"
		start_button.disabled = save_text.text == "" or FileAccess.file_exists(full)
	else:
		start_button.disabled = true


func _on_start_pressed():
	if selectted_campaign:
		PlayerData.savefile_name =  save_text.text
		PlayerData.campaign = selectted_campaign.file
		PlayerData.node_id = selectted_campaign.starting_node
		get_tree().change_scene_to_file(PlayerData.campaign)
