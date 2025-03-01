extends Camera2D

@export var player : CharacterBody2D

var speed: float = 250
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += delta * speed
	global_position.y = 252
	
	if (player != null):
		if (!player.visible):
			speed = 0
		
	pass
