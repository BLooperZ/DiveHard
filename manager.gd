extends Node

signal bubble_released(bubble)
signal players_released(bubble)

func detach_bubble(bubble):
	emit_signal("bubble_released", bubble)

func take_captured(bubble):
	emit_signal("players_released", bubble)
