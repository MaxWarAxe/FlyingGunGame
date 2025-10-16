extends Area2D
class_name Bullet
@export var LIFE_TIME = 10;

var velocity = Vector2.UP;
var damage = 0;
var lastbody = null
var shooter = null
@export var pitch = 1.0
@export var particles : GPUParticles2D
@export var max_distance = 1000
var compare_velocity = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	$BuletFlySound.max_distance = max_distance
	add_to_group("Bullets")
	$LifeTimer.wait_time = LIFE_TIME;
	$LifeTimer.start()
	$BuletFlySound.play()
	particles.emitting = true
	pass # Replace with function body.


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	$BuletFlySound.pitch_scale = pitch
	position += velocity * _delta


func _on_body_entered(body):
	if(multiplayer.get_unique_id() == 1):
		if(body is StaticBody2D):
			return
		if(body.idname == shooter):
			return;
		if(lastbody != body):		
			body.deal.rpc(damage,shooter,velocity,global_position);
		lastbody = body;

func _on_life_timer_timeout():
	queue_free()
