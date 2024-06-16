extends Node2D

"""
Beat's Note
- Check if steam is running
- Check if user owns the game
- Then you can get userID, userSteamLevel, userAvatar

To get userAvatar: you gotta connect avatar_loaded first
avatar_loaded returns 3 args which is id, avatar_size and buffer
use avatar_size and buffer to create texture then assign it to TextureRect


This is what I learned so far...
"""


var is_on_steam: bool = false
var is_on_steam_deck: bool = false
var is_online: bool = false
var is_owned: bool = false
var steam_id: int = 0
var steam_username: String = "[not set]"

"""
Lobby things here
"""

var lobby_id: int = 0
var lobby_members: Array = []
var lobby_max_members: int = 4

"""
Steam Multiplayer thingy
"""

var steam_multiplayer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

"""
Preloads
"""
@onready var LOBBY_MEMBER_NODE = preload("res://nodes/lobby_member.tscn")
@onready var MUL_TEST = preload("res://nodes/multiplayer_player_test.tscn")

"""
Nodes
"""
@onready var lobby_id_label: RichTextLabel = $"LobbyIdLabel"
@onready var vbox_member: VBoxContainer = $"VBoxMember"
@onready var create_lobby_button: Button = $"CreateLobbyButton"
@onready var leave_lobby_button: Button = $"LeaveLobbyButton"
@onready var lobby_line_edit: LineEdit = $"LobbyIdLineEdit"
@onready var chat_label: RichTextLabel = $"AvatarPanel/ChatLabel"
@onready var chat_line_edit: LineEdit = $"ChatLineEdit"


func _ready() -> void:
	# Steam.connect("avatar_loaded", _on_avatar_loaded)
	Steam.connect("lobby_created", _on_lobby_created)
	Steam.connect("lobby_joined", _on_lobby_joined)
	# Steam.connect("join_requested", _on_join_requested)
	# Steam.connect("lobby_chat_update", _on_lobby_chat_update) # when other player join
	# Steam.connect("lobby_message", _on_lobby_message)
	# Steam.connect("lobby_invite", _on_lobby_invite)

	multiplayer.connect("peer_connected", _peer_connected)
	multiplayer.connect("peer_disconnected", _peer_disconnected)
	# steam_multiplayer.connect("lobby_created", _on_lobby_created)
	# steam_multiplayer.connect("lobby_joined", _on_lobby_joined)

	_initialize_steam() # check if steam is running


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Steam.run_callbacks()


func _initialize_steam() -> void:
	if Engine.has_singleton("Steam"):
		OS.set_environment("SteamAppId", str(480))
		OS.set_environment("SteamGameId", str(480))

		var init_response: Dictionary = Steam.steamInit(false)
		# If the status isn't one, print out the possible error and quit the program
		if init_response['status'] != 1:
			printerr("[STEAM] Failed to initialize: %s Shutting down..." %
			str(init_response['verbal']))
			get_tree().quit()

		# Is the user actually using Steam; if false,
		# the app assumes this is a non-Steam version
		is_on_steam = true

		# Checking if the app is on Steam Deck to modify certain behaviors
		is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()

		# Acquire information about the user
		is_online = Steam.loggedOn()
		steam_id = Steam.getSteamID()
		steam_username = Steam.getPersonaName()

		# Check if account owns the game
		is_owned = Steam.isSubscribed()

		if is_owned == false:
			printerr("[STEAM] User does not own this game")
			# Uncomment this line to close the game if the user does not own the game
			#get_tree().quit()

	else:
		printerr("Engine does not have the Steam Singleton! Please make sure \n
		you add GodotSteam as a GDNative / GDExtension Plug-in, or with a \n
		compiled Godot version including GodotSteam / Steamworks.\n\n
		For more information, visit https://godotsteam.com/")


func _on_button_pressed():
	print("bob")
	if is_online:
		print("bob2")
		$"UsernameLabel".text = Steam.getPersonaName()
		$"UserLevelLabel".text = str(Steam.getPlayerSteamLevel())


func _on_button_2_pressed():
	Steam.getPlayerAvatar(Steam.AVATAR_LARGE, Steam.getSteamID())


func _on_button_3_pressed():
	Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, Steam.getSteamID())


