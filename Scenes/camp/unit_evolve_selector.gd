extends Button


@export var unselected_texture: Texture
@export var selected_texture: Texture

@onready var texture_rect = $Texture


func display(data: UnitData):
	texture_rect.texture = data.sprite_texture

func _on_toggled(toggled_on):
	icon = unselected_texture if toggled_on else selected_texture
