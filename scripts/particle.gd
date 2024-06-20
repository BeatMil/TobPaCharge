extends Node2D


@export var time_before_queue_free: float = 0


func _ready():
	$Timer.wait_time = time_before_queue_free
	$Timer.start()
	$GPUParticles2D.emitting = true


func _on_timer_timeout():
	queue_free()
