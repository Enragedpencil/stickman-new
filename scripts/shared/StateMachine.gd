extends Node
class_name StateMachine

@export
var current_state: State
@export
var parent: Node

var states: Dictionary = {}


func _ready():
	if parent == null:
		parent = get_parent()
		push_warning("Parent not found. Defaulting to %s", parent)

	if current_state == null:
		push_error("State Machine (child of %s) is missing initial state")

	for child in get_children():
		#prevent our dumbasses from trying to give the FSM an invalid state
		if child is not State:
			push_warning(child, " is not a valid state.")
			continue

		# When a state calls transition state, the FSM will call transition_state func
		child.transition.connect(transition_state)
		#pass the (root) parent to child
		child.parent = parent
		# Add the child to our dictionary of States
		states[child.name.to_lower()] = child

	# call enter on current state
	current_state.enter()


func process(delta: float):
	current_state.update(delta)

func process_physics(delta: float):
	current_state.physics_update(delta)

func handle_input(event: InputEvent):
	current_state.handle_input(event)

func transition_state(next_state_name: String):
	var next_state: State = states.get(next_state_name.to_lower())

	if next_state == null:
		push_warning("Transition called on invalid state.")
		return
	
	if next_state == current_state:
		return

	current_state.exit()
	current_state = next_state
	current_state.enter()
