extends RigidBody2D


func _ready():
	apply_central_force(Vector2(20000, 0))




func explode():
	## TODO create explosion effect
	print("%s explode!"%[name])
	pass

