extends Node


# Properties
var is_online: bool = false
var steam_id: int = 0
var steam_username: String = ""
var lobby_id: int = 0

# Configs
var appId: int = 480


#Steam Multiplayer thingy
var steam_multiplayer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func _ready():
	# Connect signals
	# Steam.connect("lobby_created", _on_lobby_created)
	Steam.connect("lobby_joined", _on_lobby_joined)
	# Steam.connect("join_requested", _on_join_requested)
	# multiplayer.connect("peer_connected", _peer_connected)
	# multiplayer.connect("peer_disconnected", _peer_disconnected)

	_initialize_steam()


func _process(_delta):
	pass
	# Steam.run_callbacks()


func _initialize_steam() -> void:
	if Engine.has_singleton("Steam"):
		OS.set_environment("SteamAppId", str(480))
		OS.set_environment("SteamGameId", str(480))

		var init_response: Dictionary = Steam.steamInit(false, appId, true)
		# If the status isn't one, print out the possible error and quit the program
		if init_response['status'] != 1:
			printerr("[STEAM] Failed to initialize: %s Shutting down..." %
			str(init_response['verbal']))
			get_tree().quit()

		# Acquire information about the user
		is_online = Steam.loggedOn()
		steam_id = Steam.getSteamID()
		steam_username = Steam.getPersonaName()

#################################################
# Call backs
#################################################

"""
This triggers with Steam."lobby_joined"
"""
func _on_lobby_joined(_lobby_id: int, _permissions: int, _locked: bool, _response: int) -> void:
	if _response == 1:
		lobby_id = _lobby_id
		print_rich("[color=purple][b]_on_lobby_joined!! lobby_id: %s[/b][/color]"%_lobby_id)
	else:
		printerr("Create or Join lobby failed")


func _peer_connected(_id :int):
	print("=============connected peer id: %s"%_id)


func _peer_disconnected(_id :int):
	print("=============disconnected peer id: %s"%_id)


#################################################
# public funcitons
#################################################

func create_lobby() -> int:
	var error = steam_multiplayer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_FRIENDS_ONLY, 4)
	if error:
		printerr("Create lobby failed")
	else:
		multiplayer.multiplayer_peer = steam_multiplayer
		print_rich("[color=orange][b]SteamNetwork.create_lobby() ✓[/b][/color]")
	return error


func join_lobby(_lobby_id: int) -> int:
	var error = steam_multiplayer.connect_lobby(_lobby_id)
	if error:
		printerr("Join lobby failed")
	else:
		multiplayer.multiplayer_peer = steam_multiplayer
		print_rich("[color=orange][b]SteamNetwork.join_lobby() ✓[/b][/color]")
	return error


func leave_lobby() -> void:
	if lobby_id != 0:
		print_rich("[color=red][b]lobby_id: %s[/b][/color]"%lobby_id)
		Steam.leaveLobby(lobby_id)
		steam_multiplayer.close()
		lobby_id = 0
	else:
		print("Not in a lobby")


func debug() -> void:
	print_rich("""[color=red][b]============================================================
= lobby_state: %s
=  debug_data: %s
============================================================[/b][/color]"""
	%[steam_multiplayer.get_state(),
	steam_multiplayer.collect_debug_data()
])
