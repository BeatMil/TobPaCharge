extends Control


func _on_button_pressed():
	SceneTransition.change_scene("res://scenes/battle.tscn")


func _on_create_lobby_button_pressed():
	SteamNetwork.create_lobby()
