class_name Campaign
extends Node2D

var nodeList: Dictionary

@export var vanguard: Array[UnitData]
@export var reserve: Array[UnitData]

@export var player_location: StringName

const VANGUARD_SIZE = 4

func unlockNodes(node_ids: Array[StringName]):
	for node in nodeList:
		if node in node_ids:
			nodeList[node].locked = false
	for node in nodeList:
		nodeList[node].refresh()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if BattleData.from_battle:
		unlockNodes(BattleData.unlocked_nodes)
		player_location = BattleData.node_id
		vanguard = BattleData.player_vanguard
		reserve = BattleData.player_reserve
		BattleData.from_battle = false
		if BattleData.victory:
			print("Victory!")
			BattleData.victory = false
			var node = nodeList[BattleData.node_id]
			giveRewards(node.reward)
			node.cleared = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func giveRewards(rewards: Rewards):
	print("giving rewards: ")
	unlockNodes(rewards.node_rewards)
	for unit in rewards.unitRewards:
		if vanguard.size()<VANGUARD_SIZE:
			vanguard.append(unit)
		else:
			reserve.append(unit)

func move_player(to: StringName):
	player_location=to

func persist_unlocked():
	BattleData.unlocked_nodes.clear()
	for n in nodeList:
		if not nodeList[n].locked:
			BattleData.unlocked_nodes.append(n)
