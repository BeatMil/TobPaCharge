extends Node2D

#################################################
## Exports
#################################################
@export var position_group: Node2D


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
	sprite_player.play("gura_hair_clip")


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
