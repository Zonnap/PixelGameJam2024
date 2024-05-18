extends Node3D

@onready var player = $Player
@onready var spawner = $"Enemy Ship/SpawnerContainer"
@onready var start_timer = $StartTimer
@onready var wave_timer = $WaveTimer

var start_waves = false
var enemy_scene = preload("res://Scenes/EnemyPirate.tscn")

	
# Called when the node enters the scene tree for the first time.
func _ready():
	start_timer.start() #starts the Start timer when game starts :D
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	get_tree().call_group("enemies","update_target_location", player.global_transform.origin)

#waver timer timeout
func _on_wave_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = get_node("Enemy Ship/SpawnerContainer/Spawner1").position #set spawner position
	add_child(enemy) #add enemy

#Start timer timeout
func _on_start_timer_timeout():
		wave_timer.start() #start wave timer
