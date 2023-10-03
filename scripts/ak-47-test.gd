extends CharacterBody2D

var SHOOT_FORCE = Vector2(-1,0);
var ANGULAR_SPEED = 0.05;
var ANGULAR_VELOCITY = 0;
var VELOCITY = Vector2.ZERO;
var timer
func _ready():
	timer = get_node("Timer")

