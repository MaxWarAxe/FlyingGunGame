extends Node2D

func reload(time):
	$AnimationPlayer.speed_scale = 1.0/time
	$AnimationPlayer.play("fill")
# Called when the node enters the scene tree for the first time.
func _ready():
	clear()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clear():
	$Circle.value = 0
	$AmmoIcon.value = 0
	
func _on_animation_player_animation_finished(anim_name):
	clear()
