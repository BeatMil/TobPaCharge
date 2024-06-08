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
Preloads
"""
@onready var LOBBY_MEMBER_NODE = preload("res://nodes/lobby_member.tscn")

"""
Nodes
"""
@onready var lobby_id_label: RichTextLabel = $"LobbyIdLabel"
@onready var vbox_member: VBoxContainer = $"VBoxMember"
@onready var create_lobby_button: Button = $"CreateLobbyButton"
@onready var leave_lobby_button: Button = $"LeaveLobbyButton"
@onready var lobby_text_edit: TextEdit = $"LobbyIdTextEdit"



func _ready() -> void:
	# Steam.connect("avatar_loaded", _on_avatar_loaded)
	Steam.connect("lobby_created", _on_lobby_created)
	Steam.connect("lobby_joined", _on_lobby_joined)
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

#################################################
# CALLBACKS
#################################################

# # Avatar is ready for display
# func _on_avatar_loaded(id: int, avatar_size: int, buffer: PackedByteArray) -> void:
# 	print("Avatar for user: "+str(id)+", size: "+str(avatar_size))

# 	# Create the image and texture for loading
# 	var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size,
# 			false, Image.FORMAT_RGBA8, buffer)

# 	var avatar_texture : ImageTexture = ImageTexture.create_from_image(avatar_image)
# 	# Display it
# 	$"AvatarTexture".set_texture(avatar_texture)
# 	print("Avatar loaded ✓✓✓")


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
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, lobby_max_members)
	else:
		printerr("Lobby already created??")


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
		lobby_member.name = str(MEMBER_STEAM_ID)
		lobby_member.set_member(MEMBER_STEAM_ID, MEMBER_STEAM_NAME)
		vbox_member.add_child(lobby_member)

		# Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, MEMBER_STEAM_ID) nice?
		# # Add them to the player list
		# add_player_to_connect_list(MEMBER_STEAM_ID, MEMBER_STEAM_NAME)


func leave_lobby() -> void:
	if lobby_id != 0:
		# Reset lobby_id
		print("Left the lobby")
		lobby_id = 0
		Steam.leaveLobby(lobby_id)
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

"""
This trigger both when create or join lobby.
"""
func _on_lobby_joined(_lobby_id: int, _permissions: int, _locked: bool, _response: int) -> void:
	print("=====_on_lobby_joined=====")
	print("response: ", _response)
	if _response == 1:
		lobby_id = _lobby_id
		# Print the lobby ID to a label
		lobby_id_label.text = "Lobby ID: " + str(lobby_id)

		get_lobby_members()
	else:
		print("Create or Join lobby failed")


func _on_join_lobby_button_pressed():
	var lobby_id = int(lobby_text_edit.text)
	Steam.joinLobby(lobby_id)
