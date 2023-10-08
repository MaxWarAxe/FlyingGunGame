extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func calculatePos():
	var posx = randf_range(-$Area.shape.extents.x,$Area.shape.extents.x)
	var posy = randf_range(-$Area.shape.extents.y,$Area.shape.extents.y)
	var pos = Vector2(global_position.x + posx * scale.x, global_position.y + posy * scale.y)
	var transf = Transform2D(0.0, pos)
	return transf

func _process(delta):
	pass
