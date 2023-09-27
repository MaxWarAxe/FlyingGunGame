extends Control
@export var Address = "127.0.0.1"
@export var port = 7777

@export var WEAPON_SWITCH_SPEED = 0.05;
var peer
var weaponIndex = 0;
@onready var  weaponAmount = $Panel/NodeContainer.get_children(true).size();
@onready var target = $Target.global_position;
@onready var targetWeapon = $Target.global_position;
@onready var movePos = $Target.global_position.x;
var containerPos;
var currentWeaponName;
var weaponsPoses = []
# Called when the node enters the scene tree for the first time.
func updatePoses():
	weaponsPoses.clear()
	for i in range ($Panel/NodeContainer.get_children(false).size()):
		var weapon = $Panel/NodeContainer.get_child(i,false)
		weaponsPoses.append(weapon.global_position)
		
		if(weaponIndex == i):
			currentWeaponName = weapon.name;
			$Panel/weaponNameLabel.text = currentWeaponName;
		

func _ready():
	var str : String
	for i in range(IP.get_local_addresses().size()):
		str += IP.get_local_addresses()[i] + '\n';
	$iplabel.text = str
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		HostGame()
	
	
	$AnimationPlayer.set_autoplay("logomove")
	$AnimationPlayer.play("logomove")
	
	updatePoses()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Panel/NodeContainer.global_position.x = lerp($Panel/NodeContainer.global_position.x,movePos,WEAPON_SWITCH_SPEED)
	
func peer_connected(id):
	print("Player connected" + str(id));

func peer_disconnected(id):
	print("Player disconnected" + str(id));
	GameManager.Players.erase(id);
	var players = get_tree().get_nodes_in_group("Player");
	for i in players:
		if i.name == str(id):
			i.label.queue_free()
			i.queue_free()
	
func connected_to_server():
	print("connected to Server");
	SendPlayerInformation.rpc_id(1, $VBoxContainer/NickNameLine.text,multiplayer.get_unique_id(),currentWeaponName)
	
func connection_failed():
	print("connection failed");

func _on_host_button_button_down():
	HostGame()
	SendPlayerInformation($VBoxContainer/NickNameLine.text,multiplayer.get_unique_id(),currentWeaponName)
	
func _on_join_button_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address,port)
	multiplayer.set_multiplayer_peer(peer)
	
@rpc("any_peer","call_local")
func StartGame():
	if multiplayer.get_unique_id() == 1:
		sync.rpc(GameManager.Players)
	
	var scene = load("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func HostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port,32);
	if error != OK:
		print("cannot host" + error)
		return
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")
	

@rpc("any_peer")
func SendPlayerInformation(name,id,weapon):
	print(weapon)
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : name,
			"id" : id,
			"kills" : 0,
			"deaths" : 0,
			"weapon" : weapon
		}
		if multiplayer.is_server():
			for i in GameManager.Players:
				SendPlayerInformation.rpc(GameManager.Players[i].name,i,GameManager.Players[i].weapon)
func _on_start_button_button_down():
	StartGame.rpc()
	

@rpc("any_peer")
func sync(players):
	GameManager.Players = players;

func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()


func _on_host_button_mouse_entered():
	pass # Replace with function body.


func _on_arrow_right_pressed():
	weaponIndex += 1;
	if(weaponIndex == weaponAmount):
		weaponIndex = 0;
	updatePoses()
	targetWeapon = weaponsPoses[weaponIndex]
	movePos = $Panel/NodeContainer.global_position.x + target.x - targetWeapon.x

func _on_arrow_left_pressed():
	weaponIndex -= 1;
	if(weaponIndex < 0):
		weaponIndex = weaponAmount-1;
	updatePoses()
	targetWeapon = weaponsPoses[weaponIndex]
	movePos = $Panel/NodeContainer.global_position.x + target.x - targetWeapon.x


func _on_quit_button_pressed():
	get_tree().quit()


func _on_ip_text_changed(new_text):
	Address = new_text


func _on_portline_text_changed(new_text):
	port = new_text.to_int()
