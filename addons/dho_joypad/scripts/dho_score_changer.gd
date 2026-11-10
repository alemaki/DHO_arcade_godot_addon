extends Label

@export var dho_scene: DHOScene = null
@export var display_text: String = "Score: "

func _ready() -> void:
	if self.dho_scene == null:
		self.dho_scene = DHOScene._walk_parents_to_find_dho_scene(self)
	assert(dho_scene != null)
	DhoJoypad.dho_button_pressed.connect(self._on_button_pressed)

func update_text():
	self.set_text("%s %06d" % [self.display_text, self.dho_scene.dho_context.player_info.score])

func _on_button_pressed(button: DHOJoypad.BUTTON, device):
	if button == DHOJoypad.BUTTON.A:
		self.dho_scene.dho_context.player_info.score += 10
		self.update_text()
	
