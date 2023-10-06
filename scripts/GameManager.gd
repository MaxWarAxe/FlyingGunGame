extends Node
var Players = {}
var Crates = {}
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
func addCrate(pos,name):
	Crates[name] = {
		"pos" : pos,
		"name":name
	}
@rpc("any_peer","call_local","reliable")
func deleteCrate(name):
	Crates.erase(name)


func _process(delta):
	pass
