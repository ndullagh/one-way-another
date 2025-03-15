extends CharacterBody2D

#Script for controlling the player character.
#right now in the scene tree the player character exists only within level 3. This may need to change in some way.
#this may mean adding a "player" to each scene, or somehow making the player universal. I'm not sure of the details.
@export var projectile_scene: PackedScene  # Reference to the projectile scene
@export var spawnPoint: spawnPoint
@onready var shoot_position = $ShootPoint  # Position from where bullets spawn

@onready var camera = $Camera2D


@onready var sprite = $AnimatedSprite2D  # Make sure this matches your node's path
@onready var gun_sprite = $AnimatedSprite2D2
@onready var death_screen = $/root/Node2D/death_screen

@onready var run_dust = $GPUParticles2D
@onready var footstep_player = $FootstepPlayer
@onready var jump_player = $JumpPlayer
@onready var shoot_player = $ShootPlayer
@onready var death_player = $DeathPlayer

@export var coyote_time: float = 0.1  # time allowed to jump after falling

@export var ACCELERATION: float = 5000 # how fast you reach max speed
@export var FRICTION: float = 6000  # How fast you slow down

var coyote_timer: float = 0.0

const SPEED = 600.0
const JUMP_VELOCITY = -1000

var max_jumps = 1

var jumps_left = max_jumps

var facing_right = true  # track player's facing direction

var shoot_cooldown = .4
var can_shoot = true
var animation_locked = false

var step_timer = 0.0
var step_interval = 0.4

func _ready():
	gun_sprite.animation_finished.connect(_on_animation_finished)
	sprite.animation_finished.connect(_on_shoot_animation_finished)
	if (spawnPoint.spawnPointVar):
		global_position = spawnPoint.spawnPointVar

func _on_shoot_animation_finished():
	if sprite.animation == "shoot" or sprite.animation == "shoot_left" or sprite.animation == "jump_shoot_right" or sprite.animation == "jump_shoot_left":  # Only unlock if it was the shoot animation
		animation_locked = false  

func _on_animation_finished():
	if gun_sprite.animation == "default":
		gun_sprite.animation = "hidden"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta  # countdown when in the air
	else:
		jumps_left = max_jumps  # reset jumps when touching the ground
		coyote_timer = coyote_time

	# handle jump
	if Input.is_action_just_pressed("jump") and jumps_left > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left = jumps_left - 1
		coyote_timer = 0
		jump_player.pitch_scale = randf_range(0.9, 1.1) # Random pitch between 0.9 and 1.1
		print("playing")
		jump_player.play()
		# restart jump animation
		if sprite.animation in ["run_right", "idle_right", "fall_right", "jump_right"]:
			sprite.play("jump_right")
			sprite.frame = 0  # force restart animation
		elif sprite.animation in ["run_left", "idle_left", "fall_left", "jump_left"]:
			sprite.play("jump_left")
			sprite.frame = 0  # Force restart animation

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		# apply acceleration towards max speed
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		if direction > 0:
			facing_right = true
			shoot_position.position.x = abs(shoot_position.position.x)  # Ensure it's on the right
		elif direction < 0:
			facing_right = false
			shoot_position.position.x = -abs(shoot_position.position.x)  # Move it to the left
		if is_on_floor():
			run_dust.process_material.direction.x = -direction
			run_dust.emitting = true
			step_timer -= delta
			if step_timer <= 0:
				footstep_player.pitch_scale = randf_range(0.9, 1.1) # Random pitch between 0.9 and 1.1
				footstep_player.play()
				step_timer = step_interval
	else:
		# apply friction when no input
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		run_dust.emitting = false
		
	# Update animation
	if not animation_locked:
		update_animation(direction, delta)
	
	move_and_slide()

	var collision = get_last_slide_collision()
	if collision and collision.get_collider().name == "SpikeLayer":
		print("Collided with:", collision.get_collider().name)
		death_screen.show_death_screen()
		die()
	if can_shoot and Input.is_action_just_pressed("shoot"):
		if not is_on_floor():
			if facing_right:
				sprite.play("jump_shoot_right")
			else:
				sprite.play("jump_shoot_left")
			animation_locked = true
		elif direction == 0:
			if facing_right:
				sprite.play("shoot")
			else:
				sprite.play("shoot_left")
			animation_locked = true
		shoot_projectile()
			
		
		can_shoot = false  # Prevent shooting again immediately
		
		# Set a timer to re-enable movement after the shoot animation duration
		await get_tree().create_timer(0.3).timeout  # Adjust duration as needed

		# Set cooldown for shooting
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true
		

func die():
	set_physics_process(false)  # disable movement
	hide()  # hide player
	death_player.play()
	
	
func update_animation(direction: float, delta: float) -> void:
	if not is_on_floor():
		if velocity.y >= 0:  #fall if moving down
			if facing_right:
				sprite.play("fall_right") 
			else:
				sprite.play("fall_left")
		elif facing_right:
			
			sprite.animation = "jump_right"
			
		else:
			sprite.animation = "jump_left"
			
		sprite.scale = Vector2(.47, .47) #adjust sprite scale to account for inconsistency
	else:
		if direction != 0:
			sprite.play("run_right" if facing_right else "run_left")
			sprite.position.y = lerp(sprite.position.y, 15.0, 20 * delta)  # scoot sprite down to adjust for inconsistency
		else:
			sprite.play("idle_right" if facing_right else "idle_left")
			sprite.position.y = lerp(sprite.position.y, 0.0, 20 * delta)  # unscoot
		sprite.scale = Vector2(.5, .5)
		
func shoot_projectile():
	if projectile_scene:
		gun_sprite.play("default")
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = shoot_position.global_position
		shoot_player.pitch_scale = randf_range(0.8, 1.2) # Random pitch between 0.9 and 1.1
		shoot_player.play()
		
		# Get the Hitbox node inside the projectile
		var hitbox = projectile.get_node("Hitbox")  # Make sure "Hitbox" is the correct name
		if hitbox:
			hitbox.direction = Vector2.RIGHT if facing_right else Vector2.LEFT
		projectile.get_node("Hitbox/Sprite2D").flip_h = facing_right
		gun_sprite.flip_h = not facing_right
		gun_sprite.position.x = 100 if facing_right else -100
