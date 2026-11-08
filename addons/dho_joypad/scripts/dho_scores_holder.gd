extends VBoxContainer

const BEST_SCORE_COUNT = 10
const scores_location: String = "user://score_data.tres"
var score_holder: ScoreDataHolder = null

func _ready() -> void:
	if not FileAccess.file_exists(scores_location):
		self.score_holder = ScoreDataHolder.new()
		var error = ResourceSaver.save(self.score_holder, scores_location)
		if error != OK:
			push_error("Failed to save score data: " + error_string(error))
	else:
		self.score_holder = load(scores_location)
	# Just in case data was tampered with
	self.score_holder.sort_scores()
	var index: int = 1
	for score_data in self.score_holder.get_scores(BEST_SCORE_COUNT):
		var label: Label = Label.new()
		label.text = "#%d   %s   %s" % [index, score_data.name, score_data.score]
		index += 1
		self.add_child(label)
