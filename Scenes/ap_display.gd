class_name ApDisplay
extends VBoxContainer

@export var icons: Array[TextureRect]
@export var full: Texture2D
@export var spent: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_icons(show: bool = true):
	for icon in icons:
		icon.visible = show

func adjust_amount(amount: int):
	for i in range(len(icons)):
		var icon = full if i<amount else spent
		icons[i].texture = icon