func _on_button_4_pressed():
	Steam.getPlayerAvatar(Steam.AVATAR_SMALL, Steam.getSteamID())


#################################################
# LOBBY
#################################################

func _on_create_lobby_button_pressed():
	create_lobby()


# When the user starts a game with multiplayer enabled
func create_lobby() -> void:
	# Make sure a lobby is not already set
	if lobby_id == 0:
		# Set the lobby to public with ten members max
		Steam.createLobby(Steam.LOBBY_TYPE_FRIENDS_ONLY, lobby_max_members)
		# steam_multiplayer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_FRIENDS_ONLY, 4)
		multiplayer.multiplayer_peer = steam_multiplayer
	else:
		printerr("Lobby create failed.")


# Get the lobby members from Steam
func get_lobby_members() -> void:
	# Clear your previous lobby list
	lobby_members.clear()

	# clear Vboxmember
	for node in vbox_member.get_children():
		node.queue_free()


	# clear ColorPanels
	for node in $"ColorPanels".get_children():
		node.queue_free()


	# Get the number of members from this lobby from Steam
	var MEMBERS: int = Steam.getNumLobbyMembers(lobby_id)
	# Update the player list title
	print("Player List ("+str(MEMBERS)+")")
	# Get the data of these players from Steam
	for MEMBER in range(0, MEMBERS):
		print(MEMBER)
		# Get the member's Steam ID
		var MEMBER_STEAM_ID: int = Steam.getLobbyMemberByIndex(lobby_id, MEMBER)
		# Get the member's Steam name
		var MEMBER_STEAM_NAME: String = Steam.getFriendPersonaName(MEMBER_STEAM_ID)

		print("MEMBER_STEAM_ID: "+str(MEMBER_STEAM_ID))
		print("MEMBER_STEAM_NAME: "+str(MEMBER_STEAM_NAME))

		var lobby_member = LOBBY_MEMBER_NODE.instantiate()
		lobby_member.name = str(MEMBER_STEAM_NAME)
		lobby_member.set_member(MEMBER_STEAM_ID, MEMBER_STEAM_NAME)
		vbox_member.add_child(lobby_member)

		# Spawn multiplayer test thingy
		var mul_test = MUL_TEST.instantiate()
		mul_test.player_id = MEMBER_STEAM_ID
		mul_test.position = $"SpawnPoints".get_children()[MEMBER].position
		$"ColorPanels".add_child(mul_test)

		# Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, MEMBER_STEAM_ID) nice?
		# # Add them to the player list
		# add_player_to_connect_list(MEMBER_STEAM_ID, MEMBER_STEAM_NAME)


func get_lobby_members_at_home() -> void:
	# Get the number of members from this lobby from Steam
	var MEMBERS: int = Steam.getNumLobbyMembers(lobby_id)
	# Update the player list title
	print("Player List ("+str(MEMBERS)+")")
	print("peer: %s"% multiplayer.get_peers())


func leave_lobby() -> void:
	if lobby_id != 0:
		Steam.leaveLobby(lobby_id)
		print("Left the lobby")
		
		# Reset lobby_id
		# lobby_id = 0
		# clear Vboxmember
		for node in vbox_member.get_children():
			node.queue_free()

		# Set label
		lobby_id_label.text = ""

		# Set buttons
		create_lobby_button.disabled = false
		leave_lobby_button.disabled = true


func _on_leave_lobby_button_pressed():
	leave_lobby()


func _on_join_lobby_button_pressed():
	Steam.joinLobby(int(lobby_line_edit.text))


func _on_lobby_id_line_edit_text_submitted(new_text):
	Steam.joinLobby(int(new_text))


