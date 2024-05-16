@tool

extends Node3D

@export var WEAPON_TYPE: Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh : MeshInstance3D = %WeaponMesh
@onready var weapon_shadow : MeshInstance3D = %WeaponShadow

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

	
