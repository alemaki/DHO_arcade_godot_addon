# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## You can use this class to print a warning to the output only once when the game has started.
## Intended for error messages that are checked during frame functions (e.g. _process) so they
## don't spam the output.
extends RefCounted
class_name DHOWarner

## Messages already reported
static var _warned: Dictionary = {}

static func warn_once(message: String) -> void:
	if not _warned.has(message):
		_warned[message] = true
		push_warning(message)
