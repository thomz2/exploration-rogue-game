extends Node2D

var grid: Array = []
const CELL_SIZE = 8

enum {EMPTY, ROOM, SPAWN_ROOM, END_ROOM}

func set_grid(new_grid: Array):
	grid = new_grid
	queue_redraw()

func _draw():
	for x in range(grid.size()):
		for y in range(grid[x].size()):
			
			var color = Color.DARK_GRAY
			if grid[x][y] == ROOM:
				color = Color.GREEN_YELLOW
			elif grid[x][y] == SPAWN_ROOM:
				color = Color.LIGHT_SKY_BLUE
			elif grid[x][y] == END_ROOM:
				color = Color.YELLOW
			
			var rect = Rect2(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
			
			draw_rect(rect, color)
			draw_rect(rect, Color.WHITE, false)
