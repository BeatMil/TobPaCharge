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

@onready var create_lobby_button: Button = $"CreateLobbyButton"
@onready var lobby_id_label: RichTextLabel = $"LobbyIdLabel"
@onready var vbox_member: VBoxContainer = $"VBoxMember"

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

func _ready() -> void:
	# Steam.connect("avatar_loaded", _on_avatar_loaded)
	#Steam.connect("lobby_created", _on_lobby_created)
	# Steam.connect("lobby_joined", _on_lobby_joined)
	Steam.connect("join_requested", _on_join_requested)
	# Steam.connect("lobby_chat_update", _on_lobby_chat_update) # when other player join
	# Steam.connect("lobby_message", _on_lobby_message)
	# Steam.connect("lobby_invite", _on_lobby_invite)


	steam_multiplayer.connect("lobby_created", _on_lobby_created)
	steam_multiplayer.connect("lobby_joined", _on_lobby_joined)


	multiplayer.connect("peer_connected", _peer_connected)
	multiplayer.connect("peer_disconnected", _peer_disconnected)

	_initialize_steam() # check if steam is running


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


func spawn_color_controller(_id: int) -> void:
	# Spawn multiplayer test thingy
	var mul_test = MUL_TEST.instantiate()
	mul_test.player_id = _id
	if _id == 1:
		mul_test.position = $"SpawnPoints".get_children()[0].position
	else:
		mul_test.position = $"SpawnPoints".get_children()[1].position
	$"ColorPanels".add_child(mul_test)


# Get the lobby members from Steam
func get_lobby_members() -> void:
	# Clear your previous lobby list
	lobby_members.clear()

	# clear Vboxmember
	for node in vbox_member.get_children():
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


func get_lobby_members_at_home() -> void:
	# Get the number of members from this lobby from Steam
	var MEMBERS: int = Steam.getNumLobbyMembers(lobby_id)
	# Update the player list title
	print("Player List ("+str(MEMBERS)+")")
	print("peer: %s"% multiplayer.get_peers())


func create_lobby() -> void:
	var error = steam_multiplayer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_FRIENDS_ONLY, 4)
	if error:
		printerr("Create lobby failed")
	multiplayer.multiplayer_peer = steam_multiplayer

	spawn_color_controller(multiplayer.get_unique_id())
	#Steam.createLobby(Steam.LOBBY_TYPE_FRIENDS_ONLY, lobby_max_members)


# A lobby has been successfully created
func _on_lobby_created(connect_result: int, _lobby_id: int) -> void:
	if connect_result == 1:
		lobby_id = _lobby_id
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

		get_lobby_members()
		# Disable create lobby button
		# create_lobby_button.disabled = true
	else:
		print("[STEAM] Failed to create lobby\n")


"""
This doesn't seem to trigger anytime...
"""
func _on_lobby_joined(_lobby_id: int, _permissions: int, _locked: bool, _response: int) -> void:
	print("=====_on_lobby_joined=====")
	print("response: ", _response)
	if _response == 1:
		lobby_id = _lobby_id
		# Print the lobby ID to a label
		lobby_id_label.text = "Lobby ID: " + str(lobby_id)

		get_lobby_members()
		# Disable create lobby button
		create_lobby_button.disabled = true
		# leave_lobby_button.disabled = false
	else:
		printerr("Create or Join lobby failed")


# Trigger when accepct friend invite from steam
func _on_join_requested(_lobby_id: int, _steam_id: int):
	var error = steam_multiplayer.connect_lobby(_lobby_id)
	if error:
		printerr("Join lobby error!")
	else:
		lobby_id = _lobby_id
	multiplayer.multiplayer_peer = steam_multiplayer
	#Steam.joinLobby(_lobby_id)


func _peer_connected(_id :int):
	print("=============connected peer id: %s"%_id)
	get_lobby_members()
	spawn_color_controller(_id)


func _peer_disconnected(_id :int):
	print("=============disconnected peer id: %s"%_id)
