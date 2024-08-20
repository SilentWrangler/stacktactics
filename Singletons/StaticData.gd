extends Node

var damage_data = {}
var hp_icons = {}

var damage_data_file_path = "res://hp_damage_interactions.tres"

var deafult_hp_texture : Texture

func  _ready():
	damage_data = preload("res://hp_damage_interactions.tres").data
	hp_icons = {
		&"flesh": preload("res://img/hp-icons/heart.png"),
		&"metal": preload("res://img/hp-icons/chainmail.png"),
		&"block": preload("res://img/hp-icons/shield.png"),
	}
	deafult_hp_texture = preload("res://img/hp-icons/swirl.png")

func get_hp_texture(name):
	return hp_icons.get(name,deafult_hp_texture)
