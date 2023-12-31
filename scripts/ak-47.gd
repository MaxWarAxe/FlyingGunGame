extends RigidBody2D
@export var SHOOT_FORCE = Vector2(-600,0);
@export var ANGULAR_SPEED = 5000
@export var ANGULAR_VELOCITY = 0;
@export var RECOIL_FORCE = 50000;
@export var BULLET_SPEED = 2000;
@export var SHELL_SPEED = 250;
@export var MAG_SPEED = 50;
@export var MAG_ROTATION_SPEED = -100;
@export var SHELL_ROTATION_SPEED = -100;
@export var MAG_AMMO = 30;
@export var MAG_AMOUNT = 3;
@export var TIME_TO_RELOAD = 3;
@export var SHOOT_TIME_SPEED = 0.1;
@export var INIT_HP = 100;
@export var BASE_BULLET_DAMAGE = 34;
@export var INIT_ZOOM = 0.4;
var pos = transform;
var demandingPos;
@onready var bullet_damage = BASE_BULLET_DAMAGE
var camera
var label
var ammo = 0;
var mags = 0;
var hp = 1;
var respawning = false;
var idname
var itself
var nick = "";
var withMag : bool = true;
var lastDealer;
var targetZoom = INIT_ZOOM;
signal died(id);

@export var bulletScene : PackedScene
@export var shellScene : PackedScene
@export var cameraScene : PackedScene
@export var magScene : PackedScene
@export var labelScene : PackedScene
var RemoteTransform
var MagNode

var timerToShoot
var timerToReload
func _ready():
	itself = self;
	$MultiplayerSynchronizer.set_multiplayer_authority(idname.to_int())
	MagNode = $Sprites/Mag
	name = idname
	print("authority " + str($MultiplayerSynchronizer.get_multiplayer_authority()))
	print("unique " + str(multiplayer.get_unique_id()))
	print("name " + self.name)
	if idname == str(multiplayer.get_unique_id()):
		camera = cameraScene.instantiate();
		get_tree().get_root().add_child(camera)
		#add_child(camera)
		camera.nodeToSpectate = self
		camera.targetZoom = Vector2(INIT_ZOOM,INIT_ZOOM)
		
		$Line2D.visible = true;
	setUpLabel();
	timerToShoot = get_node("TimerToShoot")
	timerToReload = get_node("TimerToReload")
	timerToReload.wait_time = TIME_TO_RELOAD;
	timerToShoot.wait_time = SHOOT_TIME_SPEED;
	gravity_scale = 0;
	hp = INIT_HP;
	ammo = MAG_AMMO;
	mags = MAG_AMOUNT;
	hp = INIT_HP;
	targetZoom = INIT_ZOOM;
	updateScore()
	updateUI()
	label.updateHP(hp)
	
func setAuthority(id):
	idname = str(id);
	self.name = str(id);
	set_multiplayer_authority(id)
	$MultiplayerSynchronizer.set_multiplayer_authority(id)



func setUpLabel():
	label = labelScene.instantiate();
	get_tree().get_root().add_child(label);
	label.setup(nick,hp)

func updateHP():
	label.updateHP(hp)
	GameManager.changeHP.rpc(idname,hp)

func updateScore():
	if idname == str(multiplayer.get_unique_id()):
		camera.updateScore()

func checkDeath():
	if(multiplayer.get_unique_id() == 1):
		if(hp <= 0):
			GameManager.addDeath.rpc(idname)
			GameManager.addKill.rpc(lastDealer)
			
			die.rpc_id(1);

	

@rpc("any_peer","reliable")
func sendpos(id,posit):
	pos = posit

func _process(delta):
	label.position = position
	checkDeath()
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.spec()
		sendpos.rpc(multiplayer.get_unique_id(),pos)
		controls()
		if(Input.is_action_just_pressed("go_to_menu")):
			discon()


func discon():
	multiplayer.multiplayer_peer = null
	GameManager.clear()
	for i in get_tree().get_root().get_children():
		if i.name == "MainMenu":
			i.show()
			continue
		if((i.name != "GameManager")):
			i.queue_free()

