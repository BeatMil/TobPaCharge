extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var d: float = 0.0
@export var radius: float
@export var speed: float
@export var circle_size: float
@export var _position: Vector2



func _ready() -> void:
	scale = scale*circle_size
	animation_player.play("normal")


func _process(delta: float) -> void:
	d += delta

	position = Vector2(
		sin(d * speed) * radius,
		cos(d * speed) * radius
	) + _position
