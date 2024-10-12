extends Instruction
class_name ErrorInstruction

var message: String

func _init(errorMessage: String) -> void:
	message = errorMessage

func _excecuteChange(_gameState: GameState) -> Result:
	printerr(message)
	return Result.new(false, "I think it would be cool to try and shove in preset values through these. Like %originalText% and %target% or %verb%.")
