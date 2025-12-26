# Simple state machine for controlling player states.
# Handles switching between states and calling their update, physics, and input functions.
extends Node
class_name StateMachine

@export var initial_state: State  
var character: CharacterBody2D      
var current_state: State         
var previous_state: String = "" 
var states: Dictionary = {}      

func _ready():
	character = get_parent() as CharacterBody2D
	
	# Add all child nodes that are states into the dictionary
	# Uses lowercase names as keys for easy lookup
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self  # Let each state know which state machine controls it

func _process(delta):
	# Call the update function of the current state every frame
	if current_state:
		current_state.update(delta)
		

func _physics_process(delta):
	# Call the physics_update function of the current state every physics frame
	if current_state:
		current_state.physics_update(delta)

func _input(event):
	# Forward input events to the current state for handling
	if current_state:
		current_state.handle_input(event)

func change_state(state_name: String):
	if current_state:
		current_state.exit()
		previous_state = current_state.name.to_lower()
	
	current_state = states.get(state_name.to_lower()) 
	if current_state:
		current_state.enter() 
