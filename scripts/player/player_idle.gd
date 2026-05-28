extends State

@export var MoveState: State
@export var JumpState: State

func handle_input(event: InputEvent):
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		transition.emit("move_state")
