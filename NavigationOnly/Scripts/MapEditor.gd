extends Control

@onready
var itemEditor: ItemEditor = %ItemEditor

var _currentItem: Item

#var _currentGame: EditorGame


func _item_selected(item: Item) -> void:
	_currentItem = item
	itemEditor.item = item


func _on_center_container_item_selected(item: Item) -> void:
	_item_selected(item)
