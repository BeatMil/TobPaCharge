extends Node2D

# Preloads
var FIREBALL = preload("res://nodes/fireball.tscn")


# Configs
var chosen_action = ActionEnum.actions.CHARGE
var charge_count = 0


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


func resolve_phase():
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
