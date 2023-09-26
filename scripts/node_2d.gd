extends Node2D

@export var awpScene : PackedScene
@export var akScene : PackedScene

func weaponChoose(i) -> Node:
	match GameManager.Players[i].weapon:
			"ak":
				return akScene.instantiate()
			"awp":
				return awpScene.instantiate()
	return null;

@rpc("any_peer","call_local")
func spawn():
	var index = 0
	var currentPlayer
	for i in GameManager.Players:
		
		currentPlayer = weaponChoose(i)
		
		currentPlayer.name = str(GameManager.Players[i].id)
		currentPlayer.nick = str(GameManager.Players[i].name)
		currentPlayer.setAuthority(GameManager.Players[i].id)
		add_child(currentPlayer)
		currentPlayer.connect("died",respawn,0);
		
		for spawn in get_tree().get_nodes_in_group("SpawnPoints"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
	pass

func _ready():
	
	if multiplayer.get_unique_id() == 1:
		spawn.rpc();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func respawn(id):
	respawnCall.rpc(id)

@rpc("any_peer","call_local")
func respawnCall(id):
	var index = 0
	var currentPlayer
	for i in GameManager.Players:
		if str(GameManager.Players[i].id) == str(id):
			currentPlayer = weaponChoose(i)
			currentPlayer.name = str(GameManager.Players[i].id)
			currentPlayer.nick = str(GameManager.Players[i].name)
			currentPlayer.setAuthority(GameManager.Players[i].id)
			add_child(currentPlayer)

			currentPlayer.connect("died",respawn,0);
				
			for spawn in get_tree().get_nodes_in_group("SpawnPoints"):
				if spawn.name == str(index):
					currentPlayer.global_position = spawn.global_position
