extends Node2D


#################################################
## Exports
#################################################
@export_group("Cosmetic Bowtie Type")
@export var bowtie: bool
@export var gura_hair_clip: bool
@export var skull: bool


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


#################################################
## Built-In
#################################################
func _ready() -> void:
	if bowtie:
		sprite_player.play("bowtie")
		if SteamNetwork.cosmetic_remember:
			for i in SteamNetwork.cosmetic_remember:
				if i == "bowtie":
					button.set_pressed_no_signal(true)
					_show_cosmetic_bowtie_both_players()

	if skull:
		sprite_player.play("skull")
		if SteamNetwork.cosmetic_remember:
			for i in SteamNetwork.cosmetic_remember:
				if i == "skull":
					button.set_pressed_no_signal(true)
					_show_cosmetic_skull_both_players()

	if gura_hair_clip:
		sprite_player.play("gura_hair_clip")
		if SteamNetwork.cosmetic_remember:
			for i in SteamNetwork.cosmetic_remember:
				if i == "gura_hair_clip":
					button.set_pressed_no_signal(true)
					_show_cosmetic_gura_hair_clip_both_players()


#################################################
## Private Functions
#################################################
func _show_cosmetic_bowtie_both_players() -> void:
	var _bowtieP1 = BOWTIE_TYPE.instantiate()
	_bowtieP1.bowtie = true
	_bowtieP1.name = "bowtieP1"
	_bowtieP1.position = $"../P1Pos/BowtiePos".position
	$"../DisplayCosmetic".add_child(_bowtieP1)
	var _bowtieP2 = BOWTIE_TYPE.instantiate()
	_bowtieP2.bowtie = true
	_bowtieP2.name = "bowtieP2"
	_bowtieP2.position = $"../P2Pos/BowtiePos".position
	$"../DisplayCosmetic".add_child(_bowtieP2)


func _show_cosmetic_skull_both_players() -> void:
	var _bowtieP1 = BOWTIE_TYPE.instantiate()
	_bowtieP1.skull = true
	_bowtieP1.name = "skullP1"
	_bowtieP1.position = $"../P1Pos/BowtiePos".position
	$"../DisplayCosmetic".add_child(_bowtieP1)
	var _bowtieP2 = BOWTIE_TYPE.instantiate()
	_bowtieP2.skull = true
	_bowtieP2.name = "skullP2"
	_bowtieP2.position = $"../P2Pos/BowtiePos".position
	$"../DisplayCosmetic".add_child(_bowtieP2)


func _show_cosmetic_gura_hair_clip_both_players() -> void:
	var _bowtieP1 = BOWTIE_TYPE.instantiate()
	_bowtieP1.gura_hair_clip = true
	_bowtieP1.name = "guraHairClipP1"
	_bowtieP1.position = $"../P1Pos/BowtiePos".position
	$"../DisplayCosmetic".add_child(_bowtieP1)
	var _bowtieP2 = BOWTIE_TYPE.instantiate()
	_bowtieP2.gura_hair_clip = true
	_bowtieP2.name = "guraHairClipP2"
	_bowtieP2.position = $"../P2Pos/BowtiePos".position
	$"../DisplayCosmetic".add_child(_bowtieP2)


#################################################
## Receive Signals
#################################################
func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if bowtie:
			SteamNetwork.cosmetic_remember.append("bowtie")
			_show_cosmetic_bowtie_both_players()
		if skull:
			SteamNetwork.cosmetic_remember.append("skull")
			_show_cosmetic_skull_both_players()
		if gura_hair_clip:
			SteamNetwork.cosmetic_remember.append("gura_hair_clip")
			_show_cosmetic_gura_hair_clip_both_players()
	else:
		if bowtie:
			for i in SteamNetwork.cosmetic_remember:
				if i == "bowtie":
					SteamNetwork.cosmetic_remember.erase(i)
			for node in $"../DisplayCosmetic".get_children():
				if "bowtie" in node.name:
					node.queue_free()

		if skull:
			for i in SteamNetwork.cosmetic_remember:
				if i == "skull":
					SteamNetwork.cosmetic_remember.erase(i)
			for node in $"../DisplayCosmetic".get_children():
				if "skull" in node.name:
					node.queue_free()

		if gura_hair_clip:
			for i in SteamNetwork.cosmetic_remember:
				if i == "gura":
					SteamNetwork.cosmetic_remember.erase(i)
			for node in $"../DisplayCosmetic".get_children():
				if "gura" in node.name:
					node.queue_free()
