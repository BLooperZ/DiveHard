extends Node2D

@export var player_name = "0"
@onready var label: Label = $Label

func _ready() -> void:
	Manager.connect("score_changed", on_score_changed)
	

func on_score_changed(score_player_name):
		label.text = str(Manager.scores[player_name])
