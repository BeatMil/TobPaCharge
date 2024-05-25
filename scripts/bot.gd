extends Node2D


var chosen_action = 0


func _ready():
	pass


func random_action():
	# I don't know how this line work but that's fine XD
	chosen_action = randi() % ActionEnum.actions.size()


func new_turn():
	random_action()

	# Update action Label
	$"Label".text = ActionEnum.actions.keys()[chosen_action]

	# Update animation
	if chosen_action == ActionEnum.actions.FIREBALL:
		$"AnimationPlayer".play("fireball")
	elif chosen_action == ActionEnum.actions.BLOCK:
		$"AnimationPlayer".play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		$"AnimationPlayer".play("charge")
