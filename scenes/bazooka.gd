extends Shotgun
class_name Bazooka
@export var ROCKET_ZOOM = 0.2
@export var CONTROL_DELAY = 0.5
@export var UNCONTROLL_ROCKET_SPEED = 2500
@export var EXPLOSIVE_DAMAGE = 200
var current_rocket : ExplosiveProjectile = null
func set_camera_to_rocket(target):
	if idname == str(multiplayer.get_unique_id()):
		camera.node_to_spectate = target
		camera.target_zoom = Vector2(ROCKET_ZOOM,ROCKET_ZOOM)
		

func shoot():
	if current_rocket:
		current_rocket.CONTROL = false
		current_rocket.velocity = current_rocket.velocity.normalized() * UNCONTROLL_ROCKET_SPEED
		current_rocket = null
		camera.node_to_spectate = self
		camera.target_zoom = Vector2(INIT_ZOOM,INIT_ZOOM)
		return
	if(ammo != 0):
		makeShootSound.rpc()
		$TimerToReload.stop()
		apply_force(SHOOT_FORCE.rotated(rotation));
		$AnimationPlayer.play("shoot");
		apply_torque(-RECOIL_FORCE);
		add_shell.rpc()
		add_bullet.rpc()
		ammo -= 1;
		
		if(ammo == 0):
			reload()
			withMag = false;
		updateUI()
@rpc("any_peer","call_local","reliable")
func add_bullet():
	for i in range(BULLET_AMOUNT):
		var new_rotation = deg_to_rad(rad_to_deg(Barrel.global_rotation) + randf_range(-BULLET_SPREAD,BULLET_SPREAD));
		var bullet : ExplosiveProjectile = bulletScene.instantiate();
		bullet.shooter = self.idname;
		bullet.set_multiplayer_authority(get_multiplayer_authority())
		bullet.CONTROL_SPEED = BULLET_SPEED
		bullet.UNCONTROL_SPEED = UNCONTROLL_ROCKET_SPEED
		bullet.velocity = UNCONTROLL_ROCKET_SPEED * Vector2.UP.rotated(new_rotation);
		get_tree().get_root().add_child(bullet)
		current_rocket = bullet
		set_camera_to_rocket(bullet)
		bullet.damage = bullet_damage;
		bullet.EXPLOSIVE_DAMAGE = EXPLOSIVE_DAMAGE;
		bullet.global_position = Barrel.global_position;
		bullet.global_rotation = new_rotation;
		
