extends Node2D

@export var speed: float = 200
@export var counterClockwise: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (counterClockwise):
		speed = speed * -1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_rotation_degrees += speed * delta
	pass
