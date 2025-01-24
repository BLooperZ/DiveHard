extends Area2D

const NUM_FULL_TANKS = 8
const BALLON_CAPACITY = 2048.0
const AIR_TRANSFER_SPEED = 300.0

@onready var left_air = BALLON_CAPACITY * NUM_FULL_TANKS
@onready var progress = $TextureProgressBar2
@onready var sprite: Sprite2D = $PaperBoat

@onready var t = 0.0

@onready var filling = 0

func _ready():
	progress.max_value = left_air
	left_air -= 2.5 * BALLON_CAPACITY
	progress.value = left_air

func _process(delta: float) -> void:
	t += delta
	position.y = 5 * sin(t)
	if filling > 0:
		scale = Vector2.ONE + max(0, 0.05 * sin(8 * t)) * Vector2.ONE
	#rotation = lerp(rotation, )

func get_air(delta, max_air):
	var air = min(delta * AIR_TRANSFER_SPEED, left_air, max_air)
	left_air -= air
	progress.value = left_air
	if left_air <= 0 and not Manager.ended:
		Manager.call_end_game()
	return air

func _on_body_entered(body):
	body.connect_ship(self)
	filling += 1

func _on_body_exited(body: Node2D) -> void:
	body.disconnect_ship(self)
	filling -= 1
