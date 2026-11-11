# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends Label

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var direction: Vector2 = DhoJoypad.get_input_vector()
	self.set_text("X=%3.2f, Y=%3.2f" % [direction.x, direction.y])
	
