extends CharacterBody3D

#Player Nodes
@onready var head = $Neck/Head
@onready var crouching_collision_shape = $Crouching_CollisionShape
@onready var standing_collision_shape = $Standing_CollisionShape
@onready var ray_cast_3d = $RayCast3D
@onready var neck = $Neck
@onready var main_camera = $Neck/Head/Eyes/MainCamera
@onready var eyes = $Neck/Head/Eyes
@onready var animation_player = $Neck/Head/Eyes/AnimationPlayer


#Speed Variables
@export var current_speed = 5.0
@export var walking_speed = 5.0
@export var sprinting_speed = 8.0
@export var crouching_speed = 3.0
@export var mouse_sense = 0.4
const JUMP_VELOCITY = 4.5

#States
var walking = false;
var sprinting = false;
var crouching = false;
var Free_Looking = false;
var sliding = false;

#Slide Vars
var SlideTimer = 0.0;
var SlideTimerMax = 1.0;
var SlideVector = Vector2.ZERO;
var SlideSpeed = 14;

#Head Bobbing Vars
const head_bobbing_sprinting_speed = 22;
const head_bobbing_walking_speed = 14;
const head_bobbing_crouching_speed = 10;
const head_bobbing_crouching_intensity = 0.05;
const head_bobbing_sprinting_intensity = 0.20;
const head_bobbing_walking_intensity = 0.10;
var head_bobbing_current_intensity = 0.0;
var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0;

var last_velocity = Vector3.ZERO;
var air_lerp_speed = 3.0;
var lerp_speed = 8.0;
var direction = Vector3.ZERO;
var CrouchingDepth = -0.5;
var free_look_tilt_amount = 8;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		if Free_Looking:
			neck.rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
			head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
func _physics_process(delta):
	#Movement Input
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	#Crouching Logic
	if Input.is_action_pressed("crouch") || sliding:
		current_speed = lerp(current_speed,crouching_speed, delta*lerp_speed)
		head.position.y = lerp(head.position.y, CrouchingDepth, delta*lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
		#Sliding Logic Begin
		if sprinting && input_dir != Vector2.ZERO:
			sliding = true;
			SlideTimer = SlideTimerMax
			SlideVector = input_dir
			Free_Looking = true
		
		walking = false;
		sprinting = false;
		crouching = true;
		
	elif !ray_cast_3d.is_colliding():
	#Sprinting Logic
		head.position.y = lerp(head.position.y, 0.0, delta*lerp_speed);
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		if Input.is_action_pressed("sprint"):
			current_speed = lerp(current_speed,sprinting_speed, delta*lerp_speed)
			
			walking = false;
			sprinting = true;
			crouching = false;
		else:
			current_speed = lerp(current_speed,walking_speed, delta*lerp_speed)
			
			walking = true;
			sprinting = false;
			crouching = false;
	
	#Free Looking
	if Input.is_action_pressed("Free Look") || sliding:
		Free_Looking = true;
		eyes.rotation.z = -deg_to_rad(neck.rotation.y * free_look_tilt_amount)
		if sliding:
			eyes.rotation.z = lerp(eyes.rotation.z,-deg_to_rad(9.0),delta*lerp_speed)
		else:
			eyes.rotation.z = -deg_to_rad(neck.rotation.y * free_look_tilt_amount)
	else:
		Free_Looking = false;
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta*lerp_speed);
		eyes.rotation.z = lerp(eyes.rotation.z, 0.0, delta*lerp_speed);
		
	#Sliding Logic End
	if sliding:
		SlideTimer -= delta
		if SlideTimer <= 0:
			sliding = false
			Free_Looking = false;
			
	#Head Bobbing Logic - could use a library
	if sprinting:
		head_bobbing_current_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed * delta
	elif walking:
		head_bobbing_current_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed * delta
	elif crouching:
		head_bobbing_current_intensity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed * delta
		
	if is_on_floor() && !sliding && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2) + 0.5
		eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y * (head_bobbing_current_intensity / 2), delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.y * head_bobbing_current_intensity, delta*lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta*lerp_speed)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sliding = false
		animation_player.play("Jumping")
		
	#Handle Landing
	if is_on_floor():
		if last_velocity.y < -10.0:
			animation_player.play("Rolling")
		elif last_velocity.y < -4.0:
			animation_player.play("Landing")
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*air_lerp_speed)
	
	if sliding:
		direction = transform.basis * (Vector3(SlideVector.x, 0, SlideVector.y)).normalized()
		current_speed = (SlideTimer + 0.1) * SlideSpeed
		
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	last_velocity = velocity
	move_and_slide()
