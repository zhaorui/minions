activate application "Console"
tell application "System Events"
	keystroke "~"
	delay 0.1
	
	key code 124 -- which is right arrow
	delay 0.1
	
	key code 4 using shift down
end tell