class_name HpStack
extends Node2D

enum InteractionType{
	Default,
	Vulnerability,
	Resistance,
	Immunity,
	Bypass
}



@export var Stack: Array[HpSegment]

@onready var data : StaticData = $"/root/StaticData"
@export  var font : Font = ThemeDB.fallback_font;
@export var max_health_sprites = 3
@export var font_size = 16

signal death
signal damage
signal hp_added

func get_interaction(hp_type: StringName,damage_type: StringName): 
	return data.damage_data.special_interactions.get(hp_type,{}).get(damage_type,0) as InteractionType


func take_damage(incoming_damage: DamageStack):
	print("taking damage, hp total: ", total())
	var current_segment_idx = Stack.size() - 1
	print(incoming_damage.Stack.size())
	while incoming_damage.Stack.size()>0 and Stack.size()>0 and Stack[0].amount>0 and current_segment_idx>=0:
		var current_segment = Stack[current_segment_idx]
		var head = incoming_damage.head()
		var interaction : InteractionType = get_interaction(current_segment.Type, head.type)
		print(head.type, head.amount)
		match interaction:
			0: #Default
				if current_segment.amount <= head.amount:
					Stack.pop_at(current_segment_idx)
					incoming_damage.consume_damage(current_segment.amount)
					current_segment_idx-=1
				else:
					current_segment.amount-= head.amount
					incoming_damage.consume_damage(head.amount)
				continue
			1: #Vulnerability
				var real_damage = head.amount * 2
				if current_segment.amount <= real_damage:
					Stack.pop_at(current_segment_idx)
					current_segment_idx-=1
					incoming_damage.consume_damage(ceil(current_segment.amount/2))
				else:
					current_segment.amount-= real_damage
					incoming_damage.consume_damage(head.amount)
			2: #Resistance
				var real_damage = floor(head.amount / 2)
				if real_damage == 0:
					incoming_damage.lose_damage_segment()
				if current_segment.amount <= real_damage:
					Stack.pop_at(current_segment_idx)
					current_segment_idx-=1
					incoming_damage.consume_damage(ceil(current_segment.amount*2))
				else:
					current_segment.amount-= real_damage
					incoming_damage.consume_damage(head.amount)
			3: #Immunity
				incoming_damage.lose_damage_segment()
			4: #Bypass
				current_segment_idx-=1
	queue_redraw()
	print("damage dealt, total hp left: ", total())
	damage.emit()
	if Stack.size()==0 or Stack[0].amount<1:
		die()

func decrement_duratuions():
	for segment in Stack:
		if segment.duration != segment.INFINITE_DURATION:
			segment.duration -= 1
			if segment.duration < 1:
				Stack.erase(segment)
	queue_redraw()
		

func add_hp(type: StringName, amount: int, duration: int = HpSegment.INFINITE_DURATION):
	var Segment = HpSegment.new()
	Segment.amount = amount
	Segment.Type = type
	Segment.duration = duration
	Stack.append(Segment)
	queue_redraw()
	hp_added.emit()

func set_stack(stack: Array[HpSegment]):
	Stack = []
	for segment in stack:
		add_hp(segment.Type,segment.amount,segment.duration)
	queue_redraw()

func die():
	death.emit()

func total() -> int:
	var result: int = 0
	for seg in Stack:
		result += seg.amount
	return result

func total_type(type: StringName) -> int:
	var result: int = 0
	for seg in Stack:
		if seg.Type == type:
			result += seg.amount
	return result
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _draw():
	var x_pos = 0
	var delta_x = 18
	var y_pos = 0
	for segment in Stack:
		var tex = data.get_hp_texture(segment.Type)
		if segment.amount <= max_health_sprites:
			for i in range(segment.amount):
				draw_texture(tex,Vector2(x_pos,y_pos))
				x_pos += delta_x
		else:
			draw_texture(tex, Vector2(x_pos,y_pos))
			var txt = "x%d" % segment.amount
			var txt_size = font.get_string_size(txt)
			draw_string(font,Vector2(x_pos,y_pos),txt,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size)
			x_pos += txt_size.x
