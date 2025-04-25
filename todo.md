# prototype checklist

- [ ] hold notes
	- hold note bodies are defined by several points
	- judgement/movement for body points are treated the same as catch notes,
	  except one miss breaks the entire note
	- for now, only linear interpolation (?)
- [ ] chords
- [ ] full chart
- [ ] tap & placement conditions
	- keep two booleans on every note for whether it was tapped at the right time and whether it was moved to within the timing window
	- goal: add some leniency:
		- allow tapping a note if placement was correct _at any point_ within timing window
		- consider a note tapped if tap timing was correct, then the user moves to the right placement within timing window
	- in a chord of notes, all notes share placement and tap conditions, ergo either of them can be moved to and tapped to score all of them

## fun stuff

- [ ] receptor trail
- [ ] briefly flash receptor on simultaneous taps
- [ ] faded receptor, opaque on tap
- [ ] note tap explosion
- [ ] judgment animations
- [ ] "smooth snap" movement (snap to position minus some number then animate the rest of the way)
- [ ] pause, resume, seek, restart
