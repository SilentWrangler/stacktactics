extends RichTextLabel


func refresh():
	text = ""
	append_text("Resources: ")
	for r in PlayerData.resources:
		add_image(StaticData.get_resource_texture(r))
		append_text(" %d " % PlayerData.resources[r])


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
