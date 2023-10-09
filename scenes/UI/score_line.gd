extends HBoxContainer

func changeValues(name,kills,deaths,weapon,hp,streak):
	$Name.text = str(name)
	$Kills.text = str(kills)
	$Deaths.text = str(deaths)
	$Weapon.text = str(weapon)
	$HP.text = str(hp)
	$Streak.text = str(streak)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
