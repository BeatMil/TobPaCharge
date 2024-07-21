extends Control


# Properties
@onready var vbox_member: VBoxContainer = $"VBoxMember"
@onready var versus_bot_button: Node2D = $MenuButtons/VersusBotButton
@onready var create_lobby_button: Node2D = $MenuButtons/CreateLobbyButton
@onready var invite_friend_button: Node2D = $MenuButtons/InviteFriendButton
@onready var start_game_button: Node2D = $MenuButtons/StartGameButton
@onready var leave_lobby_button: Node2D = $MenuButtons/LeaveLobbyButton
@onready var menu_buttons: Node2D = $MenuButtons
@onready var menu_buttons_player: AnimationPlayer = $MenuButtons/MenuButtonsPlayer
@onready var sound_slider: VSlider = %SoundSlider
@onready var lobby_panel_player: AnimationPlayer = $LobbyPanel/LobbyPanelPlayer
@onready var hunter_note: Node2D = $HunterNote


#################################################
# Preloads
#################################################
@onready var LOBBY_MEMBER_NODE = preload("res://nodes/lobby_member.tscn")
@onready var MUL_TEST = preload("res://nodes/multiplayer_player_test.tscn")


#################################################
# Built-in
#################################################
func _ready():
	SteamNetwork.activate_first_achivement("OPEN_GAME")
	SteamNetwork.clear_score()
	SteamNetwork.connect("lobby_member_update", update_lobby_members)
	update_lobby_members()

	OstPlayer.stop_battle_ost()
	sound_slider.value = SteamNetwork.volume_slider


func _process(delta):
	AudioServer.set_bus_volume_db(0, sound_slider.value)


#################################################
# Private functions
#################################################
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("WHAT??? NO QUIT!!")


func _in_lobby_buttons() -> void:
	create_lobby_button.disable()
	leave_lobby_button.enable()
	invite_friend_button.enable()
	lobby_panel_player.play("on")


func _outside_lobby_buttons() -> void:
	create_lobby_button.enable()
	leave_lobby_button.disable()
	invite_friend_button.disable()
	start_game_button.disable()
	lobby_panel_player.play("off")


#################################################
# Public functions
#################################################
# Get the lobby members from Steam
func update_lobby_members() -> void:
	print_rich("[color=orange][b]update_lobby_members()✓[/b][/color]")
	# clear Vboxmember
	for node in vbox_member.get_children():
		node.queue_free()

	await get_tree().create_timer(0.2).timeout

	# Get the number of members from this lobby from Steam
	for member_steam_id in SteamNetwork.lobby_members:
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)

		print("steam_id: %s, steam_name: %s"%[member_steam_id, member_steam_name])

		var lobby_member = LOBBY_MEMBER_NODE.instantiate()
		lobby_member.name = str(member_steam_name)
		lobby_member.set_member(member_steam_id, member_steam_name)
		lobby_member.connect("ready_state_change", check_ready)
		vbox_member.add_child(lobby_member)

	# Update buttons disabled mode
	if SteamNetwork.lobby_members:
		_in_lobby_buttons()
	else:
		_outside_lobby_buttons()


func check_ready() -> void:
	for node in vbox_member.get_children():
		if node.is_ready == false:
			start_game_button.disable()
			return
	start_game_button.enable()


@rpc("any_peer", "call_local")
func start_game() -> void:
	SceneTransition.change_scene("res://scenes/battle_multiplayer.tscn")


#################################################
# Buttons
#################################################
func _on_button_pressed():
	SceneTransition.change_scene("res://scenes/battle.tscn")


func _on_create_lobby_button_pressed():
	var error = SteamNetwork.create_lobby()
	if not error:
		_in_lobby_buttons()


func _on_leave_lobby_button_pressed():
	SteamNetwork.leave_lobby()
	_outside_lobby_buttons()
	update_lobby_members()


func _on_invite_friend_button_pressed():
	Steam.activateGameOverlayInviteDialog(SteamNetwork.lobby_id)


func _on_debug_button_pressed():
	SteamNetwork.debug()


func _on_start_game_button_pressed():
	rpc("start_game")


func _on_versus_bot_on_press() -> void:
	SceneTransition.change_scene("res://scenes/battle_singleplayer.tscn")


func _on_create_lobby_on_press() -> void:
	var error = SteamNetwork.create_lobby()
	if not error:
		_in_lobby_buttons()


func _on_invite_friend_on_press() -> void:
	Steam.activateGameOverlayInviteDialog(SteamNetwork.lobby_id)


func _on_start_game_button_on_press() -> void:
	rpc("start_game")


func _on_leave_lobby_on_press() -> void:
	SteamNetwork.leave_lobby()


func _on_exit_button_on_press() -> void:
	#get_tree().quit()
	OS.kill(OS.get_process_id()) # quit game fast!! but there maybe side effects...


#################################################
# Receive signals
#################################################
func _on_menu_background_animation_finished() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(menu_buttons, "position", Vector2.ZERO, 1).set_trans(Tween.TRANS_BACK)


func _on_hunter_notes_button_on_press() -> void:
	hunter_note.set_deferred("visible", true)


func _on_sound_slider_value_changed(value: float) -> void:
	SteamNetwork.volume_slider = value
