extends Area2D

var EFFECT_ADD_MAG_PROBABILITY = 100
var TRASH_SPEED = 500
var TRASH_MAX_TORQUE = 1000
var TRASH_AMOUNT = 10;

@export var trashScene : PackedScene
@export var MagEffectPath = "res://scenes/effects/effect_add_mag.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func processEffect():
	var number = randf_range(0,100)
	if number < EFFECT_ADD_MAG_PROBABILITY:
		return MagEffectPath
	return MagEffectPath

#TODO


	

func spawnTrash():
	for i in range(TRASH_AMOUNT):
		var trash = trashScene.instantiate()
		get_tree().get_root().add_child(trash)
		trash.global_position = self.global_position
		trash.apply_torque(randi() % TRASH_MAX_TORQUE - TRASH_MAX_TORQUE/.2)
		var vec = Vector2.UP.rotated(randi() % 100 - 50)
		trash.apply_force(vec*TRASH_SPEED)

@rpc("any_peer","reliable")
func _on_body_entered(body):
	set_deferred("monitoring",false)
	if(multiplayer.get_unique_id() == 1):
		var effectPath = processEffect()
		body.add_effect.rpc_id(body.idname.to_int(),effectPath)
	playAnim.rpc()
		
@rpc("any_peer","call_local","reliable")
func playAnim():
	$AnimationPlayer.play("shrink")

func explode():
	#call_deferred("spawnTrash")
	queue_free()
func _on_animation_player_animation_finished(anim_name):
	explode()
