extends Node2D

var HP_INCREMENT = 15

#@rpc("any_peer","call_local")
func init():
	get_parent().hp += HP_INCREMENT;
	get_parent().updateHP();
	queue_free();
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
