extends CharacterBody2D

@export var speed: float = 100  # Adjust movement speed
@onready var player = get_tree().get_first_node_in_group("Player")
var previous_position: Vector2
var stuck_timer: float = 0.05
@export var stuck_threshold: float = 0.2  # Time before jumping when stuck
@export var jump_velocity: float = -500  # Adjust as needed
@export var jump_check_distance: float = 14.0  # Distance to check for walls

@onready var footstep_player = $FootstepPlayer
@onready var jump_player = $JumpPlayer
@onready var shoot_player = $ShootPlayer
@onready var death_player = $DeathPlayer
var step_timer = 0.0
var step_interval = 0.38


@onready var death_screen = $/root/Node2D/death_screen
@onready var textbox = $/root/Node2D/Textbox

var can_shoot: bool = true
@export var shoot_cooldown: float = 2 # Time between shots in seconds

@export var projectile_scene: PackedScene
@onready var shoot_point = $ShootPoint

@onready var sprite = $AnimatedSprite2D
@onready var gunparticles = $ShootPoint/GunParticles

var direction: int = 0  # -1 for left, 1 for right
@export var gravity: float = 980  # Gravity strength (adjust as needed)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y >= 0:
			sprite.play("fall")
	elif velocity.x != 0:
		sprite.play("walk")
		step_timer -= delta
		if step_timer <= 0:
			footstep_player.pitch_scale = randf_range(0.9, 1.1) # Random pitch between 0.9 and 1.1
			footstep_player.play()
			step_timer = step_interval
	else:
		sprite.play("default")

	# Move left or right toward the player
	if player:
		if player.global_position.x < global_position.x and sqrt(pow(abs(player.global_position.x - global_position.x), 2) + pow(abs(player.global_position.y - global_position.y), 2)) < 800:
			direction = -1  # Move left
			sprite.flip_h = false
		elif sqrt(pow(abs(player.global_position.x - global_position.x), 2) + pow(abs(player.global_position.y - global_position.y), 2)) < 800:
			direction = 1  # Move right
			sprite.flip_h = true

		velocity.x = direction * speed  # Continue normal movement

		# Move ShootPoint to the correct side of the enemy
		shoot_point.position.x = abs(shoot_point.position.x) if direction == 1 else -abs(shoot_point.position.x)

	# Check if the enemy is stuck against a wall
	if global_position.distance_to(previous_position) < 1.0 and is_on_floor():
		stuck_timer += delta
	else:
		stuck_timer = 0.1  # Reset timer if moving

	# If stuck for too long, jump
	if stuck_timer >= stuck_threshold and abs(player.global_position.x - global_position.x) < 800:
		velocity.y = jump_velocity
		sprite.animation = "jump"
		stuck_timer = 0.1  # Reset timer after jumping
		jump_player.play()
		footstep_player.play()
		

	# Update previous position for next frame
	previous_position = global_position

	move_and_slide()


func _process(delta):
	if player:
		if sqrt(pow(abs(player.global_position.x - global_position.x), 2) + pow(abs(player.global_position.y - global_position.y), 2)) < 500:  # Enemy shoots when close
			shoot_projectile()

func shoot_projectile():
	if can_shoot and projectile_scene and textbox.textbox_hidden == true:
		can_shoot = false  # Prevent immediate shooting again
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = shoot_point.global_position
		gunparticles.restart()
		shoot_player.pitch_scale = randf_range(0.9, 1.1) # Random pitch between 0.9 and 1.1
		shoot_player.play()
		

		# Set direction based on enemy facing direction
		var hitbox = projectile.get_node("Hitbox")
		if hitbox:
			hitbox.direction = Vector2.LEFT if direction == -1 else Vector2.RIGHT
			projectile.get_node("Hitbox/AnimatedSprite2D").flip_h = direction == -1
			gunparticles.process_material.direction = Vector3(direction, 0, 0)  # Example: Emit to the right
			gunparticles.emitting = true

		# Start cooldown timer
		var timer = get_tree().create_timer(shoot_cooldown)
		await timer.timeout
		can_shoot = true  # Allow shooting again
		
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # If the enemy collides with the player
		death_screen.show_death_screen()
		body.die()  # Call the player's death function
		
