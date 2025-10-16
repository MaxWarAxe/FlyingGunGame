extends Effect
class_name AddHpEffect
var HP_INCREMENT = 15

#@rpc("any_peer","call_local")
func init():
	get_parent().hp += HP_INCREMENT;
	get_parent().updateHP();
	queue_free();


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
