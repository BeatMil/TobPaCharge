extends Node2D


#################################################
## Exports
#################################################
@export_group("Cosmetic Type")
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
					_add_bowtie_to_steam_network(false)

	if skull:
		sprite_player.play("skull")
		if SteamNetwork.cosmetic_remember:
			for i in SteamNetwork.cosmetic_remember:
				if i == "skull":
					button.set_pressed_no_signal(true)
					_add_skull_to_steam_network(false)

	# if gura_hair_clip:
	# 	sprite_player.play("gura_hair_clip")
	# 	if SteamNetwork.cosmetics_nodes:
	# 		for i in SteamNetwork.cosmetics_nodes:
	# 			if i.name == "gura_hair_clip":
	# 				button.set_pressed_no_signal(true)

#################################################
## Private Functions
#################################################
func _add_bowtie_to_steam_network(_remember: bool) -> void:
	var bowtie_cos = BOWTIE_TYPE.instantiate()
	bowtie_cos.name = "bowtie"
	bowtie_cos.bowtie = true
	SteamNetwork.cosmetics_nodes.append(bowtie_cos)
	if _remember:
		SteamNetwork.cosmetic_remember.append("bowtie")


func _add_skull_to_steam_network(_remember: bool) -> void:
	print_rich("[color=Lightblue]SKULL[/color]")
	var skull_cos = BOWTIE_TYPE.instantiate()
	skull_cos.name = "skull"
	skull_cos.skull = true
	SteamNetwork.cosmetics_nodes.append(skull_cos)
	if _remember:
		SteamNetwork.cosmetic_remember.append("skull")


#################################################
## Receive Signals
#################################################
func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if bowtie:
			_add_bowtie_to_steam_network(true)

		if skull:
			_add_skull_to_steam_network(true)
	else:
		if bowtie:
			for i in SteamNetwork.cosmetics_nodes:
				if i.name == "bowtie":
					SteamNetwork.cosmetics_nodes.erase(i)
			for i in SteamNetwork.cosmetic_remember:
				if i == "bowtie":
					SteamNetwork.cosmetic_remember.erase(i)

		if skull:
			for i in SteamNetwork.cosmetics_nodes:
				if i.name == "skull":
					SteamNetwork.cosmetics_nodes.erase(i)
			for i in SteamNetwork.cosmetic_remember:
				if i == "skull":
					SteamNetwork.cosmetic_remember.erase(i)

