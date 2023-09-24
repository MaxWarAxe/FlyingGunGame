extends Node2D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	var currentPlayer
	for i in GameManager.Players:
		currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		currentPlayer.nick = str(GameManager.Players[i].name)
		currentPlayer.setAuthority(GameManager.Players[i].id)
		add_child(currentPlayer)
		currentPlayer.connect("died",respawn,0);
		
		for spawn in get_tree().get_nodes_in_group("SpawnPoints"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
	pass # Replace with function body.


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
			currentPlayer = PlayerScene.instantiate()
			currentPlayer.name = str(GameManager.Players[i].id)
			currentPlayer.nick = str(GameManager.Players[i].name)
			currentPlayer.setAuthority(GameManager.Players[i].id)
			add_child(currentPlayer)

			currentPlayer.connect("died",respawn,0);
				
			for spawn in get_tree().get_nodes_in_group("SpawnPoints"):
				if spawn.name == str(index):
					currentPlayer.global_position = spawn.global_position
