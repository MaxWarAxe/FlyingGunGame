extends Node2D

var SHADER_PATH_SCENE = "res://shaders/lava.tres"
var DOUBLE_DAMAGE_TIME = 6

func init():
	var other_dd = get_parent().get_node_or_null("double_damage_effect")
	if (other_dd != null) and (other_dd != self):
		other_dd.setTime(DOUBLE_DAMAGE_TIME)
		other_dd.startTimer()
		self.queue_free()
	$Timer.wait_time = DOUBLE_DAMAGE_TIME
	$Timer.start()
	get_parent().get_node("Sprites").material = load(SHADER_PATH_SCENE);
	get_parent().bullet_damage = get_parent().BASE_BULLET_DAMAGE * 2;

func setTime(time):
	$Timer.wait_time = time
func startTimer():
	$Timer.start()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	get_parent().bullet_damage = get_parent().BASE_BULLET_DAMAGE;
	get_parent().get_node("Sprites").material = null;
	queue_free();
