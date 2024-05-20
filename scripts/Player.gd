extends Node2D


var chosen_action = 0


func _ready():
	pass


func random_action():
	chosen_action = randi() % ActionEnum.actions.size()


func new_turn():
	random_action()
	print("PLAYER: %s"%[ActionEnum.actions.find_key(chosen_action)])
