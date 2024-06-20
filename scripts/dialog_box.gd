extends Control


#################################################
## Notifications
#################################################
func _ready():
	print(len($"RichTextLabel".text))
	$"RichTextLabel".visible_ratio = 0

	var tween = get_tree().create_tween()
	tween.tween_property($RichTextLabel, "visible_ratio", 1, len($"RichTextLabel".text)*0.01)
	# tween.tween_callback($RichTextLabel.queue_free)
	# tween.tween_callback($Sprite.queue_free)

