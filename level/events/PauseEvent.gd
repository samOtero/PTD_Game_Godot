extends Resource

class_name PauseEvent

var paused: int

func isPaused():
	if (paused > 0): return true
	return false
	
func doPause():
	paused += 1;
	
func doUnpause():
	paused -= 1;
	if (paused < 0): paused = 0;
