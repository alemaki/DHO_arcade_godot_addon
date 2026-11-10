# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## A static class that contains method for changing scenes for DevHubOne's arcade.
class_name DHOSceneManager

## Changes the current scene to the next and passes the context to that scene.[br]
## [param current_node] : any node from the current scene will do.[br]
## [param to_path] : scene path to change to. The resulting scene MUST inherit [DHOScene][br]
## [param context]: The context to pass to the next scene.[br]
static func change_scene(current_node: Node, to_path: String, context: DHOSceneContext) -> Error:
	var tree: SceneTree = current_node.get_tree()
	var old_root: Node = tree.get_current_scene()
	var new_root: DHOScene =  load(to_path).instantiate() as DHOScene
	assert(new_root != null)
	new_root.dho_context = context
	var error: Error = tree.change_scene_to_node(new_root)
	if error == OK:
		await tree.scene_changed # await just to be safe
	return error

## Changes the current scene to the next creates new context for that scene.[br]
## [param current_node] : any node from the current scene will do.[br]
## [param to_path] : scene path to change to. The resulting scene MUST inherit [DHOScene][br]
static func change_scene_new_context(current_node: Node, to_path: String) -> Error:
	var context = DHOSceneContext.new()
	return await change_scene(current_node, to_path, context)
