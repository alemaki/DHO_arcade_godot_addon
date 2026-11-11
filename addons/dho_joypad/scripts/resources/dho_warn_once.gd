# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends RefCounted
class_name DHOWarner

## Messages already reported
static var _warned: Dictionary = {}

static func warn_once(message: String) -> void:
	if not _warned.has(message):
		_warned[message] = true
		push_warning(message)
