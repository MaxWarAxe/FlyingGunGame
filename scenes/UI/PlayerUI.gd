extends Control

var scorelineScene = load("res://scenes/UI/score_line.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("streakAdded",playStreakAnimFromServer)
	pass

func showScore():
	$Panel.visible = true;

func hideScore():
	$Panel.visible = false;

func updateUI(ammo,mags):
	$HBoxContainer/AmmoLable.text = str(ammo)
	$HBoxContainer/MagsLable.text = str(mags)

func updateScore():
	call_deferred("updateScoreDeff")

func updateScoreDeff():
	for n in $Panel/VBoxContainer.get_children():
		if(n.name != "ScoreLineMain"):
			n.queue_free()
	
	for i in GameManager.Players:
		var scoreline = scorelineScene.instantiate()
		$Panel/VBoxContainer.add_child(scoreline)
		scoreline.changeValues(GameManager.Players[i].name,GameManager.Players[i].kills,GameManager.Players[i].deaths,GameManager.Players[i].weapon,GameManager.Players[i].hp,GameManager.Players[i].killsinarow)

func playStreakAnimFromServer(streak,id):
	if multiplayer.get_unique_id() == 1:
		playStreakAnim.rpc_id(id.to_int(),streak)

@rpc("any_peer","call_local")
func playStreakAnim(streak):
	match streak:
		1:
			$StreakMask/StreakAnim.play("streak1")
		2:
			$StreakMask/StreakAnim.play("streak2")
		3:
			$StreakMask/StreakAnim.play("streak3")
		4:
			$StreakMask/StreakAnim.play("streak4")
		5:
			$StreakMask/StreakAnim.play("streak5")
		_:
			$StreakMask/StreakAnim.play("streak5")
func makeReloadAnim(time):
	$ReloadProgress.reload(time)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.x = 1/get_parent().zoom.x
	scale.y = 1/get_parent().zoom.y
	pass
