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

	if skull:
		sprite_player.play("skull")
		if SteamNetwork.cosmetic_remember:
			for i in SteamNetwork.cosmetic_remember:
				if i == "skull":
					button.set_pressed_no_signal(true)

	if gura_hair_clip:
		sprite_player.play("gura_hair_clip")
		if SteamNetwork.cosmetic_remember:
			for i in SteamNetwork.cosmetic_remember:
				if i == "gura_hair_clip":
					button.set_pressed_no_signal(true)

#################################################
## Private Functions
#################################################
pass


#################################################
## Receive Signals
#################################################
func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if bowtie:
			SteamNetwork.cosmetic_remember.append("bowtie")

		if skull:
			SteamNetwork.cosmetic_remember.append("skull")

		if gura_hair_clip:
			SteamNetwork.cosmetic_remember.append("gura_hair_clip")
	else:
		if bowtie:
			for i in SteamNetwork.cosmetic_remember:
				if i == "bowtie":
					SteamNetwork.cosmetic_remember.erase(i)

		if skull:
			for i in SteamNetwork.cosmetic_remember:
				if i == "skull":
					SteamNetwork.cosmetic_remember.erase(i)

		if gura_hair_clip:
			for i in SteamNetwork.cosmetic_remember:
				if i == "gura_hair_clip":
					SteamNetwork.cosmetic_remember.erase(i)
