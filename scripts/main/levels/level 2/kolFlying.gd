extends CharacterBody2D

#Script for controlling the player character.
#right now in the scene tree the player character exists only within level 3. This may need to change in some way.
#this may mean adding a "player" to each scene, or somehow making the player universal. I'm not sure of the details.

@onready var sprite = $AnimatedSprite2D  # Make sure this matches your node's path
@onready var death_screen = $/root/Node2D/death_screen

@export var coyote_time: float = 0.1  # time allowed to jump after falling

@export var ACCELERATION: float = 5000 # how fast you reach max speed
@export var FRICTION: float = 6000  # How fast you slow down

var boost_timer: float = 0
var boost_cooldown: float = 0

var active: bool = true

var SPEED = 600.0
const BOOST = 10000

var facing_right = true  # track player's facing direction


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		#coyote_timer -= delta  # countdown when in the air
	#else:
		#jumps_left = max_jumps  # reset jumps when touching the ground
		#coyote_timer = coyote_time
	boost_timer -= delta
	boost_cooldown -= delta
	
 
	# handle BOOST
	if Input.is_action_pressed("ui_select") and boost_timer < 0 and active:
		SPEED = BOOST
		boost_cooldown = .25
		boost_timer = 1.25
		active = false
		
	#To stop the user from holding Space Bar between boosts
	if !Input.is_action_pressed("ui_select"):
		active = true;
	
	if(boost_cooldown < 0):
		SPEED = 600.0
		
		
		
		
		
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
	var directionY := Input.get_axis("ui_up", "ui_down")
	if direction != 0:
		# apply acceleration towards max speed
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		facing_right = direction > 0  # Update facing direction
	else:
		# apply friction when no input
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
		
	if directionY != 0:
		velocity.y = move_toward(velocity.y, directionY * SPEED, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
		
	# Update animation
	update_animation(direction, delta)

	move_and_slide()

	var collision = get_last_slide_collision()
	if collision and (collision.get_collider().name == "SpikeLayer" or collision.get_collider().name == "SpikeLayer2"):
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
