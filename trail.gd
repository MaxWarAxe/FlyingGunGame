extends Line2D
class_name Trail
var dynamic_target : Node2D
var created = false

func create(_dynamic_target : Node2D, static_source_position : Vector2):
	dynamic_target = _dynamic_target
	points[0] = (static_source_position)
	points[1] = (dynamic_target.global_position)
	created = true
func _process(_delta: float) -> void:
	print(points)
	if !created:
		return
	if dynamic_target:
		points[1] = dynamic_target.global_position
	else:
		destroy()
func destroy():
	width = lerp(width,0.0,0.1)
	modulate.a = lerp(modulate.a,0.0,0.1)
	if(width == 0):
		queue_free()
