extends CharacterBody2D

const SPEED = 100.0
const RUN_SPEED = 180.0
const JUMP_VELOCITY = -350.0
const GRAVITY = 980.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
	var direction = Input.get_axis("left", "right")

	var is_running = Input.is_action_pressed("run")

	if direction:
		if is_running:
			velocity.x = direction * RUN_SPEED
		else:
			velocity.x = direction * SPEED

		# Vira o Mario
		if direction < 0:
			animated_sprite.flip_h = true
		elif direction > 0:
			animated_sprite.flip_h = false

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animações
	update_animation(direction, is_running)

	move_and_slide()


func update_animation(direction, is_running):
	# No ar
	if not is_on_floor():
		if velocity.y < 0:
			if is_running:
				animated_sprite.play("run_jump")
			else:
				animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
		return

	# Agachado
	if Input.is_action_pressed("duck"):
		animated_sprite.play("duck")
		return

	# Parado
	if direction == 0:
		animated_sprite.play("idle")
		return

	# Correndo
	if is_running:
		animated_sprite.play("run")
		return

	# Andando
	animated_sprite.play("walk")
