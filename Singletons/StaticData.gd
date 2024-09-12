extends Node

var damage_data = {}
var hp_icons = {}
@export var resource_icons = {}

var damage_data_file_path = "res://hp_damage_interactions.tres"

var deafult_hp_texture : Texture
var default_resource_texture: Texture2D

func  _ready():
	damage_data = preload("res://hp_damage_interactions.tres").data
	hp_icons = {
		&"flesh": preload("res://img/hp-icons/heart.png"),
		&"metal": preload("res://img/hp-icons/chainmail.png"),
		&"block": preload("res://img/hp-icons/shield.png"),
	}
	
	resource_icons = {
		&"silver": preload("res://img/resources/silver.png")
	}
	
	deafult_hp_texture = preload("res://img/hp-icons/swirl.png")
	default_resource_texture = preload("res://img/resources/unknown.png")
		
	

func get_hp_texture(name):
	return hp_icons.get(name,deafult_hp_texture)

func get_resource_texture(name):
	return resource_icons.get(name,default_resource_texture)

func get_resuorce_bbcode(dict: Dictionary) -> String:
	var rich = RichTextLabel.new()
	for k in dict:
		rich.add_image(get_resource_texture(k))
		rich.append_text(" %d " % dict[k])
	var txt = rich.text
	rich.free()
	return txt
