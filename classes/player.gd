class_name player extends Node

var team_name: String = ""
var active: bool = false
var team_color: Color 
var current_mouse = 0
var mice = []

func get_next_mouse():
	if mice.size() == 0 or mice.filter(is_dead).size() == mice.size():
		return null
	if current_mouse == mice.size()-1:
		current_mouse = 0
	else:
		current_mouse += 1

	return mice[current_mouse]


func is_dead(mouse):
	return mouse.dead