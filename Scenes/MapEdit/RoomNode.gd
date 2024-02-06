@tool
class_name RoomNode
extends GraphNode

@export var roomData: Room : set = roomDataSet
@onready var roomName: Label = $RoomName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateView(roomData)


func roomDataSet(newData: Room) -> void:
	updateView(newData)
	roomData = newData


func updateView(data: Room) -> void:
	if roomData != null:
		title = data.uniqueKey
		updateName(data.name)
	else:
		clearView()

func clearView() -> void:
	title = ""
	updateName("")

func updateName(newName: String) -> void:
	if roomName == null:
		return
	roomName.text = newName