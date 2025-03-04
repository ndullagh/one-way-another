extends CharacterBody2D

@export var speed: float = 100  # Adjust movement speed
@onready var player = get_tree().get_first_node_in_group("player")
var previous_position: Vector2
var stuck_timer: float = 0.05
@export var stuck_threshold: float = 0.2  # Time before jumping when stuck
@export var jump_velocity: float = -500  # Adjust as needed
@export var jump_check_distance: float = 14.0  # Distance to check for walls

var can_shoot: bool = true
@export var shoot_cooldown: float = 0.9  # Time between shots in seconds

@export var projectile_scene: PackedScene
@onready var shoot_point = $ShootPoint

var direction: int = 0  # -1 for left, 1 for right
@export var gravity: float = 980  # Gravity strength (adjust as needed)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Move left or right toward the player
	if player:
		if player.global_position.x < global_position.x:
			direction = -1  # Move left
		else:
			direction = 1  # Move right

		velocity.x = direction * speed  # Continue normal movement

		# Move ShootPoint to the correct side of the enemy
		shoot_point.position.x = abs(shoot_point.position.x) if direction == 1 else -abs(shoot_point.position.x)

	# Check if the enemy is stuck against a wall
	if global_position.distance_to(previous_position) < 1.0 and is_on_floor():
		stuck_timer += delta
	else:
		stuck_timer = 0.1  # Reset timer if moving

	# If stuck for too long, jump
	if stuck_timer >= stuck_threshold:
		velocity.y = jump_velocity
		stuck_timer = 0.1  # Reset timer after jumping

	# Update previous position for next frame
	previous_position = global_position

	move_and_slide()


func _process(delta):
	if player:
		if abs(player.global_position.x - global_position.x) < 300:  # Enemy shoots when close
			shoot_projectile()

func shoot_projectile():
	if can_shoot and projectile_scene:
		can_shoot = false  # Prevent immediate shooting again
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = shoot_point.global_position

		# Set direction based on enemy facing direction
		var hitbox = projectile.get_node("Hitbox")
		if hitbox:
			hitbox.direction = Vector2.LEFT if direction == -1 else Vector2.RIGHT

		# Start cooldown timer
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true  # Allow shooting again
