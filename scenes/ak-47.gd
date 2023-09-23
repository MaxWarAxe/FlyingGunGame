extends RigidBody2D
var SHOOT_FORCE = Vector2(-1000,0);
var ANGULAR_VELOCITY = 0;
var timer
func _ready():
	timer = get_node("Timer")
	gravity_scale = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("shoot") and (timer.is_stopped())):
		shoot();
		timer.start();
	if(Input.is_action_pressed("rotate_left")):
		rotate_left();
	if(Input.is_action_pressed("rotate_right")):
		rotate_right();
func shoot():
	var barrel = get_node("Barrel")
	var backOfGun = get_node("Back_of_gun")
	print(rotation)
	apply_force(SHOOT_FORCE.rotated(rotation));
	$AnimationPlayer.play("shoot");
func rotate_left():
	ANGULAR_VELOCITY += -1 * get_process_delta_time();
	
func rotate_right():
	ANGULAR_VELOCITY += 1 * get_process_delta_time();
	
func _integrate_forces(state):
	state.set_angular_velocity(ANGULAR_VELOCITY);


func _on_timer_timeout():
	pass # Replace with function body.
