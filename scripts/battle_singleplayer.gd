extends Node2D

########################################
# nodes
########################################
@onready var player1:Node2D = $"Player1"
@onready var player2:Node2D = $"Bot"
@onready var time_control_timer:Timer = $"TimeControl"
@onready var resolve_timer:Timer = $"ResolveTimer"
@onready var restart_menu:Control = $"CanvasLayer/RestartMenu"
@onready var think_time_display = $ThinkTimeDisplay
@onready var p1_score_label: RichTextLabel = $Player1/P1ScoreLabel
@onready var p2_score_label: RichTextLabel = $Bot/P2ScoreLabel


########################################
# configs
########################################
var time_control:float = 1.5 ## seconds
var resolve_time:float = 1 ## seconds
var player1_ready: bool = false
var player2_ready: bool = false


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
		Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, player1.steam_id)
		Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, player2.steam_id)
		print_rich("[color=orange][b]Game Start!!∑d(°∀°d)[/b][/color]")
	else:
		printerr("not enough players!")
		# SceneTransition.change_scene("res://scenes/main_menu.tscn")
	think_time_display.time_to_think = time_control


func _start_think_time() -> void:
	time_control_timer.start()
	think_time_display.start_think_time()


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
	SteamNetwork.activate_first_achivement("PLAY_WITH_BOT")
	# multiplayer.connect("peer_disconnected", _peer_disconnected)
	SteamNetwork.create_single_player_lobby()
	player1.connect("action_choosed", _player1_action_choosed)
	player2.connect("action_choosed", _player2_action_choosed)
	_setup_player()

	p1_score_label.text = "%s Wins"%SteamNetwork.p1_score
	p2_score_label.text = "%s Wins"%SteamNetwork.p2_score

	time_control_timer.wait_time = time_control
	resolve_timer.wait_time = resolve_time
	
	_start_think_time()
	emit_signal("new_turn")


func _process(_delta):
	$TimeLeftLabel.text = "%.2f" %time_control_timer.time_left


########################################
# received signals
########################################
func _on_time_control_timeout():
	if not (player1_ready and player2_ready):
		await get_tree().create_timer(0.1).timeout
		_on_time_control_timeout()
		return
	else:
		# reset ready
		pass
		player1_ready = false
		player2_ready = false

	### Resolve actions
	var result = resolve_action(player1.chosen_action, player2.chosen_action)
	print("P1: %s, P2: %s, %s"%[ActionEnum.actions.keys()[player1.chosen_action],
		ActionEnum.actions.keys()[player2.chosen_action], result])
	### Wait for opponent response here
	## I can await for signals from both player

	if player1.chosen_action == ActionEnum.actions.BIGFIREBALL:
		%AnimationPlayer.play("vanilla_metsu_hadoken_splash")
		await %AnimationPlayer.animation_finished

	if player2.chosen_action == ActionEnum.actions.BIGFIREBALL:
		%KaisoukoMetsuPlayer.play("kaisouko_metsu_hadoken")
		await %KaisoukoMetsuPlayer.animation_finished


	emit_signal("resolve_phase")
	resolve_timer.start()


func _on_resolve_timer_timeout():
	### After action resolved
	# go to next turn or restart match
	if player1.hp <= 0:
		SteamNetwork.p2_score += 1
		p2_score_label.text = "%s Wins"%SteamNetwork.p2_score
		restart_menu.open()
	elif player2.hp <= 0:
		SteamNetwork.p1_score += 1
		p1_score_label.text = "%s Wins"%SteamNetwork.p1_score
		restart_menu.open()
	else:
		emit_signal("new_turn")
		_start_think_time()

	if SteamNetwork.p1_score >= 10:
		SteamNetwork.activate_first_achivement("BOT_10_WINS")
	elif SteamNetwork.p1_score >= 5:
		SteamNetwork.activate_first_achivement("BOT_5_WINS")


func _peer_disconnected(_id: int):
	SceneTransition.change_scene("res://scenes/main_menu.tscn")
	SteamNetwork.leave_lobby()


func _player1_action_choosed() -> void:
	player1_ready = true


func _player2_action_choosed() -> void:
	player2_ready = true
