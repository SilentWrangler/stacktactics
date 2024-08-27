class_name  MapNode
extends Node2D

enum nodeType{
	Battle,
	Camp,
	Event,
	BossBattle
}
@onready var campaign: Campaign = $".."
@onready var sprite: Sprite2D = $Sprite2D

@export var locked: bool
@export var type: nodeType
@export var id: StringName

@export var cleared: bool

@export var paths: Array[StringName]

@export var battle_scene: PackedScene

@export_group("encounter_data")
@export var enemy_vanguard: Array[UnitData]
@export var enemy_reserve: Array[UnitData]
@export var reward : Rewards

@export_group("Sprites")
@export var battle_tex: Texture2D
@export var camp_tex: Texture2D
@export var event_tex: Texture2D
@export var boss_tex: Texture2D
@export var locked_tex: Texture2D

func get_my_texture() -> Texture2D:
	if locked:
		return locked_tex
	if type==nodeType.Battle:
		return battle_tex
	if type==nodeType.Camp:
		return camp_tex
	if type==nodeType.Event:
		return event_tex
	return boss_tex

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = get_my_texture() # Replace with function body.
	campaign.nodeList[id]=self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_encounter():
	if type==nodeType.Battle or type==nodeType.BossBattle:
		BattleData.victory = false
		
		BattleData.enemy_vanguard = enemy_vanguard
		BattleData.enemy_reserve = enemy_reserve
		
		BattleData.player_vanguard = campaign.vanguard
		BattleData.player_reserve = campaign.reserve
		
		BattleData.node_id = id
		BattleData.campaign = campaign.scene_file_path
		
		campaign.persist_unlocked()
		get_tree().change_scene_to_packed(battle_scene)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		if locked:
			return 
		var ploc = campaign.player_location
		if ploc==id:
			process_encounter()
		#check if nearby
		var player_node = campaign.nodeList[ploc]
		if id in player_node.paths or ploc in paths:
			campaign.move_player(id)

func  _draw():
	for path in paths:
		var other_node = campaign.nodeList[path]
		var color = Color.FIREBRICK if other_node.locked else Color.CYAN
		var diff = other_node.position - position
		draw_line(Vector2.ZERO, diff,color,3.0)


func refresh():
	sprite.texture = get_my_texture()
	queue_redraw()
