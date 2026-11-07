## Copyright (c) 2026 Alexander Makedonski
## SPDX-License-Identifier: MIT

# NOTE: Look at dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label

@export var dho_input: DHOJoypad = null

func _ready() -> void:
	assert(dho_input != null)

func _process(_delta: float) -> void:
	var direction := dho_input.get_input_vector()
	self.set_text("X=%3.2f, Y=%3.2f" % [direction.x, direction.y])
