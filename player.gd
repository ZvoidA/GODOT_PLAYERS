extends Area2D

@export var speed = 400
@export var jump_force = -300
@export var gravity_force = 600
@export var jump_duration = 1 
@export var attack_duration = 1.0 

var screen_size
var velocity = Vector2.ZERO
var is_jumping = false
var is_attacking = false
var jump_timer = 0.0
var attack_timer = 0.0
var original_y_position = 0.0

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var move_input = Vector2.ZERO

	if Input.is_action_just_pressed("sword_attack") and not is_attacking:
		is_attacking = true
		attack_timer = attack_duration
		$AnimatedSprite2D.animation = "sword"
		$AnimatedSprite2D.play()

	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
		else:
			return 

	if Input.is_action_pressed("move_right"):
		move_input.x += 1
	if Input.is_action_pressed("move_left"):
		move_input.x -= 1
	if Input.is_action_pressed("move_down"):
		move_input.y += 1
	if Input.is_action_pressed("move_up"):
		move_input.y -= 1

	if move_input.length() > 0 and not is_jumping:
		move_input = move_input.normalized() * speed
		velocity.x = move_input.x
		velocity.y = move_input.y
	else:
		if not is_jumping:
			velocity = Vector2.ZERO

	if Input.is_action_just_pressed("ui_accept") and not is_jumping:
		is_jumping = true
		original_y_position = position.y
		velocity.y = jump_force
		jump_timer = jump_duration
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.play()

	if is_jumping:
		jump_timer -= delta
		velocity.y += gravity_force * delta
		if jump_timer <= 0:
			is_jumping = false
			position.y = original_y_position
			velocity.y = 0

	position += velocity * delta

	if not is_jumping and not is_attacking:
		if move_input.length() > 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
