extends Node2D


var chosen_action = 0


func _ready():
	pass


func random_action():
	# I don't know how this line work but that's fine XD
	chosen_action = randi() % ActionEnum.actions.size()
	$"Label".text = ActionEnum.actions.keys()[chosen_action]
	if chosen_action == ActionEnum.actions.FIREBALL:
		$"AnimationPlayer".play("fireball")


func new_turn():
	random_action()
	# print("BOT: %s"%[ActionEnum.actions.find_key(chosen_action)])
