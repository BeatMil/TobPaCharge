extends AnimationPlayer


@onready var ost_player: AnimationPlayer = $"."


#################################################
# Public functions
#################################################
func play_battle_ost() -> void:
	if not ost_player.is_playing():
		print_rich("[color=orange][b]PLAYING OST battle!![/b][/color]")
		ost_player.play("battle_ost")


func stop_battle_ost() -> void:
	ost_player.stop()
