extends State

var actor: Character


func enter():
	if parent is not Character:
		push_warning("%s is not correct type (expected Character)", parent)
		return
	actor = parent

func physics_update(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var target_speed := direction * actor.move_speed
	var accel := actor.acceleration


	if direction == 0:
		target_speed = 0
		accel = actor.deceleration
	
	if abs(actor.velocity.x) < 0.01 and direction == 0:
		transition.emit("idle_state")

	actor.velocity.x = move_toward(
		actor.velocity.x,
		target_speed,
		accel * delta
		)

	actor.move_and_slide()
	
