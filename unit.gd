class_name Unit
extends Node2D

@export var unitData: UnitData

@onready var stack : HpStack = $"HpStack"
@onready var sprite : Sprite2D = $'Sprite2D'
@onready var circle: Sprite2D = $'Sprite2D_circle'

@onready var manager = $"../../BattleManager"
@onready var map = $"../../Map"
@onready var buff_display = $BuffDisplay

@export var side: Team
@export var critical: bool
@export var tags: Array[StringName]

@export var Buffs: Array[Buff]

@export var Abilities: Array[Ability]

@export var map_position: Vector2i

@export_group("Circles")
@export_subgroup("player")
@export var player_circles_normal: Array[Texture2D]
@export var player_circles_critical: Array[Texture2D]
@export_subgroup("enemy")
@export var enemy_circles_normal: Array[Texture2D]
@export var enemy_circles_critical: Array[Texture2D]


var action_points: int = 3
const AP_MAX = 3

var arcana: int
var power: int
var fortitude: int

enum Team{
	Player,
	Enemy
}

enum Attribute{
	None,
	Arcana,
	Power,
	Fortitude
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()

func load_data(data: UnitData = null):
	if data==null:
		data = unitData
	sprite.texture = data.sprite_texture
	stack.set_stack(data.default_hp)
	tags = data.inherent_tags.duplicate()
	Abilities = data.abilities.duplicate()
	arcana = data.arcana
	power = data.power
	fortitude = data.fortitude
	update_circle()

func update_circle():
	var texture: AtlasTexture = null
	if side==Team.Player:
		texture = player_circles_critical[action_points] if critical else player_circles_normal[action_points]
	elif side==Team.Enemy:
		texture = enemy_circles_critical[action_points] if critical else enemy_circles_normal[action_points]
	circle.texture = texture

signal move_finished
func  move(to: Vector2):
	var target_coords = map.map_to_local(to)
	var tween = create_tween()
	tween.tween_property(self,"position",target_coords,0.5)
	tween.tween_callback(func():move_finished.emit())
	map_position = to
	

func total_attribute(attribute: Attribute) -> int:
	if attribute==Attribute.None:
		return 0
	
	var result: int = 0
	
	if attribute==Attribute.Arcana:
		result += arcana
	elif  attribute==Attribute.Power:
		result += power
	elif attribute==Attribute.Fortitude:
		result += fortitude
	for buff in Buffs:
		if buff.attribute_mod_attribute == attribute:
			result += buff.attribute_mod_amount * buff.amount
	return result

func calculate_power(flat:int, scaling: Attribute, multiplier:float) -> int:
	var result = flat
	if scaling==Attribute.None:
		return result
	else:
		var attr = total_attribute(scaling)
		var scaled = floor(attr * multiplier)
		result += scaled
	return result

func take_damage(damage: DamageStack):
	stack.take_damage(damage)

func modify_stack(base_stack: DamageStack):
	for buff in Buffs:
		if buff.damage_type in StaticData.damage_data.damage_types:
			var amount = calculate_power(
				buff.damage_flat_modifier,
				buff.damage_attr_scaling,
				buff.damage_attr_scaling) * buff.amount
			if buff.damage_placement == Buff.DamagePlacement.Append:
				base_stack.append_damage(buff.damage_type,amount)
			else:
				base_stack.prepend_damage(buff.damage_type,amount)
			

func applyBuff(buff: Buff):
	for b in Buffs:
		if buff.stack_id==b.stack_id:
			b.amount += buff.amount
			b.duration = max(b.duration,buff.duration)
			buff_display.queue_redraw()
			return
	Buffs.append(buff.duplicate())
	buff_display.queue_redraw()


func decrement_buffs():
	for buff in Buffs:
		if buff.duration != Buff.INFINITE_DURATION:
			buff.duration-=1
			if buff.duration < 1:
				Buffs.erase(buff)
		if buff.decaying:
			buff.amount = max(1, buff.amount-1)
	buff_display.queue_redraw()

func has_tag(tag: StringName) -> bool:
	if tags.has(tag):
		return true
	for buff in Buffs:
		if buff.tags.has(tag):
			return true
	return false


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		if manager.selected_unit!=self:
			manager.select_unit(self)
		else:
			manager.select_unit(null)


func _on_start_turn(side: Team):
	if side==self.side:
		print(side," UNIT TURN START")
		action_points = AP_MAX
		update_circle()

func _on_end_turn(side: Team):
	stack.decrement_duratuions()
	decrement_buffs()
	if side==self.side:
		pass


func _on_hp_stack_damage():
	pass # Replace with function body.


func _on_hp_stack_death():
	queue_free()# Replace with function body.


func _on_hp_stack_hp_added():
	pass # Replace with function body.
