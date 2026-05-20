extends CharacterBody2D

@export var speed = 200
@export var jump_speed = -400
@export var gravity = 800
@export var push_force = 100 #set all movable objects to layer 4 to avoid infinite speed because of moving_platform layer check on CharacterBody2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	update_animation()
	update_gravity(delta)
	movement()
	move_and_slide()
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is RigidBody2D:
			col.get_collider().apply_central_impulse(-col.get_normal() * push_force)

func movement():
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		

func update_animation():
	if velocity.x == 0:
		animation.play("idle")
		return
	if velocity.x >= 1:
		animation.scale.x = 0.1 
		animation.play("walking")
	elif velocity.x <= -1:
		animation.scale.x = -0.1
		animation.play("walking")

func update_gravity(delta):
	velocity.y += gravity * delta

#dash
var hold_time = 0.0
var hold_threshold = 3.0
var dash_speed = 600.0

func _process(delta):
	if Input.is_action_pressed("dash"):
		hold_time += delta
		var progress = hold_time / hold_threshold
		print("Hold progress: ", progress * 100, "%")
		
		if hold_time >= hold_threshold:
			execute_dash()
			hold_time = 0.0
	else:
		hold_time = 0.0

func execute_dash():
	var input_vector = Input.get_vector("R_dash", "L_dash", "up_dash", "Down_dash")
	velocity = input_vector.normalized() * dash_speed
	move_and_slide()  # Actually move the character!
	print("dash")
