extends Camera2D

var nodeToSpectate
var UI
var targetZoom
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
	if nodeToSpectate != null:
		global_position = nodeToSpectate.global_position

func _process(delta):
	global_rotation = 0
	zoom.x = lerp(zoom.x, targetZoom.x,0.5)
	zoom.y = lerp(zoom.y, targetZoom.y,0.5)

	
