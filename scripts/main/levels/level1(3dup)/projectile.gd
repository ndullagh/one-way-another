extends Area2D

@export var speed: float = 400  # Adjust as needed
@export var direction: Vector2 = Vector2.RIGHT  # Default direction

func _process(delta):
	position += direction * speed * delta  # Move the projectile

func _on_body_entered(body):
	if body.is_in_group("enemy"):  # Check if collided with an enemy
		body.queue_free()  # Destroy the enemy
	queue_free()  # Destroy the projectile
