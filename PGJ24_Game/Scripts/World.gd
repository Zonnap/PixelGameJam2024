extends Node3D

@onready var marker_3d = $Marker3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
		get_tree().call_group("Fish", "update_target_location", marker_3d.global_transform.origin)
