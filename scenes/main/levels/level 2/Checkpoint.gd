extends Area2D

@export var player : CharacterBody2D
@export var spawnPoint: spawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.

func _on_body_entered(body):
	if body.is_in_group("Player"):
		spawnPoint.spawnPointVar = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
