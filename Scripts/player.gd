extends CharacterBody2D

@export var speed: float = 80.0
@export var bob_height: float = 1.5
@export var bob_speed: float = 14.0
@export var tilt_degrees: float = 6.0
@export var reset_smoothing: float = 20.0
@export var squash_amount: float = 0.05

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _bob_time: float = 0.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	_animate(direction, delta)

func _animate(direction: Vector2, delta: float) -> void:
	if direction.x != 0.0:
		sprite.flip_h = direction.x < 0.0

	if direction == Vector2.ZERO:
		_bob_time = 0.0
		sprite.position = sprite.position.lerp(Vector2.ZERO, reset_smoothing * delta)
		sprite.rotation = lerp_angle(sprite.rotation, 0.0, reset_smoothing * delta)
		sprite.scale = sprite.scale.lerp(Vector2.ONE, reset_smoothing * delta)
		return

	_bob_time += delta * bob_speed
	
	var wave: float = sin(_bob_time)
	
	sprite.position.y = -absf(wave) * bob_height
	sprite.rotation = deg_to_rad(wave * tilt_degrees)
	sprite.scale = Vector2(1.0 + absf(wave) * squash_amount, 1.0 - absf(wave) * squash_amount)
