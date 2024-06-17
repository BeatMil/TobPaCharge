extends Node2D

# Preloads
var FIREBALL = preload("res://nodes/fireball.tscn")


# properties
var charge_count: int = 0
var steam_id: int = 0


# Configs
var chosen_action = ActionEnum.actions.CHARGE
var hp = 1


func _ready():
	if steam_id != SteamNetwork.steam_id:
		$CanvasLayer.visible = false
	print_rich("[color=Deeppink][b]steam_id: %s, actual_steam_id: %s[/b][/color]"%
	[steam_id, SteamNetwork.steam_id])
	# print_rich("[color=green][b]Nyaaa > w <[/b][/color]")
	# print_rich("[img]res://media/TobPaCharge_icon.png[/img]")


func random_action():
	# I don't know how this line work but that's fine XD
	## Edited: ohhhh my god that's genius! XD
	# chosen_action = randi() % ActionEnum.actions.size()
	chosen_action = ActionEnum.actions.CHARGE


func resolve_phase():
	# Update action Label
	$"Label".text = ActionEnum.actions.keys()[chosen_action]

	# Update animation
	if chosen_action == ActionEnum.actions.FIREBALL:
		$"AnimationPlayer".play("fireball")
		spawn_fireball()
	elif chosen_action == ActionEnum.actions.BLOCK:
		$"AnimationPlayer".play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		$"AnimationPlayer".play("charge")
		charge_count += 1


func spawn_fireball():
	if charge_count:
		charge_count -= 1
		var fireball = FIREBALL.instantiate()
		fireball.position = $"FireBallSpawnPos".position
		fireball.is_going_right_side = false
		fireball.set_target("p1")
		add_child(fireball)


func new_turn():
	random_action()
	$"AnimationPlayer".play("idle")


func _on_area_2d_body_entered(body):
	if body.is_in_group("fireball"):
		if chosen_action in [ActionEnum.actions.CHARGE, ActionEnum.actions.CHARGE]:
			$"AnimationPlayer".play("hitted")
			hp -= 1
