extends Node2D


var chosen_action = 0


func _ready():
	$"ActionLabel".text = ActionEnum.actions.keys()[chosen_action]


func random_action():
	chosen_action = randi() % ActionEnum.actions.size()
	$"ActionLabel".text = ActionEnum.actions.keys()[chosen_action]
	if chosen_action == ActionEnum.actions.FIREBALL:
		$"AnimationPlayer".play("fireball")


func new_turn():
	pass
	random_action()
	# print("PLAYER: %s"%[ActionEnum.actions.find_key(chosen_action)])


func _on_fire_ball_button_pressed():
	chosen_action = ActionEnum.actions.FIREBALL
	$ActionLabel.text = ActionEnum.actions.keys()[chosen_action]


func _on_block_button_pressed():
	chosen_action = ActionEnum.actions.BLOCK
	$ActionLabel.text = ActionEnum.actions.keys()[chosen_action]


func _on_charge_button_pressed():
	chosen_action = ActionEnum.actions.CHARGE
	$ActionLabel.text = ActionEnum.actions.keys()[chosen_action]
