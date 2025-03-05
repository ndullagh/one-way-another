extends TileMapLayer

var speed: float = 250
@export var topLimit: float = 650
@export var botLimit: float = -200
@export var startingY: float = 0
@export var startUp: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.y = startingY
	if (startUp):
		speed = speed * -1
	
	set_process(true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y += delta * speed
	
	if (global_position.y <= botLimit):
		speed = 250
	if (global_position.y >= topLimit):
		speed = -250
	
	pass
