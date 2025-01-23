extends Node

signal bubble_released(bubble)
signal players_released(bubble)
signal end_game
signal score_changed(player_name)

var scores = {}

var ended = false

func reset_score(player):
	scores[player] = 0
	emit_signal("score_changed", player)

func detach_bubble(bubble):
	emit_signal("bubble_released", bubble)

func take_captured(bubble):
	emit_signal("players_released", bubble)

func add_score(player, score):
	scores[player] += score
	emit_signal("score_changed", player)

func call_end_game():
	ended = true
	emit_signal("end_game")
