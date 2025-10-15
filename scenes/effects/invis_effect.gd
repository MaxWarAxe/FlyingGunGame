extends Effect
class_name AddInvisEffect
var SHADER_PATH_SCENE = "res://shaders/invis.tres"
var INVIS_TIME = 6

func init():
	var other_invis = get_parent().get_node_or_null("invis_effect")
	if (other_invis != null) and (other_invis != self):
		other_invis.setTime(INVIS_TIME)
		other_invis.startTimer()
		self.queue_free()
	$Timer.wait_time = INVIS_TIME
	$Timer.start()
	get_parent().get_node("Sprites").material = load(SHADER_PATH_SCENE);
	get_parent().label.visible = false
	#get_parent().updateHP();

func setTime(time):
	$Timer.wait_time = time
func startTimer():
	$Timer.start()
func _process(delta):
	pass


func _on_timer_timeout():
	get_parent().label.visible = true
	get_parent().get_node("Sprites").material = null;
	queue_free();
