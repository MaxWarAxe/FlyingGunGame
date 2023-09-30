extends Area2D

var EFFECT_ADD_MAG_PROBABILITY = 0
var EFFECT_ADD_HP_PROBABILITY = 0
var EFFECT_INVIS_PROBABILITY = 0
var EFFECT_DD_PROBABILITY = 100

var TRASH_SPEED = 500
var TRASH_MAX_TORQUE = 1000
var TRASH_AMOUNT = 10;
var enabled_signals = true;
signal destroyed

@export var trashScene : PackedScene
@export var MagEffectPath = "res://scenes/effects/effect_add_mag.tscn"
@export var HpEffectPath = "res://scenes/effects/add_hp_effect.tscn"
@export var InvisEffectPath = "res://scenes/effects/invis_effect.tscn"
@export var DoubleDamageEffectPath = "res://scenes/effects/double_damage_effect.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func processEffect():
	var number = randf_range(0,100)
	if number < EFFECT_DD_PROBABILITY:
		return DoubleDamageEffectPath
	if number < EFFECT_INVIS_PROBABILITY:
		return InvisEffectPath
	if number < EFFECT_ADD_HP_PROBABILITY:
		return HpEffectPath
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

#@rpc("any_peer","reliable")
func _on_body_entered(body):
	if multiplayer.is_server() and !is_instance_of(body,StaticBody2D) and enabled_signals:
		var effectPath = processEffect()
		body.add_effect.rpc(effectPath)
		playAnim.rpc()
	pass

@rpc("any_peer","call_local","reliable")
func playAnim():
	$AnimationPlayer.play("shrink")

@rpc("any_peer","call_local","reliable")
func explode():
	call_deferred("spawnTrash")
	if multiplayer.get_unique_id() == 1:
		emit_signal("destroyed")
	queue_free()
func _on_animation_player_animation_finished(anim_name):
	explode()
