extends Node2D


#################################################
## Exports
#################################################
@export_enum("bowtie", "gura_hair_clip", "skull") var bowtie_type: String
@export_enum(
	"blue",
	"green",
	"pink",
	"purple",
	"red",
	"yellow",
) var color: String


#################################################
## Preloads
#################################################
const BOWTIE_TYPE = preload("res://nodes/cosmetics/bowtie_type.tscn")


#################################################
## Node Ref
#################################################
@onready var sprite_player: AnimationPlayer = $SpritePlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button: Button = $Button
@onready var color_player: AnimationPlayer = $ColorPlayer


#################################################
## Built-In
#################################################
func _ready() -> void:
	color_player.play(color)

	if _is_in_inventory():
		button.disabled = false
	else:
		button.disabled = true

	sprite_player.play(bowtie_type)
	if SteamNetwork.cosmetic_remember:
		for i in SteamNetwork.cosmetic_remember:
			if i.type == bowtie_type and i.color == color:
				button.set_pressed_no_signal(true)
				_show_cosmetic_both_players()


#################################################
## Private Functions
#################################################
func _show_cosmetic_both_players() -> void:
	var _bowtieP1 = BOWTIE_TYPE.instantiate()
	_bowtieP1.bowtie_type = bowtie_type
	_bowtieP1.name = "%sP1"%bowtie_type
	_bowtieP1.position = $"../P1Pos/BowtiePos".position
	_bowtieP1.color = color
	$"../DisplayCosmetic".add_child(_bowtieP1)

	var _bowtieP2 = BOWTIE_TYPE.instantiate()
	_bowtieP2.bowtie_type = bowtie_type
	_bowtieP2.name = "%sP2"%bowtie_type
	_bowtieP2.position = $"../P2Pos/BowtiePos".position
	_bowtieP2.color = color
	$"../DisplayCosmetic".add_child(_bowtieP2)


func _is_in_inventory() -> bool:
	# Check if current item is in inventory by bowtie_type and color
	if Data.inventory["%s_%s"%[bowtie_type, color]]:
		return true
	else:
		return false


#################################################
## Receive Signals
#################################################
func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		var cos_dict_data = {}
		cos_dict_data["type"] = bowtie_type
		cos_dict_data["color"] = color
		SteamNetwork.cosmetic_remember.append(cos_dict_data)
		_show_cosmetic_both_players()
	else:
		for i in SteamNetwork.cosmetic_remember:
			if i.type == bowtie_type and i.color == color:
				SteamNetwork.cosmetic_remember.erase(i)
		for node in $"../DisplayCosmetic".get_children():
			if bowtie_type in node.name:
				node.queue_free()
