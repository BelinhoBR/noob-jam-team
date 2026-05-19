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
