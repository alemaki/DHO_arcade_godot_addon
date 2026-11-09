# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label
class_name DHOBlinkingLabel

## Measured in seconds
@export var show_duration = 0.6
## Measured in seconds
@export var hide_duration = 0.2

# YOU THINK YOU CAN STOP ME?!
func _ready() -> void:
	self._show_label()

func _show_label() -> void:
	self.get_tree().create_tween().tween_property(self, "modulate:a", 1, 0.15)
	self.get_tree().create_timer(show_duration).timeout.connect(self._hide_label)

func _hide_label() -> void:
	self.get_tree().create_tween().tween_property(self, "modulate:a", 0, 0.15)
	self.get_tree().create_timer(hide_duration).timeout.connect(self._show_label)
