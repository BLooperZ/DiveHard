extends CharacterBody2D

const SPEED = 50.0
const ROTATION_SPEED = 3.0
const SMOOTHNESS = 0.4
const DRAG = 0.97

const MIN_Y = 130
@onready var particles: CPUParticles2D = $CPUParticles2D

@onready var bubble = null
@onready var balloon = $SubA2
@onready var connected_ship = null

@onready var caught = false
@onready var sprite: Sprite2D = $SubA

@export var min_scale = 0.5

@export var UP = "p1_up"
@export var DOWN = "p1_down"
@export var LEFT = "p1_left"
@export var RIGHT = "p1_right"
@export var BLOW = "p1_blow"

var t

func _ready():
	balloon.value = balloon.max_value
	Manager.reset_score(name)
	t = randf() * 2 * PI

func _process(delta: float) -> void:
	t += delta
	sprite.position.y = 5 * sin(t)
	balloon.position.y = 5 * sin(t)

func _physics_process(delta: float) -> void:
	if caught:
		if bubble != null:
			bubble.queue_free()
			bubble = null
		position = lerp(position, Vector2(0.0, 0.0), 0.1)
		return

	if bubble != null and bubble.released:
		bubble = null

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector(LEFT, RIGHT, UP, DOWN)
	
	particles.lifetime = 0.4 + 0.3 * direction.length()
	particles.speed_scale = 1 + direction.length()

	var target_velocity = velocity + direction * SPEED
	velocity = lerp(velocity, target_velocity, SMOOTHNESS)
	velocity *= DRAG

	if velocity.y > 0:
		velocity.y *= DRAG

	# Rotate player to face movement direction
	if direction != Vector2.ZERO:
		var target_angle = direction.angle()
		rotation = lerp_angle(rotation, target_angle, ROTATION_SPEED * delta)
		particles.gravity = Vector2(-500, 100).rotated(rotation)
	if global_position.y < MIN_Y:
		velocity.y += 1200 * delta - 0.7 * min(0, direction.y * SPEED)
		#global_position.y = MIN_Y

	var collision = move_and_collide(velocity * delta)
	if collision:
		print(collision)
		var normal = collision.get_normal()
		if abs(normal.y) >= abs(normal.x):
			velocity = velocity.slide(normal)
		else:
			velocity = velocity.bounce(normal)
		#velocity = -velocity  # .slide(collision.get_normal())

	if connected_ship != null:
		var air_to_add = connected_ship.get_air(delta, balloon.max_value - balloon.value)
		balloon.value += air_to_add

	# Air management
	reduce_air(0.94 + direction.length(), delta)  # Normal air depletion

	if bubble != null:
		reduce_air(3, delta)  # Faster air depletion when bubble is active


func reduce_air(co, delta):
	balloon.value -= 32 * co * delta
	#var balloon_scale = 0.9 + 0.4 * (balloon.value / balloon.max_value)
	#balloon.scale = Vector2(0.7 * balloon_scale, 0.2 * balloon_scale)
	if balloon.value <= 0:
		die()
	#print(balloon.value)

func add_air(rate: float, delta: float):
	balloon.value = lerp(balloon.value, balloon.max_value, rate* delta)
	#var balloon_scale = 0.9 + 0.4 * (balloon.value / balloon.max_value)
	#balloon.scale = Vector2(0.7 * balloon_scale, 0.2 * balloon_scale)


func die():
	if bubble != null:
		bubble.queue_free()
		bubble = null
	var bubble_scene = load("res://Bubble.tscn")
	bubble = bubble_scene.instantiate()
	bubble.position = Vector2.ZERO
	add_child(bubble)
	pass

func _input(event: InputEvent) -> void:
	if bubble == null and event.is_action_pressed(BLOW):
		var bubble_scene = load("res://Bubble.tscn")
		bubble = bubble_scene.instantiate()
		add_child(bubble)
		bubble.creator = name
	if bubble != null and event.is_action_released(BLOW):
		bubble.release()
		bubble.velocity = 2 * velocity
		bubble = null

func connect_ship(ship):
	connected_ship = ship

func disconnect_ship(ship):
	if connected_ship == ship:
		connected_ship = null


func on_area_entered(area: Area2D) -> void:
	if not caught and area.xscale >= min_scale:
		var gpos = global_position
		area.capture()
		self.reparent(area.players)
		global_position = gpos
		caught = true
		if bubble != null:
			bubble.queue_free()
			bubble = null
