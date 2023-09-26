extends "res://scripts/ak-47.gd"
@export var BULLET_AMOUNT = 8
@export var BULLET_SPREAD = 10;

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
			withMag = false;
		updateUI()
		
@rpc("any_peer","call_local")
func add_bullet():
	for i in range(BULLET_AMOUNT):
		var rotation = deg_to_rad(rad_to_deg($Barrel.global_rotation) + randf_range(-BULLET_SPREAD,BULLET_SPREAD));
		var bullet = bulletScene.instantiate();
		get_tree().get_root().add_child(bullet)
		bullet.damage = BULLET_DAMAGE;
		bullet.shooter = self.idname;
		bullet.global_position = $Barrel.global_position;
		bullet.global_rotation = rotation;
		bullet.velocity = BULLET_SPEED * Vector2.UP.rotated(rotation);

func reload():
	if(mags != 0):
		timerToReload.start()
		updateUI()

func addAmmo():
	if(!withMag):
		$AnimationPlayer.play("shoot");
	if(ammo < MAG_AMMO):
		ammo += 1;
		mags -= 1;
		withMag = true
		updateUI()



