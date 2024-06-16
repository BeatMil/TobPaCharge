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
	Steam.connect("join_requested", _on_join_requested)
	multiplayer.connect("peer_connected", _peer_connected)
	# multiplayer.connect("peer_disconnected", _peer_disconnected)

	_initialize_steam()

	print(get_tree().current_scene.name)


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
		multiplayer.multiplayer_peer = steam_multiplayer
		var now_scene = get_tree().current_scene
		if now_scene.name == "MainMenu":
			now_scene.update_lobby_members()
	else:
		printerr("Create or Join lobby failed")


# Trigger when accepct friend invite from steam
func _on_join_requested(_lobby_id: int, _steam_id: int):
	join_lobby(_lobby_id)


func _peer_connected(_id :int):
	print_rich("[color=Bisque ][b]%s has join![/b][/color]"%_id)
	var now_scene = get_tree().current_scene
	if now_scene.name == "MainMenu":
		now_scene.update_lobby_members()


func _peer_disconnected(_id :int):
	print_rich("[color=Bisque ][b]%s left[/b][/color]"%_id)
	var now_scene = get_tree().current_scene
	if now_scene.name == "MainMenu":
		now_scene.update_lobby_members()


#################################################
# public funcitons
#################################################

func create_lobby() -> int:
	var error = steam_multiplayer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_FRIENDS_ONLY, 4)
	if error:
		printerr("Create lobby failed")
	else:
		# multiplayer.multiplayer_peer = steam_multiplayer
		print_rich("[color=orange][b]SteamNetwork.create_lobby() ✓[/b][/color]")
	return error


func join_lobby(_lobby_id: int) -> int:
	var error = steam_multiplayer.connect_lobby(_lobby_id)
	if error:
		printerr("Join lobby failed")
	else:
		# multiplayer.multiplayer_peer = steam_multiplayer
		print_rich("[color=orange][b]SteamNetwork.join_lobby() ✓[/b][/color]")
	return error


func leave_lobby() -> void:
	if lobby_id != 0:
		print_rich("[color=red][b]Left lobby_id: %s[/b][/color]"%lobby_id)
		Steam.leaveLobby(lobby_id)
		steam_multiplayer.close()
		lobby_id = 0
	else:
		print("Not in a lobby")


@rpc("call_local")
func test_show_pic() -> void:
	print_rich("[img]res://media/TobPaCharge_icon.png[/img]")


func debug() -> void:
	print_rich("""[color=red][b]============================================================
= lobby_state: %s
=  debug_data: %s
============================================================[/b][/color]"""
	%[steam_multiplayer.get_state(),
	steam_multiplayer.collect_debug_data()
])
