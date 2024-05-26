extends RigidBody2D

var is_going_right_side = true
var speed = 20000


func _ready():
	if is_going_right_side:
		apply_central_force(Vector2(speed, 0))
	else:
		apply_central_force(Vector2(-speed, 0))


func explode():
	## TODO create explosion effect
	print("%s explode!"%[name])
	pass

