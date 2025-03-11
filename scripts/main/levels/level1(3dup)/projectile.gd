extends Area2D

@export var speed: float = 400  # Adjust as needed
@export var direction: Vector2 = Vector2.RIGHT  # Default direction
@onready var death_screen = $/root/Node2D/death_screen
@onready var textbox = $/root/Node2D/Textbox

func _process(delta):
	position += direction * speed * delta  # Move the projectile

func _on_body_entered(body):
	if body.is_in_group("enemy"):  # If it hits an enemy, destroy the enemy
		body.queue_free()
	elif body.is_in_group("player"):  # If it hits the player, trigger death
		body.die()
		death_screen.show_death_screen()
		textbox.text_queue = []
		textbox.hide_textbox()
		textbox.current_state = textbox.State.READY
	queue_free()  # Destroy the projectile
