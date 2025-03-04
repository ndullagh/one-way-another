extends CharacterBody2D

#Script for controlling the player character.
#right now in the scene tree the player character exists only within level 3. This may need to change in some way.
#this may mean adding a "player" to each scene, or somehow making the player universal. I'm not sure of the details.

@onready var sprite = $AnimatedSprite2D  # Make sure this matches your node's path
@onready var death_screen = $/root/Node2D2/death_screen

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
		sprite.play("boost")
		await sprite.animation_finished
		sprite.play("flying")  # Return to idle after attack
		
		
	#To stop the user from holding Space Bar between boosts
	if !Input.is_action_pressed("ui_select"):
		active = true;
	
	if(boost_cooldown < 0):
		SPEED = 600.0
		

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
	#update_animation(direction, delta)

	move_and_slide()

	var collision = get_last_slide_collision()
	if collision and (collision.get_collider().name == "SpikeLayer" or collision.get_collider().name == "SpikeLayer2"):
		print("Collided with:", collision.get_collider().name)
		death_screen.show_death_screen()
		die()
	

func die():
	set_physics_process(false)  # disable movement
	hide()  # hide player
	
#func update_animation(direction: float, delta: float) -> void:
	
