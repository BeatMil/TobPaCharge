extends Node2D


var chosen_action = 0


func _ready():
	print_rich("[color=green][b]Hello world![/b][/color]")
	print_rich("[url]https://www.bbcode.org/[/url]")
	print_rich("[img]res://media/TobPaCharge_icon.png[/img]")
	print_rich("[img]res://media/TobPaCharge_icon.png[/img]")
	print_rich("[img]res://media/TobPaCharge_icon.png[/img]")

	pass


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
	elif chosen_action == ActionEnum.actions.BLOCK:
		$"AnimationPlayer".play("block")
	elif chosen_action == ActionEnum.actions.CHARGE:
		$"AnimationPlayer".play("charge")


func new_turn():
	random_action()
	$"AnimationPlayer".play("idle")


func _on_area_2d_body_entered(body):
	if body.is_in_group("fireball"):
		body.explode()
		$"AnimationPlayer".play("hitted")
