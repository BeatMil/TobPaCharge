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
		print_rich("[color=purple][b]==_on_lobby_joined!![/b][/color]")
		print_rich("[color=purple][b]lobby_id: %s[/b][/color]"%_lobby_id)
	else:
		printerr("Create or Join lobby failed")


#################################################
# public funcitons
#################################################

func create_lobby() -> void:
	var error = steam_multiplayer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_FRIENDS_ONLY, 4)
	if error:
		printerr("Create lobby failed")
	multiplayer.multiplayer_peer = steam_multiplayer
	print_rich("[color=orange][b]SteamNetwork.create_lobby() ✓[/b][/color]")
