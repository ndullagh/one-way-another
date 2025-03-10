extends CharacterBody2D

#Script for controlling the player character.
#right now in the scene tree the player character exists only within level 3. This may need to change in some way.
#this may mean adding a "player" to each scene, or somehow making the player universal. I'm not sure of the details.
@export var projectile_scene: PackedScene  # Reference to the projectile scene
@onready var shoot_position = $ShootPoint  # Position from where bullets spawn


@onready var sprite = $AnimatedSprite2D  # Make sure this matches your node's path
@onready var gun_sprite = $AnimatedSprite2D2
@onready var death_screen = $/root/Node2D/death_screen

@export var coyote_time: float = 0.1  # time allowed to jump after falling

@export var ACCELERATION: float = 5000 # how fast you reach max speed
@export var FRICTION: float = 6000  # How fast you slow down

var coyote_timer: float = 0.0

const SPEED = 600.0
const JUMP_VELOCITY = -1000

var max_jumps = 1

var jumps_left = max_jumps

var facing_right = true  # track player's facing direction


func _ready():
	gun_sprite.animation_finished.connect(_on_animation_finished)
	

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
	else:
		# apply friction when no input
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	
	if Input.is_action_just_pressed("shoot"):
		shoot_projectile()
		
	# Update animation
	update_animation(direction, delta)
	
	move_and_slide()

	var collision = get_last_slide_collision()
	if collision and collision.get_collider().name == "SpikeLayer":
		print("Collided with:", collision.get_collider().name)
		death_screen.show_death_screen()
		die()

func die():
	set_physics_process(false)  # disable movement
	hide()  # hide player
	
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
		
		# Get the Hitbox node inside the projectile
		var hitbox = projectile.get_node("Hitbox")  # Make sure "Hitbox" is the correct name
		if hitbox:
			hitbox.direction = Vector2.RIGHT if facing_right else Vector2.LEFT
		projectile.get_node("Hitbox/Sprite2D").flip_h = facing_right
		gun_sprite.flip_h = not facing_right
		gun_sprite.position.x = 100 if facing_right else -100
