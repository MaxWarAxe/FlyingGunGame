extends Control
@export var Address = "127.0.0.1"
@export var port = 7777

@export var WEAPON_SWITCH_SPEED = 0.05;
var peer
var weaponIndex = 0;
var isStarted = false;
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
	Address = "127.0.0.1"
	if $ip.text:
		Address = $ip.text
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		HostGame()
	$AnimationPlayer.play("logomove")
	updatePoses()

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Panel/NodeContainer.global_position.x = lerp($Panel/NodeContainer.global_position.x,movePos,WEAPON_SWITCH_SPEED)


func peer_connected(id):
	print("Player connected" + str(id));
	#sync.rpc_id(id,GameManager.Players)

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
	SendPlayerInformation.rpc_id(1, $VBoxContainer/NickNameLine.text,multiplayer.get_unique_id(),currentWeaponName,0,0,Vector2.ZERO,0,100,null)
	askStatus.rpc_id(1,multiplayer.get_unique_id())


func wait():
	await get_tree().create_timer(1).timeout

@rpc("any_peer","reliable")
func askStatus(unique_id):
	if isStarted:
		StartGame.rpc_id(unique_id)
		get_tree().get_root().get_node("game").QueueToConnect.append(unique_id)



func connection_failed():
	print("connection failed");

func _on_host_button_button_down():
	HostGame()
	SendPlayerInformation($VBoxContainer/NickNameLine.text,multiplayer.get_unique_id(),currentWeaponName,0,0,Vector2.ZERO,0,100,null)

func _on_join_button_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address,port)
	multiplayer.set_multiplayer_peer(peer)
	
	
@rpc("any_peer","call_local","reliable")
func StartGame():
	isStarted = true;
	if multiplayer.get_unique_id() == 1:
		sync.rpc(GameManager.Players)
	
	var scene = load("res://scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.mainMenu = self
	self.hide()

func HostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port,32);
	if error != OK:
		print("cannot host" + error)
		return
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")


@rpc("any_peer","reliable")
func SendPlayerInformation(new_name,id,weapon,kills,deaths,pos,killsinarow,hp,crates):
	print(weapon)
	
	if !GameManager.Players.has(id):
		if crates != null:
			GameManager.Crates = crates
			print(crates)	
		GameManager.Players[id] = {
			"name" : new_name,
			"id" : id,
			"kills" : kills,
			"deaths" : deaths,
			"weapon" : weapon,
			"pos" : Vector2.ZERO,
			"killsinarow" : killsinarow,
			"hp" : hp
		}
		if multiplayer.is_server():
			for i in GameManager.Players:
				SendPlayerInformation.rpc(GameManager.Players[i].name,i,GameManager.Players[i].weapon,GameManager.Players[i].kills,GameManager.Players[i].deaths,GameManager.Players[i].pos,GameManager.Players[i].killsinarow,GameManager.Players[i].hp,GameManager.Crates)
func _on_start_button_button_down():
	StartGame.rpc()
	

@rpc("any_peer","reliable")
func sync(players):
	GameManager.Players = players;

func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()


func _on_host_button_mouse_entered():
	pass # Replace with function body.


func _on_arrow_right_pressed():
	$Whoosh.play(0.2)
	weaponIndex += 1;
	if(weaponIndex == weaponAmount):
		weaponIndex = 0;
	updatePoses()
	targetWeapon = weaponsPoses[weaponIndex]
	movePos = $Panel/NodeContainer.global_position.x + target.x - targetWeapon.x

func _on_arrow_left_pressed():
	$Whoosh.play(0.2)
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


func _on_check_button_toggled(toggled_on: bool) -> void:
	Settings.on_mobile = toggled_on


func _on_nick_name_line_text_changed(_new_text: String) -> void:
	var menu_buttons = get_tree().get_nodes_in_group("menu_buttons")
	var tween = create_tween()
	var fade_time = 0.2
	if $VBoxContainer/NickNameLine.text == '':
		for button in menu_buttons:
			tween.tween_property(button, "modulate:a", 0.0, fade_time) # Fade to full opacity
			await get_tree().create_timer(fade_time).timeout
			button.visible = false
	else:
		for button in menu_buttons:
			button.modulate.a = 0.0
			button.visible = true
			tween.tween_property(button, "modulate:a", 1.0, fade_time)


func _on_check_button_2_pressed() -> void:
	if !$smol.button_pressed:
		get_window().mode = Window.MODE_FULLSCREEN
		get_window().set_size(Vector2i(1920, 1080))
	else:
		get_window().mode = Window.MODE_WINDOWED
		get_window().set_size(Vector2i(1152, 648))
