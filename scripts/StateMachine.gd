extends Node
class_name StateMachine

@export var current_state: State

func _ready():

	# for child in get_children():

	# call enter on current state
	current_state.enter()


func _process(delta: float):
	current_state.update(delta)

func _physics_process(delta: float):
	current_state.physics_update(delta)
