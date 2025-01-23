extends Area2D

# Allow enabling/disabling the boundary effect
@export var active: bool = true

func _ready():
	print("WaterLine reference:")

func _on_Area2D_body_entered(body):
	if not active:
		return

	# Handle diver restrictions
	if body.name == "Diver":
		# Prevent diver from moving above the waterline
		body.global_position.y = global_position.y
		print("Diver hit the waterline!")

	# Handle bubble bursting
	elif body.name == "Bubble":
		body.queue_free()  # Remove the bubble
		print("Bubble burst!")
