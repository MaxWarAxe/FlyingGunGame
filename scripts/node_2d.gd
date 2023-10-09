extends Node2D

@export var awpScene : PackedScene
@export var akScene : PackedScene
@export var shotgunScene : PackedScene
@export var uziScene : PackedScene
@onready var spawner = get_node("spawner")
var QueueToConnect : Array

func weaponChoose(i) -> Node:
	match GameManager.Players[i].weapon:
			"ak":
				return akScene.instantiate()
			"awp":
				return awpScene.instantiate()
			"shotgun":
				return shotgunScene.instantiate()
			"uzi":
				return uziScene.instantiate()
	return null;

@rpc("any_peer","call_local","reliable")
func spawn():
	var index = 0
	var currentPlayer
	for i in GameManager.Players:
		
		currentPlayer = weaponChoose(i)
		
		currentPlayer.name = str(GameManager.Players[i].id)
		currentPlayer.nick = str(GameManager.Players[i].name)
		currentPlayer.idname = str(GameManager.Players[i].id)
		currentPlayer.setAuthority(GameManager.Players[i].id)
		add_child(currentPlayer)
		currentPlayer.connect("died",respawn,0);
		

		currentPlayer.demandingPos = $player_spawner.calculatePos()
		currentPlayer.respawning = true;
		index += 1
	pass

func _ready():
	if multiplayer.get_unique_id() == 1:
		spawn.rpc();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(QueueToConnect.size() != 0):
		for unID in QueueToConnect:
			QueueToConnect.erase(unID)
			cloneToNewPlayer.rpc_id(unID)
			addConnectedPlayer.rpc(unID)
			
			

func wait():
	await get_tree().create_timer(5).timeout

@rpc("any_peer","reliable")
func cloneToNewPlayer():
	print("WTF")
	for k in GameManager.Crates:
		spawner.spawn(GameManager.Crates[k].pos,GameManager.Crates[k].name)
	var index = 0
	for i in GameManager.Players:
		var currentPlayer
		if str(GameManager.Players[i].id) != str(multiplayer.get_unique_id()):
			currentPlayer = weaponChoose(i)
			currentPlayer.name = str(GameManager.Players[i].id)
			currentPlayer.nick = str(GameManager.Players[i].name)
			currentPlayer.idname = str(GameManager.Players[i].id)
			currentPlayer.setAuthority(GameManager.Players[i].id)
			
			add_child(currentPlayer)
			currentPlayer.hp = GameManager.Players[i].hp
			currentPlayer.label.updateHP(currentPlayer.hp)
			#currentPlayer.name = str(GameManager.Players[i].id)
			currentPlayer.connect("died",respawn,0);
			
		
	pass


func respawn(id):
	print("resemited")
	respawnCall.rpc(id)

@rpc("any_peer","call_local","reliable")
func addConnectedPlayer(id):
	var currentPlayer
	for i in GameManager.Players:
		if GameManager.Players[i].id == id:
			currentPlayer = weaponChoose(i)
			currentPlayer.name = str(GameManager.Players[i].id)
			currentPlayer.nick = str(GameManager.Players[i].name)
			currentPlayer.idname = str(GameManager.Players[i].id)
			currentPlayer.setAuthority(GameManager.Players[i].id)
			add_child(currentPlayer)
			currentPlayer.connect("died",respawn,0);
			
			
			currentPlayer.demandingPos = $player_spawner.calculatePos()
			currentPlayer.respawning = true;
	pass

@rpc("any_peer","call_local","reliable")
func respawnCall(id):
	var index = 0
	var currentPlayer = get_node(id)
	if currentPlayer != null:
		currentPlayer.hp = currentPlayer.INIT_HP
		currentPlayer.label.updateHP(currentPlayer.hp)
		
		currentPlayer.demandingPos = $player_spawner.calculatePos()
		currentPlayer.respawning = true;
	
