extends Instruction
class_name ErrorInstruction

var message: String

func _init(errorMessage: String):
	message = errorMessage

func _excecuteChange(gameState: GameState) -> void:
	printerr(message)
