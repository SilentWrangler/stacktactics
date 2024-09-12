extends Button


@export var unselected_texture: Texture
@export var selected_texture: Texture

@onready var texture_rect = $Texture
var selection: RestManager.Selection


func display(sel):
	selection = sel
	texture_rect.texture = sel.slot.unitData.sprite_texture
	if selection.slot.isWounded:
		texture_rect.modulate = Color.FIREBRICK
	else:
		texture_rect.modulate = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(toggled_on):
	icon = selected_texture if toggled_on else unselected_texture
