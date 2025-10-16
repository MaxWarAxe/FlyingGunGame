extends Bullet
class_name ExplosiveProjectile
@export var ROTATION_SPEED : float = 5
@export var CONTROL : bool = true
@export var UNCONTROL_SPEED : float
@export var CONTROL_SPEED : float 
@export var EXPLOSIVE_LIFE_TIME : float = 1.0
@export var EXPLOSIVE : PackedScene
@export var EXPLOSIVE_DAMAGE : float = 200
func _on_body_entered(body):
	if(multiplayer.get_unique_id() == 1):
		if(body is StaticBody2D):
			explode.rpc()
			return
		if(body.idname == shooter):
			return;
		if(lastbody != body):		
			body.deal.rpc(damage,shooter,velocity,global_position);
			explode.rpc()
			return
		lastbody = body;
@rpc("any_peer","call_local","reliable")
func explode():
	var explosive : Explosion = EXPLOSIVE.instantiate()
	explosive.shooter = shooter
	explosive.global_position = global_position
	explosive.LIFE_TIME = EXPLOSIVE_LIFE_TIME
	explosive.damage = EXPLOSIVE_DAMAGE
	get_tree().get_root().add_child(explosive)
	explosive.explode()
	queue_free()
@rpc("any_peer","call_local","reliable")
func control_rocket(_delta):
	if CONTROL:
		velocity = velocity.lerp(velocity.normalized() * CONTROL_SPEED,0.005)
		if Input.is_action_pressed("rotate_left"):
			rotate(-ROTATION_SPEED*_delta)
			velocity = velocity.rotated(-ROTATION_SPEED*_delta)
		if Input.is_action_pressed("rotate_right"):
			rotate(ROTATION_SPEED*_delta)
			velocity = velocity.rotated(ROTATION_SPEED*_delta)
	position += velocity * _delta
func _process(_delta):
	$Circle.max_value = LIFE_TIME
	$Circle.value = $LifeTimer.time_left
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		control_rocket.rpc(_delta)
		$Line2D.visible = true
	$BuletFlySound.pitch_scale = pitch
func _on_life_timer_timeout():
	explode()
	queue_free()
