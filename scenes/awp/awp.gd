extends Weapon

var AWP_UNZOOM_VALUE = 0.2

func controls():
	if(Input.is_action_just_pressed("shoot")):
		unzoom();
		
	if(Input.is_action_just_released("shoot")):
		camera.targetZoom = Vector2(INIT_ZOOM,INIT_ZOOM)
		if timerToShoot.is_stopped():
			shoot();
			timerToShoot.start();
		
	if(Input.is_action_pressed("rotate_left")):
		rotate_left();
	if(Input.is_action_just_pressed("show_score")):
		updateScore()
		camera.showScore()
	if(Input.is_action_just_released('show_score')):
		camera.hideScore();
		
	if(Input.is_action_pressed("rotate_right")):
		rotate_right();
	if(Input.is_action_just_pressed("reload") and timerToReload.is_stopped()):
		reload()
			
func unzoom():
	camera.targetZoom = Vector2(AWP_UNZOOM_VALUE,AWP_UNZOOM_VALUE);


func _on_timer_to_shoot_timeout():
	pass
