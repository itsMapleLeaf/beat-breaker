class_name Note
extends MeshInstance2D

var hold_duration := 0.0
var time: float
var placement_divisor: int
var placement: int
var type: NoteType = NoteType.CATCH

enum NoteType {
	TAP,
	CATCH,
}
