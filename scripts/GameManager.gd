extends Node
var Players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@rpc("any_peer","call_local")
func addKill(id):
	for i in Players:
		if Players[i].id == id.to_int():
			Players[i].kills += 1;

@rpc("any_peer","call_local")
func addDeath(id):
	for i in Players:
		if Players[i].id == id.to_int():
			Players[i].deaths += 1;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
