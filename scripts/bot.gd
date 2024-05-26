extends Node2D

# Preloads
var FIREBALL = preload("res://nodes/fireball.tscn")


# Configs
var chosen_action = ActionEnum.actions.CHARGE
var charge_count = 3


func _ready():
	print_rich("[color=green][b]Nyaaa > w <[/b][/color]")
	print_rich("[img]res://media/TobPaCharge_icon.png[/img]")


func random_action():
	# I don't know how this line work but that's fine XD
	## Edited: ohhhh my god that's genius! XD
	# chosen_action = randi() % ActionEnum.actions.size()
	chosen_action = ActionEnum.actions.FIREBALL


func resolve_phase():
	# Update action Label
	$"Label".text = ActionEnum.actions.keys()[chosen_action]

	# Update animation
	if chosen_action == ActionEnum.actions.FIREBALL:
		$"AnimationPlayer".play("fireball")
		spawn_fireball()
	elif chosen_action == ActionEnum.actions.BLOCK:
		$"AnimationPlayer".play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		$"AnimationPlayer".play("charge")
		charge_count += 1


func spawn_fireball():
	if charge_count:
		charge_count -= 1
		var fireball = FIREBALL.instantiate()
		fireball.position = $"FireBallSpawnPos".position
		fireball.is_going_right_side = false
		fireball.set_target("p1")
		add_child(fireball)


func new_turn():
	random_action()
	$"AnimationPlayer".play("idle")


func _on_area_2d_body_entered(body):
	if body.is_in_group("fireball"):
		body.explode()
		$"AnimationPlayer".play("hitted")
