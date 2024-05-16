@tool

extends Node3D

@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh : MeshInstance3D = %WeaponMesh
@onready var weapon_shadow : MeshInstance3D = %WeaponShadow
@onready var main_camera = $"../.."

var raycast_test = preload("res://Scenes/raycast_test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_weapon()
	
func _input(event):
	if event.is_action_pressed("Weapon1"):
		WEAPON_TYPE = load("res://Resources/Crowbar/Crowbar.tres")
		load_weapon()
	if event.is_action_pressed("Weapon2"):
		WEAPON_TYPE = load("res://Resources/Crowbar_Left/Crowbar2.tres")
		load_weapon()

func load_weapon() -> void:
	if WEAPON_TYPE != null:
		weapon_mesh.mesh = WEAPON_TYPE.mesh
		position = WEAPON_TYPE.position
		rotation_degrees = WEAPON_TYPE.rotation
		weapon_shadow.visible = WEAPON_TYPE.shadow
func attack() -> void:
	var space_state = main_camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = main_camera.project_ray_origin(screen_center)
	var end = origin + main_camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		_test_raycast(result.get("position"))
	
func _test_raycast(position: Vector3) -> void:
	var instance = raycast_test.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = position
	await get_tree().create_timer(3).timeout
	instance.queue_free()
