extends Resource
class_name Instruction

# This feels like a glowing red antipattern

# We have things that affect the state of the game
# and we have things that affect what the player sees
# should we be deciding what the player sees this way at all?
# should instead the current room changing in the state cause the text to change?
# depending on how the map player is handling that???

# yes. that feels better.


# can instructions just do nothing? Just an empty "LookAround" where all the controller scripts want
# is to know the type?
# maybe a "GameEvent" instruction? with an enum or string type on it
# refresh
# new room
# uh. add more text...?
# or just sceneryDescription or examine description???? mmmmMMMMMM

## Please Implement In Children!!!
func executeChange(_gameState: GameState) -> void:
	# I need a game state resource.
	pass
