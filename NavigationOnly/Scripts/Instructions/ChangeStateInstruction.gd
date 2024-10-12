extends Instruction
class_name ChangeUserState

# perhaps only int state??
# is inventory a special state?
# no. no inventory. no. nothing moves.

enum Type {
	SET
	# ADD, SUBTRACT
}

var type: Type = Type.SET

var value: Variant
var key: String

func _init(key: Variant, value: String, type: Type = Type.SET):
	self.key = key
	self.value = value
	self.type = type

func executeChange(gameState: GameState) -> Result:
	return Result.new(false, "Change User State isn't doing anything.")
