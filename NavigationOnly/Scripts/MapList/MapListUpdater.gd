extends Node
class_name MapListUpdater

signal game_selected(editorGame: EditorGame)

@export
var games: Array[MapListItemInfo] = []:
	set(value):
		games = value
		# right, I need some way to actually handle the list changing.... Or do I.....
		updateList()


@onready
var listItemScene: PackedScene = preload("res://NavigationOnly/Scenes/MapListItem.tscn")
@onready
var noChildItem: Control = %NoChildItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateList()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_selected_in_list(mapListItemInfo: MapListItemInfo) -> void:
	game_selected.emit(mapListItemInfo)

func removeAllChildren() -> void:
	for child in get_children():
		if child is MapListItem:
			child.mapSelectedInMapList.disconnect(game_selected_in_list)
			child.queue_free()

func addAllChildren() -> void:
	var newNode: MapListItem
	for game in games:
		newNode = listItemScene.instantiate()
		newNode.mapListItemInfo = game
		newNode.mapSelectedInMapList.connect(game_selected_in_list)
		add_child(newNode)


func showNoChildItemIfEmpty() -> void:
	noChildItem.visible = games.size() == 0


func updateList() -> void:
	if not is_node_ready():
		return
	# easy peasy, lemon brute force squeezy
	removeAllChildren()
	addAllChildren()


func tryGrabFocus() -> void:
	for child in get_children():
		if child is MapListItem:
			child.tryGrabFocus()
			return