func controls():
	if(Input.is_action_pressed("shoot") and (timerToShoot.is_stopped())):
		shoot();
		timerToShoot.start();
	if(Input.is_action_pressed("rotate_left")):
		rotate_left();
	if(Input.is_action_just_pressed("show_score")):
		updateScore()
		camera.showScore()
	if(Input.is_action_just_released('show_score')):
		camera.hideScore();
		
	if(Input.is_action_pressed("rotate_right")):
		rotate_right();
	if(Input.is_action_pressed("reload") and timerToReload.is_stopped()):
		reload()

func updateUI():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.updateUI(ammo,mags)

func reload():
	if(mags != 0):
		if(withMag):
			drop_mag.rpc()
			withMag = false;
		timerToReload.start()
		camera.makeReloadAnim(TIME_TO_RELOAD)
		ammo = 0
		updateUI()

func addAmmo():
	ammo = MAG_AMMO;
	mags -= 1;
	show_mag.rpc()
	withMag = true
	updateUI()

@rpc("any_peer","call_local","reliable")
func show_mag():
	MagNode.visible = true;
	$"Mag-Polygon".disabled = false;

@rpc("any_peer","call_local","reliable")
func drop_mag():
	MagNode.visible = false;
	$"Mag-Polygon".disabled = true;
	var mag = magScene.instantiate()
	get_tree().get_root().add_child(mag)
	mag.global_position = MagNode.global_position;
	mag.apply_force(MAG_SPEED * Vector2.UP.rotated(MagNode.find_child("Position").global_rotation) + linear_velocity);
	mag.apply_torque(MAG_ROTATION_SPEED)
	
func shoot():
	if(ammo != 0):
		var barrel = get_node("Barrel")
		apply_force(SHOOT_FORCE.rotated(rotation));
		$AnimationPlayer.play("shoot");
		apply_torque(-RECOIL_FORCE);
		add_shell.rpc()
		add_bullet.rpc()
		ammo -= 1;
		if(ammo == 0):
			drop_mag.rpc()
			withMag = false;
		updateUI()

@rpc("any_peer","call_local","reliable")
func add_shell():
	var shell = shellScene.instantiate();
	get_tree().get_root().add_child(shell)
	shell.apply_force(SHELL_SPEED * Vector2.UP.rotated($BoltPosition.global_rotation) + linear_velocity)
	shell.global_position = $BoltPosition.global_position;
	shell.apply_torque(SHELL_ROTATION_SPEED)

@rpc("any_peer","call_local","reliable")
func add_bullet():
	var bullet = bulletScene.instantiate();
	get_tree().get_root().add_child(bullet)
	bullet.damage = bullet_damage;
	bullet.shooter = self.idname;
	bullet.add_child(load("res://shaders/particle.tscn").instantiate());
	bullet.global_position = $Barrel.global_position;
	bullet.global_rotation = $Barrel.global_rotation;
	bullet.velocity = BULLET_SPEED * Vector2.UP.rotated($Barrel.global_rotation);
	
func rotate_left():
	ANGULAR_VELOCITY += -ANGULAR_SPEED * get_process_delta_time();
	apply_torque(-ANGULAR_SPEED* get_process_delta_time()*100);

func rotate_right():
	ANGULAR_VELOCITY += ANGULAR_SPEED * get_process_delta_time();
	apply_torque(ANGULAR_SPEED* get_process_delta_time()*100);

@rpc("any_peer","reliable","call_local")
func add_effect(effect):
	effect = load(effect).instantiate()
	add_child(effect)
	effect.init()
	

func _integrate_forces(state):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if(respawning):
			resp(demandingPos,state)
			respawning = false
			
		pos = state.transform
	state.transform = pos

func resp(newpos,state):
	state.transform = newpos;
	hp = INIT_HP
	GameManager.changeHP.rpc(idname,hp)
	state.linear_velocity = Vector2.ZERO
	state.angular_velocity = 0

func _on_timer_timeout():
	pass # Replace with function body.

func _on_timer_to_reload_timeout():
	addAmmo()

@rpc("any_peer","call_local","reliable")
func deal(damage,shooterid):
	hp -= damage;
	lastDealer = shooterid;
	label.updateHP(hp);
	GameManager.changeHP(idname,hp)
	
@rpc("any_peer","call_local","reliable")
func die():
	emit_signal("died",idname)
	
	
