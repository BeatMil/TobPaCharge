extends Node2D

########################################
# nodes
########################################
@onready var player1:Node2D = $"Player1"
@onready var player2:Node2D = $"Player2"
@onready var time_control_timer:Timer = $"TimeControl"
@onready var resolve_timer:Timer = $"ResolveTimer"
@onready var restart_menu:Control = $"CanvasLayer/RestartMenu"


########################################
# configs
########################################
var time_control:int = 1 ## seconds
var resolve_time:int = 1 ## seconds


########################################
# signals
########################################
signal resolve_phase
signal new_turn


########################################
# private functions
########################################
func _setup_player() -> void:
	# get players from steam lobby and assign them to character
	var lobby_size: int = SteamNetwork.lobby_members.size()
	if  lobby_size > 2:
		printerr("lobby member exceed limits")
	elif lobby_size == 2:
		player1.steam_id = SteamNetwork.lobby_members[0]
		player2.steam_id = SteamNetwork.lobby_members[1]
		print_rich("[color=orange][b]Game Start!!∑d(°∀°d)[/b][/color]")
	else:
		printerr("not enough players!")
		# SceneTransition.change_scene("res://scenes/main_menu.tscn")


########################################
# public functions
########################################
func resolve_action(P1_action, P2_action) -> String:
	if P1_action == ActionEnum.actions.CHARGE:
		return "P2 Wins!" if P2_action == ActionEnum.actions.FIREBALL else "Neutral"
	elif P1_action == ActionEnum.actions.BLOCK:
		return "Neutral"
	elif P1_action == ActionEnum.actions.FIREBALL:
		return "P1 Wins!" if P2_action == ActionEnum.actions.CHARGE else "Neutral"
	return "Neutral"


########################################
# Notifications
########################################
func _ready():
	_setup_player()

	time_control_timer.wait_time = time_control
	resolve_timer.wait_time = resolve_time
	
	time_control_timer.start()
	emit_signal("new_turn")


func _process(_delta):
	$TimeLeftLabel.text = "%.2f" %time_control_timer.time_left


########################################
# received signals
########################################
func _on_time_control_timeout():
	### Resolve actions
	var result = resolve_action(player1.chosen_action, player2.chosen_action)
	print("P1: %s, P2: %s, %s"%[ActionEnum.actions.keys()[player1.chosen_action],
		ActionEnum.actions.keys()[player2.chosen_action], result])
	emit_signal("resolve_phase")
	resolve_timer.start()


func _on_resolve_timer_timeout():
	### After action resolved
	# go to next turn or restart match
	if player1.hp <= 0 or player2.hp <= 0:
		restart_menu.open()
	else:
		emit_signal("new_turn")
		time_control_timer.start()


