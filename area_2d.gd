extends Bullet
class_name Explosion

func explode():
	$AnimationPlayer.speed_scale = LIFE_TIME
	$AnimationPlayer.play("explode")
