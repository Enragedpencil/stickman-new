extends CharacterBody2D

@onready var ray: RayCast2D = $RayCast2D

#Player Movement Constants
const SPEED := 100.0
const JUMP_VELOCITY := -200.0
const ACCELERATION := 600.0
const FRICTION := 350.0
const AIR_ACCELERATION := 800.0
const AIR_FRICTION := 200.0

#Grapple Constants
const GRAPPLE_RANGE := 2000.0
const GRAPPLE_PULL_SPEED := 2000.0
const GRAPPLE_ACCELERATION := 2200.0
const STOP_DISTANCE := 32.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var grappling := false
var grapple_point := Vector2.ZERO


func _ready() -> void:
	ray.enabled = true
	ray.collide_with_areas = true
	ray.collide_with_bodies = true
	ray.exclude_parent = true


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement(delta)
	handle_jump()
	handle_grapple_input()

	if grappling:
		apply_grapple_pull(delta)

	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		var target_speed := direction * SPEED

		var accel := ACCELERATION
		if not is_on_floor():
			accel = AIR_ACCELERATION

		velocity.x = move_toward(
			velocity.x,
			target_speed,
			accel * delta
		)
	else:
		var friction := FRICTION
		if not is_on_floor():
			friction = AIR_FRICTION

		velocity.x = move_toward(
			velocity.x,
			0,
			friction * delta
		)


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func handle_grapple_input() -> void:
	if Input.is_action_just_pressed("grapple"):
		try_grapple()

	if Input.is_action_just_released("grapple"):
		grappling = false


func try_grapple() -> void:
	var direction := global_position.direction_to(get_global_mouse_position())

	ray.target_position = direction * GRAPPLE_RANGE
	ray.force_raycast_update()

	if ray.is_colliding():
		grapple_point = ray.get_collision_point()
		grappling = true


func apply_grapple_pull(delta: float) -> void:
	var direction := global_position.direction_to(grapple_point)
	var distance := global_position.distance_to(grapple_point)

	var desired_velocity := direction * GRAPPLE_PULL_SPEED
	velocity = velocity.move_toward(desired_velocity, GRAPPLE_ACCELERATION * delta)

	if distance < STOP_DISTANCE:
		grappling = false
