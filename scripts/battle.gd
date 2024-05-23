extends Node2D


# configs
var time_control:int = 1


# signals
signal new_turn


func _ready():
	connect("new_turn", $Bot.new_turn)
	connect("new_turn", $Player.new_turn)
	$TimeControl.wait_time = time_control
	$TimeControl.start()
	emit_signal("new_turn")


func _process(_delta):
	$TimeLeftLabel.text = "%.2f" %$TimeControl.time_left


func _on_time_control_timeout():
	# Resolve this turn battle
	## Get Player's action
	## Get Bot's action
	var result = resolve_action($"Player".chosen_action, $"Bot".chosen_action)
	print("P1: %s, P2: %s, %s"%[ActionEnum.actions.keys()[$"Player".chosen_action],
		ActionEnum.actions.keys()[$Bot.chosen_action], result])
	$TimeControl.start()
	emit_signal("new_turn")


func resolve_action(P1_action, P2_action) -> String:
	if P1_action == ActionEnum.actions.CHARGE:
		return "P2 Wins!" if P2_action == ActionEnum.actions.FIREBALL else "Neutral"
	elif P1_action == ActionEnum.actions.BLOCK:
		return "Neutral"
	elif P1_action == ActionEnum.actions.FIREBALL:
		return "P1 Wins!" if P2_action == ActionEnum.actions.CHARGE else "Neutral"
	return "Neutral"
