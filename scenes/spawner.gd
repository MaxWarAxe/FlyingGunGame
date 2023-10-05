extends Area2D
#@export var SHAPE : Shape2D
@export var ITEM_TO_SPAWN : PackedScene
@export var SPAWN_TIME = 0.1;
@export var MAX_ITEMS = 2;
var index = 0;
var amount = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.wait_time = SPAWN_TIME
	$SpawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onCrateDestroy():
	if multiplayer.get_unique_id() == 1:
		amount -= 1
@rpc("any_peer","call_local","reliable")
func addCrateInfo(pos,name):
	GameManager.addCrate(pos,name)

@rpc("any_peer","call_local","reliable")
func spawn(pos,named):
	var item = ITEM_TO_SPAWN.instantiate()
	if multiplayer.get_unique_id() == 1:
		addCrateInfo.rpc(pos,named)
		item.connect("destroyed",onCrateDestroy)
	item.name = named
	get_tree().get_root().add_child(item)
	item.global_position = pos
	return item

func spawncheck(pos,named):
	var item = ITEM_TO_SPAWN.instantiate()
	item.name = named
	item.visible = false;
	item.enabled_signals = false;
	get_tree().get_root().add_child(item)
	item.global_position = pos
	return item

func calculatePos():
	var posx = randf_range(-$Area.shape.extents.x,$Area.shape.extents.x)
	var posy = randf_range(-$Area.shape.extents.y,$Area.shape.extents.y)
	var pos = Vector2(global_position.x + posx * scale.x, global_position.y + posy * scale.y)
	var checkcrate = spawncheck(pos,str("check" + str(index)))
	await get_tree().create_timer(0.05).timeout
	for i in checkcrate.get_overlapping_bodies():
		if (is_instance_of(i,StaticBody2D)):
			pos = await calculatePos()
	checkcrate.queue_free()
	return pos
	
func _on_spawn_timer_timeout():
	if multiplayer.get_unique_id() == 1 and amount < MAX_ITEMS:
		index += 1
		amount += 1
		var pos = await calculatePos()
		spawn.rpc(pos,str("crate" + str(index)))
		
		
