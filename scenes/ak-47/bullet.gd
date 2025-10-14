extends Area2D
class_name Bullet
@export var LIFE_TIME = 3;

var velocity = Vector2.UP;
var damage = 0;
var lastbody = null
var shooter = null
@export var pitch = 1.0
@export var max_distance = 1000
var compare_velocity = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$BuletFlySound.max_distance = max_distance
	add_to_group("Bullets")
	$LifeTimer.wait_time = LIFE_TIME;
	$LifeTimer.start()
	$BuletFlySound.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BuletFlySound.pitch_scale = pitch
	position += velocity * delta


func _on_body_entered(body):
	if(multiplayer.get_unique_id() == 1):
		if(body.idname == shooter):
			return;
		if(lastbody != body):		
			body.deal.rpc(damage,shooter);
		lastbody = body;
	


func _on_life_timer_timeout():
	queue_free()
