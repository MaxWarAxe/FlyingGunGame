extends Effect
class_name AddMagEffect
var MAG_INCREMENT = 5;

func init():
	get_parent().mags += MAG_INCREMENT;
	get_parent().updateUI();
	queue_free();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
