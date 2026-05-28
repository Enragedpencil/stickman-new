extends CharacterBody2D
class_name Character

@export var health: int
@export var move_speed: float = 100
@export var acceleration: float = 600
@export var deceleration: float = 350

var state_machines: Array[StateMachine]

func _ready():
	for child in get_children():
		if child is not StateMachine:
			continue
		state_machines.append(child)

func _unhandled_input(event):
	for fsm in state_machines:
		fsm.handle_input(event)

func _process(delta: float):
	for fsm in state_machines:
		fsm.process(delta)

func _physics_process(delta: float):
	for fsm in state_machines:
		fsm.process_physics(delta)
