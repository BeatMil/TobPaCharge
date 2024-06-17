extends Control

# Properties
@onready var vbox_member: VBoxContainer = $"VBoxMember"
@onready var invite_friend_button: Button = $InviteFriendButton
@onready var leave_lobby_button: Button = $LeaveLobbyButton
@onready var create_lobby_button: Button = $CreateLobbyButton
@onready var start_game_button: Button = $StartGameButton
"""
Preloads
"""
@onready var LOBBY_MEMBER_NODE = preload("res://nodes/lobby_member.tscn")
@onready var MUL_TEST = preload("res://nodes/multiplayer_player_test.tscn")


func _ready():
	SteamNetwork.connect("lobby_member_update", update_lobby_members)
	_outside_lobby_buttons()


func _in_lobby_buttons() -> void:
	create_lobby_button.set_deferred("disabled", true)
	leave_lobby_button.set_deferred("disabled", false)
	invite_friend_button.set_deferred("disabled", false)


func _outside_lobby_buttons() -> void:
	create_lobby_button.set_deferred("disabled", false)
	leave_lobby_button.set_deferred("disabled", true)
	invite_friend_button.set_deferred("disabled", true)
	start_game_button.set_deferred("visible", false)

#################################################
# Normal functions
#################################################

# Get the lobby members from Steam
func update_lobby_members() -> void:
	print_rich("[color=orange][b]update_lobby_members()✓[/b][/color]")
	# clear Vboxmember
	for node in vbox_member.get_children():
		node.queue_free()

	# Get the number of members from this lobby from Steam
	for member_steam_id in SteamNetwork.lobby_members:
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)

		print("steam_id: %s, steam_name: %s"%[member_steam_id, member_steam_name])

		var lobby_member = LOBBY_MEMBER_NODE.instantiate()
		lobby_member.name = str(member_steam_name)
		lobby_member.set_member(member_steam_id, member_steam_name)
		lobby_member.connect("ready_state_change", check_ready)
		vbox_member.add_child(lobby_member)


func check_ready() -> void:
	for node in vbox_member.get_children():
		if node.is_ready == false:
			$StartGameButton.set_deferred("visible", false)
			return
	$StartGameButton.set_deferred("visible", true)


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
