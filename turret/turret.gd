extends Weapon
func _ready():
	init_data()
func _process(delta):
	if timerToShoot.is_stopped() and Input.is_action_pressed("test"):
		shoot()
		timerToShoot.start()
func _integrate_forces(state):
	pass
