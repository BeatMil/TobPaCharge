extends Node2D

@onready var player1:Node2D = $"Player1"
@onready var player2:Node2D = $"Player2"


func _ready():
	# get players from steam lobby and assign them to character
	var lobby_size: int = SteamNetwork.lobby_members.size()
	if  lobby_size > 2:
		printerr("lobby member exceed limits")
	elif lobby_size == 2:
		player1.steam_id = SteamNetwork.lobby_members[0]
		player2.steam_id = SteamNetwork.lobby_members[1]
		print_rich("[color=orange][b]Game Start!!∑d(°∀°d)[/b][/color]")
	else:
		printerr("not enough players!")
		SceneTransition.change_scene("res://scenes/main_menu.tscn")

