extends Control
var shoot_speed = GameManager.Player.SHOOT_TIME_SPEED
var scorelineScene = load("res://scenes/UI/score_line.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.speed_scale = 1/shoot_speed
	var mobile_buttons = get_tree().get_nodes_in_group("mobile_buttons")
	for button in mobile_buttons:
		button.visible = Settings.on_mobile
	GameManager.connect("streakAdded",playStreakAnimById)
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

func playStreakAnimById(streak,id):
	if str(multiplayer.get_unique_id()) == str(id):
		playStreakAnim(streak)

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
	if Input.is_action_pressed("shoot"):
		$AnimationPlayer.play("shoot_mobile_ui")
	pass


func _on_left_pressed() -> void:
	Input.action_press("rotate_left")


func _on_right_pressed() -> void:
	Input.action_press("rotate_right")





func _on_reload_pressed() -> void:
	Input.action_press("reload")


func _on_shoot_button_up() -> void:
	Input.action_release("shoot")


func _on_left_button_up() -> void:
	Input.action_release("rotate_left")


func _on_right_button_up() -> void:
	Input.action_release("rotate_right")


func _on_reload_button_up() -> void:
	Input.action_release("reload")

func _on_shoot_pressed() -> void:
	Input.action_press("shoot")
