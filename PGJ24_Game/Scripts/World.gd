extends Node3D

@onready var marker_3d = $Marker3D
@onready var player = $Player
@onready var spawners = $Cube/SpawnerContainer

var enemy_scene = preload("res://Scenes/EnemyPirate.tscn")

	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
		get_tree().call_group("Fish", "update_target_location", marker_3d.global_transform.origin)
		get_tree().call_group("enemies","update_target_location", player.global_transform.origin)


func _on_wave_timer_timeout():
	
	var enemy = enemy_scene.instantiate()
	enemy.position = get_node("Cube/SpawnerContainer/Spawner1",).position
	add_child(enemy)
