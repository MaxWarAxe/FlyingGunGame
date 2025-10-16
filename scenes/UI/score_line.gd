extends HBoxContainer

func changeValues(new_name,kills,deaths,weapon,hp,streak):
	$Name.text = str(new_name)
	$Kills.text = str(kills)
	$Deaths.text = str(deaths)
	$Weapon.text = str(weapon)
	$HP.text = str(hp)
	$Streak.text = str(streak)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
