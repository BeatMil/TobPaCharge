extends Node2D

#################################################
## Exports
#################################################
@export var position_group: Node2D

@export_group("Cosmetic Type")
@export var bowtie: bool
@export var gura_hair_clip: bool
@export var skull: bool


#################################################
## Node Ref
#################################################
@onready var sprite_player: AnimationPlayer = $SpritePlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wrap_sprite: Node2D = $Wrap
@onready var sprite: Sprite2D = $Wrap/Sprite


#################################################
## Built-In
#################################################
func _ready() -> void:
	if bowtie:
		sprite_player.play("bowtie")

	if gura_hair_clip:
		sprite_player.play("gura_hair_clip")

	if skull:
		sprite_player.play("skull")

	position_group = get_node("../BowtiePos")

#################################################
## Public function
#################################################
func set_pos_idle() -> void:
	position = position_group.get_node("idle").position
	sprite.rotation = position_group.get_node("idle").rotation
	animation_player.play("RESET")


func set_pos_charge() -> void:
	position = position_group.get_node("charge").position
	sprite.rotation = position_group.get_node("charge").rotation
	animation_player.play("RESET")


func set_pos_fireball() -> void:
	position = position_group.get_node("fireball").position
	sprite.rotation = position_group.get_node("fireball").rotation
	animation_player.play("RESET")


func set_pos_block() -> void:
	position = position_group.get_node("block").position
	sprite.rotation = position_group.get_node("block").rotation
	animation_player.play("block")


func set_pos_hitted() -> void:
	position = position_group.get_node("hitted").position
	sprite.rotation = position_group.get_node("hitted").rotation
	animation_player.play("hitted")


func set_pos_hitted_p1() -> void:
	position = position_group.get_node("hitted").position
	sprite.rotation = position_group.get_node("hitted").rotation
	animation_player.play("hitted_p1")


func set_pos_hitted_p2() -> void:
	position = position_group.get_node("hitted").position
	sprite.rotation = position_group.get_node("hitted").rotation
	animation_player.play("hitted_p2")
