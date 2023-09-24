extends Area2D

var velocity = Vector2.UP;
var damage = 0;
var lastbody = null
var shooter = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta

@rpc("any_peer")
func _on_body_entered(body):
	if(multiplayer.get_unique_id() == 1):
		if(body.name == shooter):
			return;
		if(lastbody != body):		
			body.deal.rpc(damage,shooter);
		lastbody = body;
	
