extends Area2D

const NUM_FULL_TANKS = 8
const BALLON_CAPACITY = 2048.0
const AIR_TRANSFER_SPEED = 300.0

@onready var left_air = BALLON_CAPACITY * NUM_FULL_TANKS
@onready var progress = $TextureProgressBar

#@onready var divers = []

func _ready():
	progress.max_value = left_air
	progress.value = left_air

func get_air(delta, max_air):
	print(delta, max_air)
	var air = min(delta * AIR_TRANSFER_SPEED, left_air, max_air)
	left_air -= air
	progress.value = left_air
	return air

func _on_body_entered(body):
	if body.name == "Diver":
		body.connect_ship(self)
		#body.add_air(50, 0.016)  ### 0.016 is delta substitute for 60fps
		#print ("adding air")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Diver":
		body.disconnect_ship(self)
