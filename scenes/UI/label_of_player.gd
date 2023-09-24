extends Node2D

func setup(name,hp):
	$HBoxContainer/NickNameLabel.text = name
	$HBoxContainer/HPValueLabel.text = str(hp)
func updateHP(hp):
	$HBoxContainer/HPValueLabel.text = str(hp)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
