# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends Resource
class_name ScoreDataHolder

const MAX_SCORE_HOLD = 10 # Can hold more than 10 but currently shows just 10, so why bother.
@export var scores: Array[PlayerScoreData]
const scores_location: String = "user://score_data.tres"

# TODO: what to do with equal scores?
func sort_scores() -> void:
	scores.sort_custom(PlayerScoreData._bigger_score)

# TODO: remove_score()?? Check score validity? or not responsible.
## Adds score and sorts it in. If overflowing - deletes worst score.
func add_score(score_data: PlayerScoreData) -> bool:
	var score_deleted: bool = false
	self.scores.push_back(score_data)
	self.sort_scores()
	while self.scores.size() > MAX_SCORE_HOLD:
		if scores.pop_back() == score_data:
			score_deleted = true
	return score_deleted


## Returns the best best_count scores or all of them if best_count = -1
func get_scores(best_count: int = -1) -> Array[PlayerScoreData]:
	if best_count == -1:
		return scores
	return self.scores.slice(0, best_count)

static func load_scores() -> ScoreDataHolder:
	var result: ScoreDataHolder = null
	if not FileAccess.file_exists(scores_location):
		result = ScoreDataHolder.new()
		var error = ResourceSaver.save(result, scores_location)
		if error != OK:
			push_error("Failed to save score data when loading: " + error_string(error))
	else:
		result = load(scores_location)
		if result == null:
			push_error("Failed to load saved score data")
	if result is ScoreDataHolder:
		# Just in case data was tampered with
		result.sort_scores()
	return result

func save_scores() -> Error:
	return ResourceSaver.save(self, scores_location)
