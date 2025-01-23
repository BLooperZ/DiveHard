extends Node



signal bubble_released(bubble)

func detach_bubble(bubble):
	emit_signal("bubble_released", bubble)
