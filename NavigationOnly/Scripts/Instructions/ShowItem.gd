extends Instruction
class_name ShowItem

var _itemName: String

func _init(itemName: String) -> void:
	_itemName = itemName

func execute(_gameState: GameState, gameData: GameData) -> Result:
	var item: GameItem = gameData.items.get(_itemName, null)
	if item == null:
		return Result.new(false, "Did not find item for name "+ _itemName)
	
	return Result.new(true, item.description)
