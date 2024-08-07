extends Node2D

#################################################
## Exports
#################################################
@export var position_group: Node2D

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
## Node Ref
#################################################
@onready var sprite_player: AnimationPlayer = $SpritePlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wrap_sprite: Node2D = $Wrap
@onready var sprite: Sprite2D = $Wrap/Sprite
@onready var color_player: AnimationPlayer = $ColorPlayer


#################################################
## Built-In
#################################################
func _ready() -> void:
	# sprite
	sprite_player.play(bowtie_type)

	# color
	color_player.play(color)

	if get_node_or_null("../BowtiePos"):
		position_group = get_node("../BowtiePos")

	set_pos_idle()

#################################################
## Public function
#################################################
func set_pos_idle() -> void:
	if position_group:
		position = position_group.get_node("idle").position
		sprite.rotation = position_group.get_node("idle").rotation
		animation_player.play("RESET")


func set_pos_charge() -> void:
	if position_group:
		position = position_group.get_node("charge").position
		sprite.rotation = position_group.get_node("charge").rotation
		animation_player.play("RESET")


func set_pos_fireball() -> void:
	if position_group:
		position = position_group.get_node("fireball").position
		sprite.rotation = position_group.get_node("fireball").rotation
		animation_player.play("RESET")


func set_pos_block() -> void:
	if position_group:
		position = position_group.get_node("block").position
		sprite.rotation = position_group.get_node("block").rotation
		animation_player.play("block")


func set_pos_hitted() -> void:
	if position_group:
		position = position_group.get_node("hitted").position
		sprite.rotation = position_group.get_node("hitted").rotation
		animation_player.play("hitted")


func set_pos_hitted_p1() -> void:
	if position_group:
		position = position_group.get_node("hitted").position
		sprite.rotation = position_group.get_node("hitted").rotation
		animation_player.play("hitted_p1")


func set_pos_hitted_p2() -> void:
	if position_group:
		position = position_group.get_node("hitted").position
		sprite.rotation = position_group.get_node("hitted").rotation
		animation_player.play("hitted_p2")
