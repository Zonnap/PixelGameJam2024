extends CharacterBody3D

@onready var navigation_agent_3d = $NavigationAgent3D

var speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var current_location = global_transform.origin;
	var next_location = navigation_agent_3d.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed;
	
	#Fish Movement
	velocity = new_velocity;
	move_and_slide()
	
func update_target_location(target_location):
	navigation_agent_3d.target_position = target_location
	#Detecting Bobber
	
	#
