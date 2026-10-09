extends Area2D

const PLAYER_GROUP: StringName = &"Player"
const SEPARATION_RADIUS: float = 12.0
const SEPARATION_WEIGHT: float = 1.5
const VELOCITY_SMOOTHING: float = 10.0
const BOUNCE_HEIGHT: float = 1.5
const BOUNCE_SPEED: float = 12.0

@export var speed: float = 30.0

@onready var sprite: Sprite2D = $EnemyModel

var player: Node2D
var _velocity: Vector2 = Vector2.ZERO
var _rest_position: Vector2 = Vector2.ZERO
var _bounce_time: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group(PLAYER_GROUP) as Node2D
	_rest_position = sprite.position
	_bounce_time = randf() * TAU

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var chase: Vector2 = _get_chase_direction()
	var push: Vector2 = _get_separation_push()
	
	_move(chase, push, delta)
	_update_facing_direction(chase)
	_apply_bounce(delta)

func _get_chase_direction() -> Vector2:
	return global_position.direction_to(player.global_position)

func _get_separation_push() -> Vector2:
	var push: Vector2 = Vector2.ZERO
	for other: Area2D in get_overlapping_areas():
		push += _get_push_from(other)
	return push

func _get_push_from(other: Area2D) -> Vector2:
	var away: Vector2 = global_position - other.global_position
	if away == Vector2.ZERO:
		away = Vector2.RIGHT.rotated(randf() * TAU)
	var strength: float = 1.0 - clampf(away.length() / SEPARATION_RADIUS, 0.0, 1.0)
	return away.normalized() * strength

func _move(chase: Vector2, push: Vector2, delta: float) -> void:
	var target: Vector2 = (chase + push * SEPARATION_WEIGHT).limit_length(1.0) * speed
	_velocity = _velocity.lerp(target, VELOCITY_SMOOTHING * delta)
	global_position += _velocity * delta

func _update_facing_direction(direction: Vector2) -> void:
	if direction.x != 0.0:
		sprite.flip_h = direction.x < 0.0

func _apply_bounce(delta: float) -> void:
	_bounce_time += delta * BOUNCE_SPEED
	sprite.position.y = _rest_position.y - absf(sin(_bounce_time)) * BOUNCE_HEIGHT
