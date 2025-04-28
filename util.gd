extends Node

static func seconds_to_beats(seconds: float, bpm: float) -> float:
	return seconds * (bpm / 60.0)

static func beats_to_seconds(beats: float, bpm: float) -> float:
	return beats * (60.0 / bpm)
