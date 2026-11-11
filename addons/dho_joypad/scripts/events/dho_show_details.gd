# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends DHOEvent
class_name DHOShowDetails

const GROUP_NAME = "hidden_details"

func execute() -> void:
	get_tree().call_group(GROUP_NAME, "show_details")
