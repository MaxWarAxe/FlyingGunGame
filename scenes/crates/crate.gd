extends Area2D

var EFFECT_ADD_MAG_PROBABILITY = 100
var TRASH_SPEED = 500
var TRASH_MAX_TORQUE = 1000
var TRASH_AMOUNT = 10;

@export var trashScene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func processEffect() -> Node:
	var number = randf_range(0,100)
	if number < EFFECT_ADD_MAG_PROBABILITY:
		return load("res://scenes/effects/effect_add_mag.tscn").instantiate()
	return load("res://scenes/effects/effect_add_mag.tscn").instantiate()

#TODO
@rpc("any_peer","call_local","reliable")
func openCrate(body,id,effect):
	if str(multiplayer.get_unique_id()) == str(id):
		body.add_child(effect)
		effect.init(body);
	call_deferred("spawnTrash")

	queue_free()

	

func spawnTrash():
	for i in range(TRASH_AMOUNT):
		var trash = trashScene.instantiate()
		get_tree().get_root().add_child(trash)
		trash.global_position = self.global_position
		trash.apply_torque(randi() % TRASH_MAX_TORQUE - TRASH_MAX_TORQUE/.2)
		var vec = Vector2.UP.rotated(randi() % 100 - 50)
		trash.apply_force(vec*TRASH_SPEED)

func _on_body_entered(body):
	if multiplayer.get_unique_id() == body.idname.to_int():
		var effect = processEffect()
		openCrate.rpc(body,body.idname,effect)
