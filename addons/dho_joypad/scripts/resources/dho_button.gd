# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.

@tool
extends Resource
class_name DHOButtonInformation

@export var button: DHOJoypad.BUTTON
@export var button_name: String # TODO: make localized resource?
@export var input_action: String
@export var joy_button: JoyButton
@export var event_name: String
