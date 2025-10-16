extends Camera2D
class_name CameraWithUI

var basic_node_to_spectate
var node_to_spectate
var UI
var target_zoom
# Called when the node enters the scene tree for the first time.
func _ready():
	UI = get_node("UI")
	pass # Replace with function body.

func updateUI(ammo,mags):
	UI.updateUI(ammo,mags)

func makeReloadAnim(time):
	UI.makeReloadAnim(time);

func showScore():
	UI.showScore();

func hideScore():
	UI.hideScore();

func updateScore():
	UI.updateScore();

func playStreakAnim(streak):
	UI.playStreakAnim(streak)

func spec():
	if node_to_spectate != null:
		global_position =  node_to_spectate.global_position

func _process(_delta):
	if !node_to_spectate:
		node_to_spectate = basic_node_to_spectate
	global_rotation = 0
	zoom.x = lerp(zoom.x, target_zoom.x,0.5)
	zoom.y = lerp(zoom.y, target_zoom.y,0.5)

	
