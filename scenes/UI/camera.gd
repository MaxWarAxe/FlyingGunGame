extends Camera2D

var nodeToSpectate
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateUI(ammo,mags):
	$UI.updateUI(ammo,mags)

func makeReloadAnim(time):
	$UI.makeReloadAnim(time);

func showScore():
	$UI.showScore();

func hideScore():
	$UI.hideScore();

func updateScore():
	$UI.updateScore();
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nodeToSpectate != null:
		position = nodeToSpectate.global_position
	
