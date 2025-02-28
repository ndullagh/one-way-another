extends Camera2D

@export var player : NodePath

const SPEED: float = 250
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += delta * SPEED
	global_position.y = 252
	pass
