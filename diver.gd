extends CharacterBody2D

const SPEED = 50.0
const ROTATION_SPEED = 3.0
const SMOOTHNESS = 0.4
const DRAG = 0.97

@onready var bubble = null
@onready var balloon = $Ballon
@onready var connected_ship = null


func _ready():
	balloon.value = balloon.max_value

func _physics_process(delta: float) -> void:
	if bubble != null and bubble.released:
		bubble = null

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var target_velocity = velocity + direction * SPEED
	velocity = lerp(velocity, target_velocity, SMOOTHNESS)
	velocity *= DRAG

	if velocity.y > 0:
		velocity.y *= DRAG

	# Rotate player to face movement direction
	if direction != Vector2.ZERO:
		var target_angle = direction.angle()
		rotation = lerp_angle(rotation, target_angle, ROTATION_SPEED * delta)

	move_and_slide()

	if connected_ship != null:
		var air_to_add = connected_ship.get_air(delta, balloon.max_value - balloon.value)
		print("AIR_TO_ADD" + str(air_to_add))
		balloon.value += air_to_add

	# Air management
	reduce_air(1, delta)  # Normal air depletion

	if bubble != null:
		reduce_air(3, delta)  # Faster air depletion when bubble is active

func reduce_air(co, delta):
	balloon.value -= 32 * co * delta
	var balloon_scale = 0.9 + 0.4 * (balloon.value / balloon.max_value)
	balloon.scale = Vector2(0.7 * balloon_scale, 0.2 * balloon_scale)
	if balloon.value <= 0:
		die()
	#print(balloon.value)

func add_air(rate: float, delta: float):
	balloon.value = lerp(balloon.value, balloon.max_value, rate* delta)
	var balloon_scale = 0.9 + 0.4 * (balloon.value / balloon.max_value)
	balloon.scale = Vector2(0.7 * balloon_scale, 0.2 * balloon_scale)


func die():
	pass

func _input(event: InputEvent) -> void:
	if bubble == null and event.is_action_pressed("ui_accept"):
		var bubble_scene = load("res://Bubble.tscn")
		bubble = bubble_scene.instantiate()
		add_child(bubble)
	if bubble != null and event.is_action_released("ui_accept"):
		bubble.release()
		bubble.velocity = 2 * velocity
		bubble = null

func connect_ship(ship):
	connected_ship = ship

func disconnect_ship(ship):
	if connected_ship == ship:
		connected_ship = null
