extends RigidBody2D

var LIFE_TIME = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = LIFE_TIME
	$Timer.start()
	var size = ($Sprites.get_children().size())
	$Sprites.get_child(randi_range(0,size-1)).visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
