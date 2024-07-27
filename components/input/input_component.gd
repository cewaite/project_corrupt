## This is a basic input node from which all will inherit. 
class_name InputComponent extends Node3D

var move_input : Vector2	## Vector2 for which direction on x and z to move
var jump_input : bool	## True for jump, false otherwise. 

#/
## Return the Move Input float. 
func get_move_input() -> Vector2:
	return move_input

#/
## Return the Jump Input bool. 
func get_jump_input() -> bool:
	return jump_input

#/
## Base function to handle inputs. 
func handle_move_inputs(delta): 
	pass
