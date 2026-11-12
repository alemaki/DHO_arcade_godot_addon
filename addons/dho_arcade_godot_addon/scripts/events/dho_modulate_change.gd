# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends DHOEvent
class_name DHOChangeModulate

# Measured in seconds
@export var change_time: float = 2.9
@export var change_time_after: float = 0.1
@export var canvas_item_to_change: CanvasItem = null

func _ready() -> void:
	assert(canvas_item_to_change != null)

func execute() -> void:
	var real_modulate: Color = canvas_item_to_change.get_modulate()
	var modulate_tween: Tween = get_tree().create_tween()
	modulate_tween.tween_property(canvas_item_to_change, "modulate", Color.WHITE, change_time)
	modulate_tween.tween_property(canvas_item_to_change, "modulate", real_modulate, change_time_after)
	
