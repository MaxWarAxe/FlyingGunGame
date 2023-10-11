extends Node
var Players = {}
var Crates = {}

signal streakAdded
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear():
	Players.clear()
	Crates.clear()

@rpc("any_peer","call_local","reliable")
func addKill(id):
	for i in Players:
		if Players[i].id == id.to_int():
			Players[i].kills += 1;
			Players[i].killsinarow += 1;
			emit_signal("streakAdded",Players[i].killsinarow,id)
@rpc("any_peer","call_local","reliable")
func addDeath(id):
	for i in Players:
		if Players[i].id == id.to_int():
			Players[i].deaths += 1;
			Players[i].killsinarow = 0;
func addCrate(pos,name):
	Crates[name] = {
		"pos" : pos,
		"name": name
	}
@rpc("any_peer","call_local","reliable")
func deleteCrate(name):
	Crates.erase(name)

@rpc("any_peer","call_local","reliable")
func changeHP(id,hp):
	for i in Players:
		if Players[i].id == id.to_int():
			Players[i].hp = hp;


	
func _process(delta):
	pass
