var bpm: float

func _init(bpm: float) -> void:
	self.bpm = bpm

func beats_to_seconds(beats: float) -> float:
	return beats * (60.0 / bpm)

func seconds_to_beats(seconds: float) -> float:
	return seconds * (bpm / 60.0)
