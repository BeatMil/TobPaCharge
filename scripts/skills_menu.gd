extends Node2D


#############################################################
## Description
#############################################################
var double_fireball_description: String = \
"""
[color=Paleturquoise]Double Fireballs[/color]

Do a fireball [color=Khaki]twice![/color] (which means that it does 2 damages)
It [color=Lightcoral]beats a fireball.[/color] (the first one collide the second one hits)
It also [color=Lightcoral]beats heart charge[/color] because it deals 2 damage.
However, it [color=Lightcoral]can be blocked[/color] and [color=Lightcoral]cannot beats Big fireball.[/color]

[color=Indianred]Can only use[/color][color=Pink] once[/color] [color=Indianred]per round[/color]
"""

var heart_charge_description: String = \
"""
[color=Paleturquoise ]Heart Charge[/color]

Gain 1 hp
Activate at the [color=Lightcoral]start of animation.[/color]
[color=Lightblue](won't be killed by a fireball while using)[/color]

[color=Lightpink]Big fireball won't kill[/color] because it only does 1 damage

[color=Indianred]Can only use[/color][color=Pink] once[/color] [color=Indianred]per round[/color]
"""


#############################################################
## Nodes References
#############################################################
@onready var description_text: RichTextLabel = $DescriptionText
@onready var skill_buttons: Node2D = $SkillButtons
@onready var double_fireball_button: TextureButton = $SkillButtons/DoubleFireballButton
@onready var heart_charge_button: TextureButton = $SkillButtons/HeartChargeButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var lobby_member_to_show_skill: Control = null


func _on_texture_button_button_down() -> void:
	self.set_deferred("visible", false)


func _on_double_fireball_button_toggled(toggled_on: bool) -> void:
	description_text.text  = double_fireball_description
	_reset_button_except(false, "DoubleFireballButton")
	SteamNetwork.current_skill = SteamNetwork.skills.DOUBLE_FIREBALL
	if lobby_member_to_show_skill:
		if lobby_member_to_show_skill.rpc("show_double_fireball"): 
			# if error
			printerr("rpc show_skill double_fireball error!")
		print_rich("[color=pink]help![/color]")


func _on_texture_button_toggled(toggled_on: bool) -> void:
	description_text.text  = heart_charge_description
	_reset_button_except(false, "HeartChargeButton")
	SteamNetwork.current_skill = SteamNetwork.skills.HEART_CHARGE
	if lobby_member_to_show_skill:
		if lobby_member_to_show_skill.rpc("show_heart_charge"): 
			# if error
			printerr("rpc show_skill heart_charge error!")


#################################################
## private functions
#################################################
func _reset_button_except(_value: bool, _name: String) -> void:
	for node in skill_buttons.get_children():
		if node.name != _name:
			node.set_pressed_no_signal(false)
			node.set_block_touch(false)


#################################################
## public functions
#################################################
func open() -> void:
	visible = true
	animation_player.play("open_sfx")
