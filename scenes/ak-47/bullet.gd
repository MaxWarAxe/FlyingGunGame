extends Area2D

@export var LIFE_TIME = 15;

var velocity = Vector2.UP;
var damage = 0;
var lastbody = null
var shooter = null
# Called when the node enters the scene tree for the first time.
func _ready():
	$LifeTimer.wait_time = LIFE_TIME;
	$LifeTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
