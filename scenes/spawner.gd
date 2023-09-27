extends Area2D
#@export var SHAPE : Shape2D
@export var ITEM_TO_SPAWN : PackedScene
@export var SPAWN_TIME = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.wait_time = SPAWN_TIME
	$SpawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer","call_local","reliable")
func spawn(pos):
	var item = ITEM_TO_SPAWN.instantiate()
	get_tree().get_root().add_child(item)
	item.position = pos
	
func _on_spawn_timer_timeout():
	if multiplayer.get_unique_id() == 1:
		print($Area.shape.extents.x * scale.x)
		print($Area.shape.extents.y * scale.y)
		
		var posx = randf_range(-$Area.shape.extents.x,$Area.shape.extents.x)
		var posy = randf_range(-$Area.shape.extents.y,$Area.shape.extents.y)
		
		var pos = Vector2(global_position.x + posx * scale.x, global_position.y + posy * scale.y)
		
		spawn.rpc(pos)