func _on_chat_line_edit_text_submitted(new_text):
	var IS_SENT: bool = Steam.sendLobbyChatMsg(lobby_id, new_text)
	if not IS_SENT:
		printerr("Sent message failed")
	else:
		print("message sent!: ", new_text)
		chat_line_edit.text = ""


#################################################
# CALLBACKS
#################################################

# When a lobby message is received
func _on_lobby_message(_lobby_id: int, user: int, message: String, type: int) -> void:
	chat_label.text += "%s: %s\n"%[Steam.getFriendPersonaName(user), message]
	print("▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦") 
	print("%s %s: %s, %s"%[_lobby_id, Steam.getFriendPersonaName(user), message, type])
	print("▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦") 
	pass
	# process_lobby_message(_result, user, message, type)


# A lobby has been successfully created
func _on_lobby_created(connect_result: int, _lobby_id: int) -> void:
	if connect_result == 1:
		print("[STEAM] Created a lobby: "+str(lobby_id)+"\n")

		# Set lobby joinable as a test
		var SET_JOINABLE: bool = Steam.setLobbyJoinable(lobby_id, true)
		print("[STEAM] The lobby has been set joinable: "+str(SET_JOINABLE))


		# Set some lobby data
		var SET_LOBBY_DATA = Steam.setLobbyData(lobby_id, "name",
			str(Steam.getPersonaName())+"'s Lobby")
		print("[STEAM] Setting lobby name data successful: "+str(SET_LOBBY_DATA))

		# Allow P2P connections to fallback to being relayed through Steam if needed
		var IS_RELAY: bool = Steam.allowP2PPacketRelay(true)
		print("[STEAM] Allowing Steam to be relay backup: "+str(IS_RELAY)+"\n")

		# Disable create lobby button
		create_lobby_button.disabled = true
		leave_lobby_button.disabled = false
	else:
		print("[STEAM] Failed to create lobby\n")


"""
This trigger both when create or join lobby.
"""
func _on_lobby_joined(_lobby_id: int, _permissions: int, _locked: bool, _response: int) -> void:
	print_rich("[color=purple][b]==_on_lobby_joined!![/b][/color]")
	print("response: ", _response)
	if _response == 1:
		lobby_id = _lobby_id
		# Print the lobby ID to a label
		lobby_id_label.text = "Lobby ID: " + str(lobby_id)

		get_lobby_members()
		# Disable create lobby button
		create_lobby_button.disabled = true
		leave_lobby_button.disabled = false

	else:
		printerr("Create or Join lobby failed")


# When a lobby chat is updated
func _on_lobby_chat_update(_lobby_id: int, changed_id: int, making_change_id: int, chat_state: int) -> void:
	# Note that chat state changes is: 1 - entered, 2 - left, 4 - user disconnected before leaving, 8 - user was kicked, 16 - user was banned
	print("[STEAM] Lobby ID: "+str(_lobby_id)+", Changed ID: "+str(changed_id)+", Making Change: "+str(making_change_id)+", Chat State: "+str(chat_state))

	if chat_state == 1:
		chat_label.text += ("[STEAM]  has joined the lobby.\n")
		# Else if a player has left the lobby
	elif chat_state == 2:
		chat_label.text += ("[STEAM]  has left the lobby.\n")
	# Update the lobby now that a change has occurred
	get_lobby_members()


# Trigger when got a friend invite from steam
func _on_lobby_invite(inviter: int, lobby: int, game: int):
	print("%s, %s, %s"%[inviter, lobby, game])


# Trigger when accepct friend invite from steam
func _on_join_requested(_lobby_id: int, _steam_id: int):
	var error = steam_multiplayer.connect_lobby(_lobby_id)
	if error:
		printerr("Join lobby failed")
	#Steam.joinLobby(_lobby_id)


func _peer_connected(_id :int):
	print("=============connected peer id: %s"%_id)


func _peer_disconnected(_id :int):
	print("=============disconnected peer id: %s"%_id)
