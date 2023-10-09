extends Control

var scorelineScene = load("res://scenes/UI/score_line.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func showScore():
	$Panel.visible = true;

func hideScore():
	$Panel.visible = false;

func updateUI(ammo,mags):
	$HBoxContainer/AmmoLable.text = str(ammo)
	$HBoxContainer/MagsLable.text = str(mags)

func updateScore():
	for n in $Panel/VBoxContainer.get_children():
		if(n.name != "ScoreLineMain"):
			n.queue_free()
	
	for i in GameManager.Players:
		var scoreline = scorelineScene.instantiate()
		$Panel/VBoxContainer.add_child(scoreline)
		scoreline.changeValues(GameManager.Players[i].name,GameManager.Players[i].kills,GameManager.Players[i].deaths,GameManager.Players[i].weapon,GameManager.Players[i].hp,GameManager.Players[i].killsinarow)

func makeReloadAnim(time):
	$ReloadProgress.reload(time)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
