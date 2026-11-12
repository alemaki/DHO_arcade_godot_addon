# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

## This class sets a label with localized text. You can make use of it, however I
## would recommend against it in a game jam setting, because you won't need localization.
extends Label
class_name DHOLocalizedLabel

@export var localized_text_res: DHOLocalizedText = null

func _ready() -> void:
	assert(localized_text_res != null)
	self.set_text(localized_text_res.get_text())
