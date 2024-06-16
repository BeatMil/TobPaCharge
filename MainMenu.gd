extends Control

# Properties
@onready var vbox_member: VBoxContainer = $"VBoxMember"
@onready var invite_friend_button: Button = $InviteFriendButton
@onready var leave_lobby_button: Button = $LeaveLobbyButton
@onready var create_lobby_button: Button = $CreateLobbyButton
"""
Preloads
"""
@onready var LOBBY_MEMBER_NODE = preload("res://nodes/lobby_member.tscn")
@onready var MUL_TEST = preload("res://nodes/multiplayer_player_test.tscn")


func _ready():
	pass


#################################################
# Normal functions
#################################################

# Get the lobby members from Steam
func update_lobby_members() -> void:
	print_rich("[color=orange][b]update_lobby_members()✓[/b][/color]")
	var lobby_id = SteamNetwork.lobby_id

	# clear Vboxmember
	for node in vbox_member.get_children():
		node.queue_free()


	# Get the number of members from this lobby from Steam
	var MEMBERS: int = Steam.getNumLobbyMembers(lobby_id)
	for MEMBER in range(0, MEMBERS):
		# Get the member's Steam ID
		var MEMBER_STEAM_ID: int = Steam.getLobbyMemberByIndex(lobby_id, MEMBER)
		# Get the member's Steam name
		var MEMBER_STEAM_NAME: String = Steam.getFriendPersonaName(MEMBER_STEAM_ID)

		print("steam_id: %s, steam_name: %s"%[MEMBER_STEAM_ID, MEMBER_STEAM_NAME])

		var lobby_member = LOBBY_MEMBER_NODE.instantiate()
		lobby_member.name = str(MEMBER_STEAM_NAME)
		lobby_member.set_member(MEMBER_STEAM_ID, MEMBER_STEAM_NAME)
		vbox_member.add_child(lobby_member)



#################################################
# Buttons
#################################################

func _on_button_pressed():
	SceneTransition.change_scene("res://scenes/battle.tscn")


func _on_create_lobby_button_pressed():
	var error = SteamNetwork.create_lobby()
	if not error:
		create_lobby_button.set_deferred("disabled", true)
		leave_lobby_button.set_deferred("disabled", false)
		invite_friend_button.set_deferred("disabled", false)


func _on_leave_lobby_button_pressed():
	SteamNetwork.leave_lobby()
	create_lobby_button.set_deferred("disabled", false)
	leave_lobby_button.set_deferred("disabled", true)
	invite_friend_button.set_deferred("disabled", true)
	update_lobby_members()


func _on_invite_friend_button_pressed():
	Steam.activateGameOverlayInviteDialog(SteamNetwork.lobby_id)


func _on_debug_button_pressed():
	SteamNetwork.debug()


#################################################
# Call backs
#################################################

"""
This triggers with Steam."lobby_joined"
"""
func _on_lobby_joined(_lobby_id: int, _permissions: int, _locked: bool, _response: int) -> void:
	if _response == 1:
		update_lobby_members()
	else:
		printerr("Create or Join lobby failed")


# Trigger when accepct friend invite from steam
func _on_join_requested(_lobby_id: int, _steam_id: int):
	SteamNetwork.join_lobby(_lobby_id)
