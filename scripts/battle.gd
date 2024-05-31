extends Node2D


# configs
var time_control:int = 1 ## seconds
var resolve_time:int = 1 ## seconds


# signals
signal resolve_phase
signal new_turn


func _ready():
	# Connect those signals
	connect("new_turn", $Bot.new_turn)
	connect("new_turn", $Player.new_turn)
	connect("resolve_phase", $Bot.resolve_phase)
	connect("resolve_phase", $Player.resolve_phase)

	$TimeControl.wait_time = time_control
	$"ResolveTimer".wait_time = resolve_time

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
	emit_signal("resolve_phase")
	$"ResolveTimer".start()


func resolve_action(P1_action, P2_action) -> String:
	if P1_action == ActionEnum.actions.CHARGE:
		return "P2 Wins!" if P2_action == ActionEnum.actions.FIREBALL else "Neutral"
	elif P1_action == ActionEnum.actions.BLOCK:
		return "Neutral"
	elif P1_action == ActionEnum.actions.FIREBALL:
		return "P1 Wins!" if P2_action == ActionEnum.actions.CHARGE else "Neutral"
	return "Neutral"


## wait 3 seconds then new turn
func _on_resolve_timer_timeout():
	if $"Player".hp <= 0 or $"Bot".hp <= 0:
		$"CanvasLayer/RestartMenu".open()
	else:
		emit_signal("new_turn")
		$TimeControl.start()
