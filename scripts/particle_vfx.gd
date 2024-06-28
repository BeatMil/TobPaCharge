extends Node2D

@export var time_before_queue_free: float = 0
var current_time: float = 0
@onready var gpu_particles_2d = $GPUParticles2D

func _ready():
	$GPUParticles2D.emitting = true


func _process(delta):
	if current_time >= time_before_queue_free:
		queue_free()
	current_time += delta
