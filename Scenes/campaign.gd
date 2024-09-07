class_name Campaign
extends Node2D

var nodeList: Dictionary

@export var vanguard: Array[UnitData]
@export var reserve: Array[UnitData]

@export var player_location: StringName

@onready var player_sprite = $PlayerSprite

const VANGUARD_SIZE = 4

func unlockNodes(node_ids: Array[StringName]):
	for node in nodeList:
		if node in node_ids:
			nodeList[node].locked = false
	for node in nodeList:
		nodeList[node].refresh()

func clear_nodes(node_ids: Array[StringName]):
	for node in nodeList:
		if node in node_ids:
			nodeList[node].cleared = true

# Called when the node enters the scene tree for the first time.
func _ready():
	move_player(player_location,false)
	if BattleData.from_battle:
		unlockNodes(BattleData.unlocked_nodes)
		move_player(BattleData.node_id, false)
		vanguard = BattleData.player_vanguard
		reserve = BattleData.player_reserve
		BattleData.from_battle = false
		if BattleData.victory:
			print("Victory!")
			BattleData.victory = false
			var node = nodeList[BattleData.node_id]
			giveRewards(BattleData.rewards)
			node.cleared = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func giveRewards(rewards: Rewards):
	print("giving rewards: ")
	if not rewards:
		return
	unlockNodes(rewards.node_rewards)
	for unit in rewards.unitRewards:
		PlayerData.addUnit(unit)

func move_player(to: StringName, tween: bool = true):
	player_location=to
	var target_node = nodeList[to]
	if tween:
		var t = player_sprite.create_tween()
		t.tween_property(player_sprite,"position",target_node.position,1.0)
	else:
		player_sprite.position = target_node.position

func persist_unlocked():
	BattleData.unlocked_nodes.clear()
	for n in nodeList:
		if not nodeList[n].locked:
			BattleData.unlocked_nodes.append(n)

func persist_cleared():
	BattleData.cleared_nodes.clear()
	for n in nodeList:
		if nodeList[n].cleared:
			BattleData.cleared_nodes.append(n)
