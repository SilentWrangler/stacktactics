extends Node2D

@export var start_pos: Vector2
@export var x_shift_label = 2
@export var y_spacing = 2
@export  var font : Font = ThemeDB.fallback_font;
@export var font_size : int = 16

@onready var unit : Unit = $".."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _draw():
	var pos = start_pos
	
	for buff in unit.Buffs:
		draw_texture(buff.Icon,pos)
		var text_pos = pos + Vector2(buff.Icon.get_width()+x_shift_label,0)
		var txt = buff.get_duration_text()
		var txt_size = font.get_string_size(txt)
		draw_string(font,text_pos,txt,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size)
		pos.y += buff.Icon.get_height() + y_spacing
	
	
