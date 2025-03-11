extends Area2D

@onready var defaultSprite : Sprite2D = $DefaultSprite
@onready var activatedSprite : Sprite2D = $ActivateSprite

@export var player : CharacterBody2D
@export var spawnPoint: spawnPoint
var activated : bool = false 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	activatedSprite.hide()
	pass # Replace with function body.

func _on_body_entered(body):
	if body.is_in_group("Player"):
		spawnPoint.spawnPointVar = global_position
		defaultSprite.hide()
		activatedSprite.show()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
