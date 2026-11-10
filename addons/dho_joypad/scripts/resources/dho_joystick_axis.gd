# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

@tool
extends Resource
class_name DHOJoystickAxisInformation

@export var axis_name: String
@export var input_action: String
@export_range(-1, 1, 2) var axis_value: int
@export var joy_axis: JoyAxis
@export var event_name: String
