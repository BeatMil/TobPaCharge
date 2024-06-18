extends RigidBody2D

"""
Fireball

fireball mustn't hit the caster
-- this is done by adjusting collision_layer

fireball should hit the opponent
-- also done by adjusting collision_layer

lastly fireball queue_free itself with animation "explode"

"""


var is_going_right_side = true
var speed = 20000


func _ready():
	if is_going_right_side:
		apply_central_force(Vector2(speed, 0))
	else:
		apply_central_force(Vector2(-speed, 0))


func set_target(target: String):
	if target == "p1":
		collision_layer = 0b00000000000000001001
		$"Area2D".collision_layer = 0b00000000000000001101
		$"Area2D".collision_mask  = 0b00000000000000001101
	elif target == "p2":
		collision_layer = 0b00000000000000000110
		$"Area2D".collision_layer = 0b00000000000000001110
		$"Area2D".collision_mask  = 0b00000000000000001110
	else:
		printerr("Please choose target!!")


func set_no_target() -> void:
	$"Area2D".collision_layer = 0b00000000000000000000
	$"Area2D".collision_mask  = 0b00000000000000000000

"""
Fireball always explode when hitted by something
"""
func _on_area_2d_area_entered(_area):
	if not _area.is_in_group("fireball"):
		$"AnimationPlayer".play("explode_smol")
		set_no_target()
