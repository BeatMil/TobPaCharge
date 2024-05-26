extends RigidBody2D

var is_going_right_side = true
var speed = 20000


func _ready():
	if is_going_right_side:
		apply_central_force(Vector2(speed, 0))
	else:
		apply_central_force(Vector2(-speed, 0))


func set_target(target: String):
	if target == "p1":
		collision_layer = 0b00000000000000000001
		pass
	elif target == "p2":
		collision_layer = 0b00000000000000000010
	else:
		printerr("Please choose target!!")


func explode():
	## TODO create explosion effect
	print("%s explode!"%[name])
	pass

