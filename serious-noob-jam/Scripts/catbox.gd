extends CharacterBody2D

@export var speed = 100

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		velocity.x = -100
	if Input.is_action_just_pressed("move_right"):
		velocity.x = 100 
	move_and_slide()
