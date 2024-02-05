class_name Room
extends Resource

var uniqueKey: String
var name: String
var description: String
var exits: Dictionary # TODO Make this not an untyped dictionary :(
var items: Array[Resource]
var interactables: Array[Resource]

# TODO pull this logic out and into something that does these checks based on passed room data


func checkDirectionForExit(direction: StringName) -> Room:
    # This impl doesn't allow for busted doors. Do I actually need a portal repr?
    # also how can i avoid a null return here boohoo. an error Room???
    if exits.has(direction):
        return exits[direction] as Room
    return null

func itemIsPresent(_itemName: StringName) -> bool:
    #TODO update to actually check the presence of an item
    return true

func interactableIsPresent(_objectName: StringName) -> bool:
    #TODO actually check for things
    return true