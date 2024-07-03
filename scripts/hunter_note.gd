extends Node2D

#############################################################
## Description
#############################################################
var how_to_play_description: String = \
"""
[color=Paleturquoise ]Explanation[/color]

This is a 2 player [color=Burlywood]turn-based[/color] game but both players perform their action at the [color=Burlywood]same time[/color]!
"""
var actions_description: String = \
"""
[color=Paleturquoise ]Actions[/color]

[color=Chocolate]Fireball[/color]: This does damage. If this hit opponent, it kills.
[color=Lightseagreen]Block[/color]: This negate any incoming damage except [color=red]big fireball[/color].
[color=Papayawhip ]Charge[/color]: Player will automatically perform charge if nothing is choosed
[color=Red ]Big Fireball[/color]: This requires [color=Salmon]3 charges[/color]. Once 3 charges the big fireball button will appear.
"""


#############################################################
## Nodes References
#############################################################
@onready var description_text: RichTextLabel = $DescriptionText


#############################################################
## Built-in
#############################################################
func _ready() -> void:
	set_deferred("visible", false)


#############################################################
## Receive signals
#############################################################
func _on_how_to_play_button_on_press() -> void:
	description_text.text = how_to_play_description


func _on_skills_button_on_press() -> void:
	description_text.text = actions_description


func _on_texture_button_button_down() -> void:
	set_deferred("visible", false)
