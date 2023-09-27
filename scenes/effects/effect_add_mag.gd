extends Node2D

var MAG_INCREMENT = 5;

func init():
	get_parent().mags += MAG_INCREMENT;
	get_parent().updateUI();
	queue_free();

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
