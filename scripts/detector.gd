"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

@tool
extends Label

# You know... As in DevHubOne button?
enum DHO_BUTTON {
	A,
	B,
	C,
	D,
	E,
	F,
	PLAY,
	EXIT
}
@export var button_capture: DHO_BUTTON = DHO_BUTTON.A

const DHO_BUTTON_NAMES: Dictionary = {
	DHO_BUTTON.A : 		"A",
	DHO_BUTTON.B : 		"B",
	DHO_BUTTON.C : 		"C",
	DHO_BUTTON.D : 		"D",
	DHO_BUTTON.E : 		"E",
	DHO_BUTTON.F : 		"F",
	DHO_BUTTON.PLAY :	"Play (Left)",
	DHO_BUTTON.EXIT :	"ChangeGame (Right)",
}


const DEFAULT_DHO_MAPPING: Dictionary = {
	DHO_BUTTON.A : 		"ui_select",
	DHO_BUTTON.B : 		"", # no default godot mapping.
	DHO_BUTTON.C : 		"", # no default godot mapping.
	DHO_BUTTON.D : 		"ui_colorpicker_delete_preset",
	DHO_BUTTON.E : 		"", # no default godot mapping.
	DHO_BUTTON.F : 		"", # no default godot mapping.
	DHO_BUTTON.PLAY :	"", # no default godot mapping.
	DHO_BUTTON.EXIT :	"", # no default godot mapping.
}

const DHO_EVENT_TRIGGERS: Dictionary = {
	DHO_BUTTON.A: 		JOY_BUTTON_Y, 				# Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X) - All devices
	DHO_BUTTON.B: 		JOY_BUTTON_B, 				# Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A) - All devices
	DHO_BUTTON.C: 		JOY_BUTTON_A, 				# Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B) - All devices
	DHO_BUTTON.D: 		JOY_BUTTON_X, 				# Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y) - All devices
	DHO_BUTTON.E: 		JOY_BUTTON_LEFT_SHOULDER, 	# Joypad Button 9 (Left Shoulder, Sony L1, Xbox LB)
	DHO_BUTTON.F: 		JOY_BUTTON_RIGHT_SHOULDER, 	# Joypad Button 10 (Right Shoulder, Sony R1, Xbox RB)
	DHO_BUTTON.PLAY: 	JOY_BUTTON_START, 			# Joypad Button 6 (Start, Xbox Menu, Nintendo +)
	DHO_BUTTON.EXIT: 	JOY_BUTTON_BACK 			# Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)
}

const DHO_EVENT_NAMES: Dictionary = {
	DHO_BUTTON.A: 		"\"Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X) - All devices\" | InputEventJoypadButton.JOY_BUTTON_Y",
	DHO_BUTTON.B: 		"\"Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A) - All devices\" | InputEventJoypadButton.JOY_BUTTON_B",
	DHO_BUTTON.C: 		"\"Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B) - All devices\" | InputEventJoypadButton.JOY_BUTTON_A",
	DHO_BUTTON.D: 		"\"Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y) - All devices\" | InputEventJoypadButton.JOY_BUTTON_X",
	DHO_BUTTON.E: 		"\"Joypad Button 9 (Left Shoulder, Sony L1, Xbox LB)\" | InputEventJoypadButton.JOY_BUTTON_LEFT_SHOULDER",
	DHO_BUTTON.F: 		"\"Joypad Button 10 (Right Shoulder, Sony R1, Xbox RB)\" | InputEventJoypadButton.JOY_BUTTON_RIGHT_SHOULDER",
	DHO_BUTTON.PLAY: 	"\"Joypad Button 6 (Start, Xbox Menu, Nintendo +)\" | InputEventJoypadButton.JOY_BUTTON_START",
	DHO_BUTTON.EXIT: 	"\"Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)\" | InputEventJoypadButton.JOY_BUTTON_BACK",
}

const ON_TEXT  := "[ON ]"
const OFF_TEXT := "[OFF]"

func update_text(is_on: bool = false) -> void:
	var display_text := "%s" % [(ON_TEXT if is_on else OFF_TEXT)]
	display_text += " %15-s" % [DHO_BUTTON_NAMES[self.button_capture]]
	display_text += "   (%s)" % [DHO_EVENT_NAMES[self.button_capture]]
	self.set_text(display_text)

func _ready() -> void:
	self.update_text(false)

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.is_pressed() && event.get_button_index() == DHO_EVENT_TRIGGERS[self.button_capture]:
			self.update_text(true)
		elif event.is_released() && event.get_button_index() == DHO_EVENT_TRIGGERS[self.button_capture]:
			self.update_text(false)
