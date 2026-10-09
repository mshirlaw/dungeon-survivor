extends CanvasLayer

const PLAYER_GROUP: StringName = &"Player"
const ENEMY_GROUP: StringName = &"Enemy"

@onready var panel: PanelContainer = $MarginContainer/PanelContainer
@onready var label: Label = $MarginContainer/PanelContainer/Label

func _process(_delta: float) -> void:
	var player: Node2D = get_tree().get_first_node_in_group(PLAYER_GROUP) as CharacterBody2D
	var enemy_count: int = get_tree().get_node_count_in_group(ENEMY_GROUP)
	var position_text: String = "n/a"
	
	if player != null:
		position_text = "%d, %d" % [player.global_position.x, player.global_position.y]

	label.text = "FPS: %d\nPos: %s\nEnemies: %d" % [
		Engine.get_frames_per_second(),
		position_text,
		enemy_count
	]
