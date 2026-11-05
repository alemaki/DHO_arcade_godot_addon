"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

@tool
extends Label


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	"""
	The documentation below is for any godot version from 4.x <= 4.8.
	They might be compatible for future versions or might not be.

	We are using the default movement names (ui_left, ui_right, etc.) here.

	NOTE: IF you have DELETED the input mapping for those events, this test script WILL NOT WORK!!!!

	New projects in Godot have them ON by default. Feel free to define yours if you want to.
	The instructions are below. You can see the godot built-in actions by going into:
	Project -> Project Settings -> Input Map -> Show Built-In-Actions.
	
	The devhubone joystick is captured by the default actions ui_left, ui_right, ui_up, ui_down.
	I am sure those are descriptive enough.
	
	You can capture the joystick events by defining your own action names 
	(for example 'process_[direction]') and setting the input capture to: 
	'process_left' : Joypad Axis 0 - (Left stick Left, Joystick 0 Left)
	'process_right': Joypad Axis 0 + (Left stick Right, Joystick 0 Right)
	'process_up'   : Joypad Axis 1 - (Left stick Up, Joystick 0 Up)
	'process_Down' : Joypad Axis 1 + (Left stick Down, Joystick 0 Down)
	"""
	
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# You can also capture the axis' by using:
	# var axis_X: float = Input.get_axis("ui_left", "ui_right")
	# var axis_Y: float = Input.get_axis("ui_up", "ui_down")
	# but you might have to normalise them after.
	#
	# Or the direct input with:
	# var input_left: float = Input.get_action_strength("ui_left")
	self.set_text("X: %f, Y: %f" % [input_direction.x, input_direction.y])
