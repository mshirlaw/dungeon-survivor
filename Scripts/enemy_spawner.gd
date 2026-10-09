extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.0
@export var ring_margin: float = 2.0

@onready var timer: Timer = $Timer

const PLAYER_GROUP: StringName = &"Player"

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group(PLAYER_GROUP) as Node2D
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	if player == null:
		return
	_spawn_enemy()

func _spawn_enemy() -> void:
	var enemy: Node2D = enemy_scene.instantiate()
	enemy.global_position = get_spawn_position()
	add_child(enemy)
	
func get_spawn_position() -> Vector2:
	var viewport_size: Vector2 = get_viewport_rect().size
	var radius: float = viewport_size.length() / 2.0 + ring_margin
	var angle: float = randf() * TAU
	return player.global_position + Vector2.RIGHT.rotated(angle) * radius
