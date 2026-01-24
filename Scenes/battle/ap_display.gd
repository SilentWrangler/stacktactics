class_name ApDisplay
extends VBoxContainer

@export var icons: Array[TextureRect]
@export var full: Texture2D
@export var spent: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func show_icons(show_icon: bool = true):
	for icon in icons:
		icon.visible = show_icon

func adjust_amount(amount: int):
	for i in range(len(icons)):
		var icon = full if i<amount else spent
		icons[i].texture = icon
