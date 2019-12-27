left = "left"
right = "right"
up = "up"
down = "down"
forward = "forward"
back = "back"

otherDirection = {
	[left] = right,
	[right] = left,
	[up] = down,
	[down] = up,
	[forward] = back,
	[back] = forward
}

turnDirection = {
	[right] = turtle.turnRight,
	[left] = turtle.turnLeft
}
