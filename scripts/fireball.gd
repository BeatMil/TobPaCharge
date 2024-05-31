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
		collision_layer = 0b00000000000000000101
		$"Area2D".collision_layer = 0b00000000000000000001
	elif target == "p2":
		collision_layer = 0b00000000000000000110
		$"Area2D".collision_layer = 0b00000000000000000010
	else:
		printerr("Please choose target!!")


func explode():
	## TODO create explosion effect
	print("%s explode!"%[name])
	pass


func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("fireball"):
		$"AnimationPlayer".play("explode")

"""
If fireball hit character(player or bot) while BLOCKING, fireball explode
"""
func _on_area_2d_area_entered(area):
	if area.is_in_group("character"):
		if area.get_parent().chosen_action == ActionEnum.actions.BLOCK:
			$"AnimationPlayer".play("explode_smol")
