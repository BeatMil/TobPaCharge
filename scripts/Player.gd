extends Node2D

# Preloads
var FIREBALL = preload("res://nodes/fireball.tscn")


# Configs
var chosen_action = ActionEnum.actions.CHARGE
var charge_count = 0
var hp = 1


func _ready():
	$"ActionLabel".text = ActionEnum.actions.keys()[chosen_action]


func random_action():
	chosen_action = ActionEnum.actions.keys()[randi() % ActionEnum.actions.size()]
	$"ActionLabel".text = ActionEnum.actions.keys()[chosen_action]


func new_turn():
	pass
	# random_action()
	# print("PLAYER: %s"%[ActionEnum.actions.find_key(chosen_action)])
	$"AnimationPlayer".play("idle")
	$ActionLabel.text = "Ready"
	chosen_action = ActionEnum.actions.CHARGE
	if charge_count <= 0:
		# turn off fireball buttons
		$"CanvasLayer/Buttons/FireBallButton".disabled = true
	else:
		$"CanvasLayer/Buttons/FireBallButton".disabled = false


func resolve_phase():
	if chosen_action == ActionEnum.actions.FIREBALL and charge_count:
		$"AnimationPlayer".play("fireball")
		spawn_fireball()
	elif chosen_action == ActionEnum.actions.BLOCK:
		$"AnimationPlayer".play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		$"AnimationPlayer".play("charge")
		charge_count += 1
	else:
		## It shouldn't reach this else...
		$"AnimationPlayer".play("charge")
		charge_count += 1
		printerr("Idle: not enough charges?")


func spawn_fireball():
	if charge_count:
		charge_count -= 1
		var fireball = FIREBALL.instantiate()
		fireball.position = $"FireBallSpawnPos".position
		fireball.set_target("p2")
		add_child(fireball)


func _on_fire_ball_button_pressed():
	chosen_action = ActionEnum.actions.FIREBALL
	$ActionLabel.text = ActionEnum.actions.keys()[chosen_action]


func _on_block_button_pressed():
	chosen_action = ActionEnum.actions.BLOCK
	$ActionLabel.text = ActionEnum.actions.keys()[chosen_action]


func _on_charge_button_pressed():
	chosen_action = ActionEnum.actions.CHARGE
	$ActionLabel.text = ActionEnum.actions.keys()[chosen_action]


func _on_area_2d_body_entered(body):
	if body.is_in_group("fireball"):
		if chosen_action in [ActionEnum.actions.CHARGE, ActionEnum.actions.CHARGE]:
			$"AnimationPlayer".play("hitted")
			hp -= 1
