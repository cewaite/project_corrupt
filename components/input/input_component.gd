## This is a basic input node from which all will inherit. 
class_name InputComponent extends Node

var move_input : Vector2	## Vector2 for which direction on x and z to move
var jump_input_pressed : bool	## True for jump pressed, false otherwise. 
var jump_input_released : bool	## True for jump released, false otherwise. 

var interact_input: bool

var drop_input: bool
var primary_input_pressed: bool
var secondary_input_pressed: bool
var primary_input_released: bool
var secondary_input_released: bool
var reload_input: bool

#/
## Return the Move Input float. 
func get_move_input() -> Vector2:
	return move_input

#/
## Return the Jump Input bool. 
func get_jump_input_pressed() -> bool:
	return jump_input_pressed

## Return the Jump Input bool. 
func get_jump_input_released() -> bool:
	return jump_input_released

#/
## Base function to handle inputs. TO BE OVERWRITTEN
func handle_move_inputs(_delta): 
	pass

func handle_wieldable_inputs():
	pass

func handle_interact_input():
	pass

func get_primary_input_pressed() -> bool:
	return primary_input_pressed

func get_secondary_input_pressed() -> bool:
	return secondary_input_pressed

func get_primary_input_released() -> bool:
	return primary_input_released

func get_secondary_input_released() -> bool:
	return secondary_input_released

func get_interact_input() -> bool:
	return interact_input

func get_drop_input() -> bool:
	return drop_input

func get_reload_input() -> bool:
	return reload_input
