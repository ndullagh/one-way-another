extends Area2D

@export var speed: float = 400  # Adjust as needed
@export var direction: Vector2 = Vector2.RIGHT  # Default direction
@onready var death_screen = $/root/Node2D/death_screen
@onready var textbox = $/root/Node2D/Textbox
@onready var explosion = $GPUParticles2D

func _process(delta):
	position += direction * speed * delta  # Move the projectile
	print(position)

func _on_body_entered(body):
	if body.is_in_group("enemy"):  # If it hits an enemy, destroy the enemy
		body.death_player.play()
		explosion.restart()
		explosion.emitting = true
		body.set_physics_process(false)
		body.can_shoot = false
		body.get_node("AnimatedSprite2D").hide()
		#await get_tree().create_timer(0.2).timeout  # Wait for explosion to finish
		body.queue_free()
	elif body.is_in_group("Player"):  # If it hits the player, trigger death
		body.die()
		death_screen.show_death_screen()
		textbox.text_queue = []
		textbox.hide_textbox()
		textbox.current_state = textbox.State.READY
	await get_tree().create_timer(0.2).timeout
	queue_free()  # Destroy the projectile

func freeze():
	speed = 0
	print("frozen")
	
func unfreeze():
	speed = 400
